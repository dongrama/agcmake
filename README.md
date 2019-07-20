# abcmake

Cmake-based extension to work with CMake projects in a python modules style. 
Define only folder structure and imported of Child (nested projects)

Common project structure:

```
+[Project]
|
|---+[abcmake]
|---+[sub_project1]
|   |---+[sub_sub_project]
|   |   |--[abcmake]
|   |   |--CMakeLists.txt
|   |   |---*.cpp
|   |   '---*.h
|   |--[abcmake]
|   |--CMakeLists.txt
|   |---*.cpp
|   '---*.h
|---+[sub_project2]
|   |--[abcmake]
|   |--CMakeLists.txt
|   |---*.cpp
|   '---*.h
|---CMakeLists.txt
|---*.cpp
'---*.h
```

## How to turn your sources into abcmake project

1. Create a folder i.e. Project
2. Move all headers and sources to it
3. Copy `abcmake` folder to `Project`
4. Copy `abcmake/CMakeList.txt` to  `Project`

If you want to add a sub-project:
- Init it with 1-4 steps (e.g in `SubProject`)
- Copy `SubProject` to `Project`
- Add `SubProject` into `Project\CMakeFiles.txt` into line 3:
```cmake
cmake_minimum_required(VERSION 3.13)

set(CHILDS SubProject)
include(abcmake/ab.cmake)

## Test exe - if needed
#add_executable(main main.cpp)
#target_link_libraries(main ${PROJECT_NAME})

```

## Working with CLion
Just follow the folder structure. CLion works perfectly


## How-to build a lib with Ninja
Execute:
```
 cmake -G "Ninja" -S . -B ./build
 cd ./build; ninja; ninja install; cd ..
```
You'll get folders:
```
PROJECT_NAME_lib/include
PROJECT_NAME_lib/lib
```
You could use it in any ide with other projects