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

set(IRIS_EVENT_VERSION "1.4.2")

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

target_include_directories(${LIBRARY_NAME} PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/third_party/dart-sdk/include"
)

if (CMAKE_SYSTEM_NAME STREQUAL "Android") 
elseif (CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set_target_properties(${LIBRARY_NAME} PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        MACOSX_FRAMEWORK_IDENTIFIER io.agora.iris.event
        MACOSX_FRAMEWORK_SHORT_VERSION_STRING "${IRIS_EVENT_VERSION}"
        MACOSX_FRAMEWORK_BUNDLE_VERSION "${IRIS_EVENT_VERSION}"
        CXX_VISIBILITY_PRESET hidden
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
    set(CMAKE_XCODE_ATTRIBUTE_MACOSX_DEPLOYMENT_TARGET "10.11")
    set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym")
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
