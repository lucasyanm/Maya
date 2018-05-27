#Compiler
CC = g++

#External deppendencies
ifeq ($(OS), Windows_NT)
SDL_INCLUDE_PATH = -Iextern\windows\mingw\SDL2\include
GLEW_INCLUDE_PATH = -Iextern\windows\mingw\glew-2.0.0\include
TINYXML2_INCLUDE_PATH = -Iextern\windows\mingw\tinyxml2-6.2.0\include
LUA_INCLUDE_PATH = -Iextern\windows\mingw\lua-5.3.4\include
INCLUDE_PATHS = $(SDL_INCLUDE_PATH) $(GLEW_INCLUDE_PATH) $(TINYXML2_INCLUDE_PATH) $(LUA_INCLUDE_PATH)
endif
ifeq ($(OS), Linux)
endif

#Additional libraries
ifeq ($(OS), Windows_NT)
SDL_LIB_PATH = -Lextern\windows\mingw\SDL2\lib
GLEW_LIB_PATH = -Lextern\windows\mingw\glew-2.0.0\lib
LUA_LIB_PATH = -Lextern\windows\mingw\lua-5.3.4\lib
TINYXML2_LIB_PATH = -Lextern\windows\mingw\tinyxml2-6.2.0\lib
LIB_PATHS = $(SDL_LIB_PATH) $(LUA_LIB_PATH) $(GLEW_LIB_PATH) $(TINYXML2_LIB_PATH)
endif
ifeq ($(OS), LINUX)
endif

LINKER_FLAGS = -lmingw32 -lSDL2main -lSDL2 -lOpenGL32 -lglew32 -lglu32 -llua53 -ltinyxml2
ifeq ($(OS), Windows_NT)
COMPILER_FLAGS = -Wall
endif
ifeq ($(OS), Linux)
endif

SOURCES = $(wildcard src/*.cpp)
OBJECTS = $(patsubst src/%.cpp, build/%.o, $(SOURCES))

bin/Application.exe: $(OBJECTS)
	$(info $@:)
	$(CC) $(OBJECTS) $(LIB_PATHS) $(LINKER_FLAGS) $(COMPILER_FLAGS) -o bin/Application

build/%.o: src/%.cpp
	$(info $@:)
	$(CC) -c $< $(INCLUDE_PATHS) $(COMPILER_FLAGS) -o $@

build/%.o: src/%.cpp include/%.h
	$(info $@:)
	$(CC) -c $< $(INCLUDE_PATHS) $(COMPILER_FLAGS) -o $@

clean:
ifeq ($(OS), Windows_NT)
	del build\*.o bin\*.exe src\*.o
endif
ifeq ($(OS), Linux)
	rm build/*.o
endif


# bin/Application.exe: build/Shader.o build/Window.o build/Vector2D.o build/VertexArray.o build/Texture.o build/Game.o \
#  	build/LuaScript.o build/Renderer.o build/InputModule.o build/VertexBuffer.o build/IndexBuffer.o build/Application.o
# 	g++ build/Window.o build/Vector2D.o build/Shader.o build/LuaScript.o build/Renderer.o build/Texture.o build/Game.o \
# 	build/InputModule.o build/VertexBuffer.o build/IndexBuffer.o build/VertexArray.o build/Application.o \
# 	$(LUA_LIB_PATH) $(SDL_LIB_PATH) $(GLEW_LIB_PATH) $(TINYXML2_LIB_PATH) $(LINKER_FLAGS) $(COMPILER_FLAGS) \
# 	-o bin/Application

# build/Application.o: src/Application.cpp
# 	g++ -c src/Application.cpp $(SDL_INCLUDE_PATH) $(TINYXML2_INCLUDE_PATH) $(GLEW_INCLUDE_PATH) $(LUA_INCLUDE_PATH) $(COMPILER_FLAGS) \
# 	-o build/Application.o

# build/Shader.o: include/Shader.h src/Shader.cpp
# 	g++ -c src/Shader.cpp $(GLEW_INCLUDE_PATH) $(COMPILER_FLAGS) -o build/Shader.o

# build/Window.o: src/Window.cpp
# 	g++ -c src/Window.cpp $(SDL_INCLUDE_PATH) $(GLEW_INCLUDE_PATH) $(SDL_LIB_PATH) $(LINKER_FLAGS) $(COMPILER_FLAGS) -o build/Window.o

# build/Vector2D.o: include/Vector2D.h src/Vector2D.cpp
# 	g++ -c src/Vector2D.cpp $(COMPILER_FLAGS) -o build/Vector2D.o

# build/LuaScript.o: src/LuaScript.cpp include/LuaScript.h
# 	g++ -c src/LuaScript.cpp $(LUA_INCLUDE_PATH) $(COMPILER_FLAGS) -o build/LuaScript.o

# build/Renderer.o: include/Renderer.h src/Renderer.cpp
# 	g++ -c src/Renderer.cpp $(GLEW_INCLUDE_PATH) -o build/Renderer.o

# build/InputModule.o: include/InputModule.h src/InputModule.cpp
# 	g++ -c src/InputModule.cpp $(SDL_INCLUDE_PATH) -o build/InputModule.o

# build/VertexBuffer.o: include/VertexBuffer.h src/VertexBuffer.cpp
# 	g++ -c src/VertexBuffer.cpp $(GLEW_INCLUDE_PATH) -o build/VertexBuffer.o

# build/IndexBuffer.o: include/IndexBuffer.h src/IndexBuffer.cpp
# 	g++ -c src/IndexBuffer.cpp $(GLEW_INCLUDE_PATH) -o build/IndexBuffer.o

# build/Texture.o: include/Texture.h src/Texture.cpp
# 	g++ -c src/Texture.cpp ${GLEW_INCLUDE_PATH} -o build/Texture.o

# build/VertexArray.o: include/VertexArray.h src/VertexArray.cpp
# 	g++ -c src/VertexArray.cpp ${GLEW_INCLUDE_PATH} -o build/VertexArray.o

# build/Game.o: include/Game.h src/Game.cpp
# 	g++ -c src/Game.cpp $(LUA_INCLUDE_PATH) $(GLEW_INCLUDE_PATH) $(SDL_INCLUDE_PATH) $(COMPILER_FLAGS) -o build/Game.o

