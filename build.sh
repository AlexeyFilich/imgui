#!/bin/bash

bin_dir_path=$(pwd -P)/bin
build_dir_path=$(pwd -P)/build

cd $(dirname ${BASH_SOURCE[0]})
project_path=$(pwd -P)

# Start of user config

BACKENDS=("./backends/imgui_impl_glfw.cpp" "./backends/imgui_impl_opengl3.cpp")

SOURCES=($(find . -type f -name "*.cpp" ! -path "./backends/*" ! -path "./examples/*" ! -path "./misc/*") "${BACKENDS[@]}")

INCLUDE_PATH=("." "D:\workspace\dev\cpp\mingw64\include" "D:\workspace\dev\cpp\mingw64\x86_64-w64-mingw32\include" "D:\workspace\dev\cpp\glfw\include")
LIB_PATH=("D:\workspace\dev\cpp\mingw64\lib" "D:\workspace\dev\cpp\mingw64\x86_64-w64-mingw32\lib" "D:\workspace\dev\cpp\glfw\lib-mingw-w64")

CC=g++.exe
CFLAGS=(-std=c++17 -static-libstdc++ -static-libgcc -MMD)
CLIBS=(-lmingw32 -lopengl32 -lgdi32 -lglfw3)
CONVERT_TO_WIN_PATH=true

# End of user config

INCLUDES=$(printf -- "-I%s " ${INCLUDE_PATH[@]})
LIBS=$(printf -- "-L%s " ${LIB_PATH[@]})

for source in ${SOURCES[@]}
do
    outpath="${build_dir_path}/$(dirname ${BASH_SOURCE[0]})/$(dirname ${source})/$(basename ${source}).o"
    mkdir -p $(dirname ${outpath}) && touch ${outpath}
    if ${CONVERT_TO_WIN_PATH}; then
        outpath=$(wslpath -m ${outpath})
        source=$(wslpath -m ${project_path}/${source})
    else
        source=${project_path}/${source}
    fi

    echo ${CC} -c ${CFLAGS[@]} ${INCLUDES::-1} ${source} -o ${outpath}
    ${CC} -c ${CFLAGS[@]} ${INCLUDES::-1} ${source} -o ${outpath}
done

if [ ! -z ${MAIN} ]; then
    source=${MAIN}
    outpath="${build_dir_path}/$(dirname ${BASH_SOURCE[0]})/$(dirname ${source})/$(basename ${source}).o"
    mkdir -p $(dirname ${outpath}) && touch ${outpath}
    if ${CONVERT_TO_WIN_PATH}; then
        outpath=$(wslpath -m ${outpath})
        source=$(wslpath -m ${project_path}/${source})
    else
        source=${project_path}/${source}
    fi

    OBJ=($(find build -type f -name "*.o" ! -name "$(basename ${MAIN}).o"))
    for i in "${!OBJ[@]}"; do OBJ[$i]=$(wslpath -m ${OBJ[$i]}); done

    echo ${CC} ${CFLAGS[@]} ${INCLUDES::-1} ${LIBS::-1} ${source} -o ${outpath} ${OBJ[@]} ${CLIBS[@]}
    ${CC} ${CFLAGS[@]} ${INCLUDES::-1} ${LIBS::-1} ${source} -o ${outpath} ${OBJ[@]} ${CLIBS[@]}
fi

# Post build
