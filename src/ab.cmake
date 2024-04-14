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
# *************************************************************************

set(ABCMAKE_VERSION_MAJOR 4)
set(ABCMAKE_VERSION_MINOR 0)
set(ABCMAKE_VERSION_PATCH 0)
set(ABCMAKE_VERSION "${ABCMAKE_VERSION_MAJOR}.${ABCMAKE_VERSION_MINOR}.${ABCMAKE_VERSION_PATCH}")

# *************************************************************************
# Private functions
# *************************************************************************

function(_abc_AddProject Path )
    add_subdirectory(${Path})
endfunction()

# Add all projects from the lib subdirectory
function(_abc_AddLibs TargetName)
    # List of possible subprojects
    file(GLOB children RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/lib ${CMAKE_CURRENT_SOURCE_DIR}/lib/*)
    
    # Link all subprojects to the ${TargetName}
    foreach(child ${children})
        if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib/${child})
            message(DEBUG "${TargetName} found ${child}")
            _abc_AddProject(${CMAKE_CURRENT_SOURCE_DIR}/lib/${child})
            get_directory_property(is_abcmake DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib/${child} ABCMAKE_VERSION)
            if (is_abcmake STREQUAL "")
                message (STATUS "❌ ${child} is not a ABCMAKE project. Handle it manually.")
            else()
                get_directory_property(to_link DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib/${child} ABCMAKE_TARGETS)
                message (STATUS "✅ Linking ${to_link} to ${TargetName}")
                target_link_libraries(${TargetName} PRIVATE to_link)
            endif()
        endif()
    endforeach()
    
endfunction()

# Add files from the ./src, ./include, ./lib to the project
function(_abc_AddFiles TargetName)
    file(GLOB_RECURSE SOURCES "src/*.cpp" "src/*.c")
    message( DEBUG "${TargetName} sources: ${SOURCES}")
    target_sources(${TargetName} PRIVATE ${SOURCES})
    message( DEBUG "${TargetName} include: ${CMAKE_CURRENT_SOURCE_DIR}/include")
    target_include_directories(${TargetName} PUBLIC include)
endfunction()

function(_abc_Install TargetName)
    # install directory
    # if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../install"
        CACHE PATH "default install path" FORCE)
    # endif()
    install(TARGETS ${TargetName} DESTINATION ".")
endfunction()

# *************************************************************************
# Public functions
# *************************************************************************

# Add to the project all files from ./src, ./include, ./lib
function(target_abcmake TargetName)

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
        
    _abc_AddFiles(${TargetName})
    _abc_AddLibs(${TargetName})
    _abc_Install(${TargetName})

endfunction()