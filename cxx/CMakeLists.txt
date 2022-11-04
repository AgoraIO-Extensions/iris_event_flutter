cmake_minimum_required(VERSION 3.10.2)

set(CMAKE_CXX_STANDARD 14)

if (POLICY CMP0064)
    cmake_policy(SET CMP0064 NEW)
endif (POLICY CMP0064)

if (POLICY CMP0042)
    cmake_policy(SET CMP0042 NEW)
endif (POLICY CMP0042)

project(iris_event_handler)

set(LIBRARY_NAME iris_event_handler)

set(IRIS_EVENT_VERSION "2.0.0")

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(IRIS_EVENT_DEBUG 1)
else ()
    set(IRIS_EVENT_DEBUG 0)
endif ()
message(STATUS "IRIS_EVENT_DEBUG ${IRIS_EVENT_DEBUG}")

set(MACOSX_DEPLOYMENT_TARGET "10.11")

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG")
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG")
else ()
    # set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g")
endif ()

if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_XCODE_ATTRIBUTE_MACOSX_DEPLOYMENT_TARGET ${MACOSX_DEPLOYMENT_TARGET})
    set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -fPIC")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fPIC")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Windows")
   
    if (MSVC)
        if (NOT IRIS_EVENT_DEBUG)       
            add_compile_options(
                    $<$<CONFIG:>:/MT> #---------|
                    $<$<CONFIG:Debug>:/MTd> #---|-- Statically link the runtime libraries
                    $<$<CONFIG:Release>:/MT> #--|
            )
        else()
            add_compile_options(
                    $<$<CONFIG:>:/MD> #---------|
                    $<$<CONFIG:Debug>:/MDd> #---|-- Statically link the runtime libraries
                    $<$<CONFIG:Release>:/MD> #--|
            )
        endif ()
    endif ()
endif ()

set(SOURCES 
     "${CMAKE_CURRENT_SOURCE_DIR}/src/iris_event.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/src/iris_event.cc"
     "${CMAKE_CURRENT_SOURCE_DIR}/third_party/dart-sdk/include/dart_api_dl.c"
     "${CMAKE_CURRENT_SOURCE_DIR}/src/iris_life_cycle_observer.h"
     )

if (APPLE)
     list(APPEND SOURCES
        "${CMAKE_CURRENT_SOURCE_DIR}/src/iris_life_cycle_observer.mm"
             )
else()
    list(APPEND SOURCES
        "${CMAKE_CURRENT_SOURCE_DIR}/src/iris_life_cycle_observer.cc"
        )
endif ()

add_library(${LIBRARY_NAME} SHARED
            ${SOURCES}
            )

set_target_properties(${LIBRARY_NAME} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    )

target_include_directories(${LIBRARY_NAME} PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/third_party/dart-sdk/include"
)

if (CMAKE_SYSTEM_NAME STREQUAL "Android") 
    if (NOT IRIS_EVENT_DEBUG)
        add_custom_command(
                TARGET ${LIBRARY_NAME}
                POST_BUILD
                COMMAND cp -RP
                "${CMAKE_BINARY_DIR}/lib${LIBRARY_NAME}.so"
                "${CMAKE_BINARY_DIR}/lib${LIBRARY_NAME}Symbol.so"
        )
        add_custom_command(
                TARGET ${LIBRARY_NAME}
                POST_BUILD
                COMMAND "${ANDROID_TOOLCHAIN_PREFIX}strip" -g -S -d --strip-debug --verbose
                "${CMAKE_BINARY_DIR}/lib${LIBRARY_NAME}.so"
                COMMENT "Strip debug symbols done on final binary."
        )
    endif ()
elseif (CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set_target_properties(${LIBRARY_NAME} PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        MACOSX_FRAMEWORK_IDENTIFIER io.agora.iris.event
        MACOSX_FRAMEWORK_SHORT_VERSION_STRING "${IRIS_EVENT_VERSION}"
        MACOSX_FRAMEWORK_BUNDLE_VERSION "${IRIS_EVENT_VERSION}"
        CXX_VISIBILITY_PRESET hidden
        COMPILE_OPTIONS "-g"
        )
    set(FRAMEWORKS
        "-framework Foundation"
        "-framework UIKit"
        )
    target_link_libraries(${LIBRARY_NAME}
        PRIVATE
        "${FRAMEWORKS}"
        )

elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_XCODE_ATTRIBUTE_MACOSX_DEPLOYMENT_TARGET ${MACOSX_DEPLOYMENT_TARGET})
    set_target_properties(${LIBRARY_NAME} PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        MACOSX_FRAMEWORK_IDENTIFIER io.agora.iris.event
        MACOSX_FRAMEWORK_SHORT_VERSION_STRING "${IRIS_EVENT_VERSION}"
        MACOSX_FRAMEWORK_BUNDLE_VERSION "${IRIS_EVENT_VERSION}"
        CXX_VISIBILITY_PRESET hidden
        COMPILE_OPTIONS "-g"
        )
    set(FRAMEWORKS
        "-framework Foundation"
        "-framework AppKit"
        )
    target_link_libraries(${LIBRARY_NAME}
        PRIVATE
        "${FRAMEWORKS}"
        )
else()
endif()
