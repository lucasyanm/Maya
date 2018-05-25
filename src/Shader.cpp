#include "../include/Shader.h"

#include <fstream>
#include <sstream>
#include <GL/glu.h>

#include "../include/ErrorHandler.h"

Shader::Shader(const std::string& vsFilepath, const std::string& fsFilepath)
  : _vertexShaderFilepath(vsFilepath), _fragmentShaderFilepath(fsFilepath)
{
  _shaderSource = ParseShader(vsFilepath, fsFilepath);
  _programID = CreateShader(_shaderSource);
}

Shader::~Shader() {
  glDeleteProgram(_programID);
}

void Shader::Bind() {
  glUseProgram(this->_programID);
}

void Shader::Unbind() {
  glUseProgram(0);
}

void Shader::SetUniform1f(const char* name, float v0){
  glUniform1f(GetUniformLocation(name), v0);
}

void Shader::SetUniform2f(const char* name, float v0, float v1){
  glUniform2f(GetUniformLocation(name), v0, v1);
}

void Shader::SetUniform3f(const char* name, float v0, float v1, float v2) {
  glUniform3f(GetUniformLocation(name), v0, v1, v2);
}

void Shader::SetUniform4f(const char* name, float v0, float v1, float v2, float v3){
  glUniform4f(GetUniformLocation(name), v0, v1, v2, v3);
}

void Shader::PrintActiveAttributes() const {
  GLint i;
  GLint count;
  GLint size;
  GLenum type;

  const GLsizei bufSize = 16;
  GLchar name[bufSize];
  GLsizei length;

  glGetProgramiv(_programID, GL_ACTIVE_ATTRIBUTES,  &count);
  std::cout << "There are " << count << " active attributes.\n";

  for(i = 0; i < count; i++) {
    glGetActiveAttrib(_programID, (GLuint)i, bufSize, &length, &size, &type, name);
    std::cout << "Attribute " << i << " type " << type << " name " << name << "\n";
  }
}

void Shader::PrintActiveUniforms() const {
  GLint i;
  GLint count;
  GLint size;
  GLenum type;

  const GLsizei bufSize = 16;
  GLchar name[bufSize];
  GLsizei length;

  glGetProgramiv(_programID, GL_ACTIVE_UNIFORMS,  &count);
  std::cout << "There are " << count << " active uniforms.\n";

  for(i = 0; i < count; i++) {
    glGetActiveUniform(_programID, (GLuint)i, bufSize, &length, &size, &type, name);
    std::cout << "Uniform " << i << " type " << type << " name " << name << std::endl;
  }
}

ShaderSource Shader::ParseShader(const std::string& vsFilepath, const std::string& fsFilepath) {
  std::ifstream vsFile(vsFilepath.c_str());
  std::ifstream fsFile(fsFilepath.c_str());

  std::stringstream vsSource;
  std::stringstream fsSource;

  std::string line;

  // Checks if vsFile was opened successfully
  if(vsFile.fail()) {
    LOG_ERROR("Unable to open file " + vsFilepath);
    DEBUG_BREAK();
  }

  // Checks if fsFile was opened succesfully
  if(fsFile.fail()) {
    LOG_ERROR("Unable to open file " + fsFilepath);
    DEBUG_BREAK();
  }

  // Reads vertex shader file to string vsSource
  while(getline(vsFile, line)) {
    vsSource << line << '\n';
  }

  // Reads fragment shader file to string fsSource
  while(getline(fsFile, line)) {
    fsSource << line << '\n';
  }

  ShaderSource shaderSource;
  shaderSource.vertexShaderSource = vsSource.str();
  shaderSource.fragmentShaderSource = fsSource.str();

  return shaderSource;
}

GLuint Shader::CreateShader(const ShaderSource& shaderSource) {
  GLuint programID = glCreateProgram();

  GLuint vs = CompileShader(GL_VERTEX_SHADER, shaderSource.vertexShaderSource);
  GLuint fs = CompileShader(GL_FRAGMENT_SHADER, shaderSource.fragmentShaderSource);

  glAttachShader(programID, vs);
  glAttachShader(programID, fs);
  glLinkProgram(programID);

  return programID;
}

GLuint Shader::CompileShader(GLenum shaderType, const std::string& source) {
  GLuint shader = glCreateShader(shaderType);

  const char* src = source.c_str();
  glShaderSource(shader, 1, &src, NULL);
  glCompileShader(shader);

  GLint compileStatus;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
  if(compileStatus != GL_TRUE) {
    GLchar log[512];
    glGetShaderInfoLog(shader, 512, NULL, log);
    LOG_ERROR("Unable to compile shader: file: " +
      (shaderType == GL_VERTEX_SHADER ? _vertexShaderFilepath : _fragmentShaderFilepath) +
      std::string(" \n") + std::string(log));
  }

  return shader;
}

GLint Shader::GetUniformLocation(const std::string& name) {
  GLint location = glGetUniformLocation(this->_programID, name.c_str());

  // If uniform isn't found in program
  if(location == -1) LOG_ERROR("Unable to find uniform: " + name);

  return location;
}
