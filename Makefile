CC := g++.exe
CFLAGS := -std=c++17 -static-libstdc++ -static-libgcc
LDFLAGS := -lmingw32 -lopengl32 -lgdi32 -lglfw3
INCLUDE_PATH := "." "D:\workspace\dev\cpp\mingw64\include" "D:\workspace\dev\cpp\mingw64\x86_64-w64-mingw32\include" "D:\workspace\dev\cpp\glfw\include"
LIB_PATH := "D:\workspace\dev\cpp\mingw64\lib" "D:\workspace\dev\cpp\mingw64\x86_64-w64-mingw32\lib" "D:\workspace\dev\cpp\glfw\lib-mingw-w64"

BUILDDIIR := build

BACKENDS := ./backends/imgui_impl_glfw.cpp ./backends/imgui_impl_opengl3.cpp
SOURCES := $(shell find . -type f -name "*.cpp" ! -path "./backends/*" ! -path "./examples/*" ! -path "./misc/*")
SOURCES += $(BACKENDS)
OBJECTS := $(patsubst %.cpp, $(BUILDDIIR)/%.o, $(SOURCES))

CFLAGS += -MMD
IPATH := $(patsubst %, -I%, $(INCLUDE_PATH))
LPATH := $(patsubst %, -L%, $(LIB_PATH))

all: $(OBJECTS)

$(BUILDDIIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(IPATH) -c $< -o $@

.PHONY: clean

clean:
	rm -rf build
