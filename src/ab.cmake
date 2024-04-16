# *************************************************************************
#
# Copyright (c) 2024 Andrei Gramakov. All rights reserved.
#
# This file is licensed under the terms of the MIT license.  
# For a copy, see: https://opensource.org/licenses/MIT
#
# site:    https://agramakov.me
# e-mail:  mail@agramakov.me
#
# Andrei's Build CMake subsystem or abcmake is a CMake module to work 
# with C/C++ project of a predefined standard structure in order to 
# simplify the build process.
# 
# Source Code: https://github.com/an-dr/abcmake
# *************************************************************************

set(ABCMAKE_VERSION_MAJOR 4)
set(ABCMAKE_VERSION_MINOR 2)
set(ABCMAKE_VERSION_PATCH 0)
set(ABCMAKE_VERSION "${ABCMAKE_VERSION_MAJOR}.${ABCMAKE_VERSION_MINOR}.${ABCMAKE_VERSION_PATCH}")


# *************************************************************************
# Private functions
# *************************************************************************

function(_abc_AddProject Path OUT_ABCMAKE_VER)
    if (EXISTS ${Path}/CMakeLists.txt)
        message(DEBUG "Adding project ${Path}")
        add_subdirectory(${Path})
        
        get_directory_property(version DIRECTORY ${Path} ABCMAKE_VERSION)
        set(${OUT_ABCMAKE_VER} ${version} PARENT_SCOPE)
        if (NOT version)
            message (STATUS "  ❌ ${Path} is not an ABCMAKE project. Handle it manually.")
        endif()
        
    else()
        message (STATUS "  📁 ${Path} is not a CMake project")
    endif()
endfunction()

# Add all projects from the lib subdirectory
function(_abc_AddComponents TargetName)
    # List of possible subprojects
    file(GLOB children RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/components ${CMAKE_CURRENT_SOURCE_DIR}/components/*)
    
    # Link all subprojects to the ${TargetName}
    foreach(child ${children})
        if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/components/${child})
            target_abcmake_component(${TargetName} ${CMAKE_CURRENT_SOURCE_DIR}/components/${child})
        endif()
    endforeach()
    
endfunction()


# *************************************************************************
# Public functions
# *************************************************************************

# Add all source files from the specified directory to the target
function(target_sources_directory TARGETNAME SOURCE_DIR)
    file(GLOB_RECURSE SOURCES "${SOURCE_DIR}/*.cpp" "${SOURCE_DIR}/*.c")
    message( DEBUG "${TARGETNAME} sources: ${SOURCES}")
    target_sources(${TARGETNAME} PRIVATE ${SOURCES})
endfunction()

# Add to the project all files from ./src, ./include, ./lib
function(target_init_abcmake TargetName)

    get_directory_property(hasParent PARENT_DIRECTORY)
    # if no parent, print the name of the target
    if (NOT hasParent)
        message(STATUS "🔤 ${TargetName}")
    endif ()
    
    # Report version
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY 
                 ABCMAKE_VERSION ${ABCMAKE_VERSION})
                 
    # Add target to the target list
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY
                 ABCMAKE_TARGETS ${TargetName})
        
    target_sources_directory(${TargetName} "src")
    target_include_directories(${TargetName} PUBLIC "include")
    _abc_AddComponents(${TargetName})
    target_install_near_build(${TargetName})

endfunction()

function (target_abcmake_component TARGETNAME COMPONENTPATH)
    _abc_AddProject(${COMPONENTPATH} ver)
    if (ver)
        get_directory_property(to_link DIRECTORY ${COMPONENTPATH} ABCMAKE_TARGETS)
        message (STATUS "  ✅ Linking ${to_link} to ${TARGETNAME}")
        target_link_libraries(${TARGETNAME} PRIVATE ${to_link})
    endif()
endfunction()


function(target_install_near_build TARGETNAME)
    # install directory
    # if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../install"
        CACHE PATH "default install path" FORCE)
    # endif()
    install(TARGETS ${TARGETNAME} DESTINATION ".")
endfunction()
