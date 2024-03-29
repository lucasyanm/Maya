#Compiler
CC = g++

#External deppendencies
ifeq ($(OS), Windows_NT)
SDL_INCLUDE_PATH = -Iextern\windows\mingw\SDL2\include
GLEW_INCLUDE_PATH = -Iextern\windows\mingw\glew-2.0.0\include
TINYXML2_INCLUDE_PATH = -Iextern\windows\mingw\tinyxml2-6.2.0\include
LUA_INCLUDE_PATH = -Iextern\windows\mingw\lua-5.3.4\include
TINYXML_INCLUDE_PATH = -Iextern\windows\mingw\tinyxml\include
INCLUDE_PATHS = $(SDL_INCLUDE_PATH) $(GLEW_INCLUDE_PATH) $(TINYXML2_INCLUDE_PATH) $(LUA_INCLUDE_PATH) $(TINYXML_INCLUDE_PATH)
endif
ifeq ($(OS), Linux)
endif

#Additional libraries
ifeq ($(OS), Windows_NT)
SDL_LIB_PATH = -Lextern\windows\mingw\SDL2\lib
GLEW_LIB_PATH = -Lextern\windows\mingw\glew-2.0.0\lib
LUA_LIB_PATH = -Lextern\windows\mingw\lua-5.3.4\lib
TINYXML2_LIB_PATH = -Lextern\windows\mingw\tinyxml2-6.2.0\lib
TINYXML_LIB_PATH = -Lextern\windows\mingw\tinyxml\lib
LIB_PATHS = $(SDL_LIB_PATH) $(LUA_LIB_PATH) $(GLEW_LIB_PATH) $(TINYXML2_LIB_PATH) $(TINYXML_LIB_PATH)
endif
ifeq ($(OS), LINUX)
endif

LINKER_FLAGS = -lmingw32 -lSDL2main -lSDL2 -lOpenGL32 -lglew32 -lglu32 -llua53 -ltinyxml2 -ltinyxml
ifeq ($(OS), Windows_NT)
COMPILER_FLAGS = -Wall
endif
ifeq ($(OS), Linux)
endif

SOURCES = $(wildcard src/*.cpp)
OBJECTS = $(patsubst src/%.cpp, build/%.o, $(SOURCES))

bin/Application.exe: $(OBJECTS)
	$(info $(patsubst bin/%,%:, $@))
	$(CC) $(OBJECTS) $(LIB_PATHS) $(LINKER_FLAGS) $(COMPILER_FLAGS) -o bin/Application
	@echo =======================
	@echo Make: COMPILATION SUCCEEDED

build/%.o: src/%.cpp
	$(info $(patsubst build/%,%:, $@))
	$(CC) -c $< $(INCLUDE_PATHS) $(COMPILER_FLAGS) -o $@
	@echo =======================  

build/%.o: src/%.cpp include/%.h
	$(info $(patsubst build/%,%:, $@))
	$(CC) -c $< $(INCLUDE_PATHS) $(COMPILER_FLAGS) -o $@
	@echo =======================

clean:
ifeq ($(OS), Windows_NT)
	del build\*.o
endif
ifeq ($(OS), Linux)
	rm build/*.o

endif