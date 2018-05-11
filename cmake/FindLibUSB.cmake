# - Find libusb for portable USB support
# This module will find libusb as published by
#  http://libusb.sf.net and
#  http://libusb-win32.sf.net
#
# It will use PkgConfig if present and supported, else search
# it on its own. If the LibUSB_ROOT_DIR environment variable
# is defined, it will be used as base path.
# The following standard variables get defined:
#  LibUSB_FOUND:        true if LibUSB was found
#  LibUSB_HEADER_FILE:  the location of the C header file
#  LibUSB_INCLUDE_DIRS: the directory that contains the include file
#  LibUSB_LIBRARIES:    the CMake targets

include(CheckLibraryExists)
include(CheckIncludeFile)

find_package(PkgConfig)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PKGCONFIG_LIBUSB libusb-1.0)
  if(NOT PKGCONFIG_LIBUSB_FOUND)
    pkg_check_modules(PKGCONFIG_LIBUSB libusb)
  endif()
endif()

if(PKGCONFIG_LIBUSB_FOUND)
  set(LibUSB_INCLUDE_DIRS ${PKGCONFIG_LIBUSB_INCLUDEDIR})
  foreach(i ${PKGCONFIG_LIBUSB_LIBRARIES})
    string(REGEX MATCH "[^-]*" ibase "${i}")
    find_library(${ibase}_LIBRARY
      NAMES ${i}
      PATHS ${PKGCONFIG_LIBUSB_LIBRARY_DIRS}
      )
    if(${ibase}_LIBRARY)
      list(APPEND usb_LIBRARY ${${ibase}_LIBRARY})
    endif ()
    mark_as_advanced(${ibase}_LIBRARY)
  endforeach()
  LIST(REMOVE_DUPLICATES usb_LIBRARY)
else ()
  find_file(LibUSB_HEADER_FILE
    NAMES
      libusb.h usb.h
    PATHS
      ${LibUSB_ROOT_DIR}
      $ENV{ProgramFiles}/LibUSB-Win32
      $ENV{LibUSB_ROOT_DIR}
    PATH_SUFFIXES
      include/libusb-1.0
  )
  mark_as_advanced(LibUSB_HEADER_FILE)
  get_filename_component(LibUSB_INCLUDE_DIRS "${LibUSB_HEADER_FILE}" PATH)
  get_filename_component(LibUSB_INCLUDE_DIRS "${LibUSB_INCLUDE_DIRS}" PATH)

  if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    # LibUSB-Win32 binary distribution contains several libs.
    # Use the lib that got compiled with the same compiler.
    if(MSVC)
      if(${CMAKE_GENERATOR} MATCHES "Win64")
        set(LibUSB_STATIC_LIBRARY_PATH_SUFFIX
          MS64/static
          lib/x64
          )
        set(LibUSB_LIBRARY_PATH_SUFFIX
          MS64/dll
          bin/x64
          )
      else()
        set(LibUSB_STATIC_LIBRARY_PATH_SUFFIX
          MS32/static
          lib/Win32
          )
        set(LibUSB_LIBRARY_PATH_SUFFIX
          MS32/dll
          bin/Win32
          )
      endif()
    elseif(BORLAND)
      set(LibUSB_LIBRARY_PATH_SUFFIX lib/bcc)
    elseif(CMAKE_COMPILER_IS_GNUCC)
      set(LibUSB_LIBRARY_PATH_SUFFIX lib/gcc)
    endif()
  endif()

  find_library(usb_LIBRARY
    NAMES
      usb-1.0 libusb usb libusb-1.0
    PATHS
      $ENV{ProgramFiles}/LibUSB-Win32
      $ENV{LibUSB_ROOT_DIR}
      ${LibUSB_ROOT_DIR}
    PATH_SUFFIXES
      ${LibUSB_STATIC_LIBRARY_PATH_SUFFIX}
    )
  mark_as_advanced(usb_LIBRARY)

  find_file(usb_SHARED_LIBRARY
    NAMES
      usb-1.0${CMAKE_SHARED_LIBRARY_SUFFIX}
      libusb${CMAKE_SHARED_LIBRARY_SUFFIX}
      usb${CMAKE_SHARED_LIBRARY_SUFFIX}
      libusb-1.0${CMAKE_SHARED_LIBRARY_SUFFIX}
    PATHS
      $ENV{ProgramFiles}/LibUSB-Win32
      $ENV{LibUSB_ROOT_DIR}
      ${LibUSB_ROOT_DIR}
    PATH_SUFFIXES
      ${LibUSB_LIBRARY_PATH_SUFFIX}
    )
    mark_as_advanced(usb_SHARED_LIBRARY)
endif()

SET(LibUSB_LIBRARIES LibUSB)

# handle the QUIETLY and REQUIRED arguments and set LibUSB_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibUSB DEFAULT_MSG
  usb_LIBRARY
  LibUSB_INCLUDE_DIRS
 )

if(LibUSB_FOUND)
  check_library_exists("${usb_LIBRARY}" usb_open "" LibUSB_FOUND)
  check_library_exists("${usb_LIBRARY}" libusb_get_device_list "" LibUSB_VERSION_1.0)
endif()

if(${usb_LIBRARY} MATCHES ${CMAKE_STATIC_LIBRARY_SUFFIX})
  ADD_LIBRARY(LibUSB STATIC IMPORTED)
else()
  ADD_LIBRARY(LibUSB SHARED IMPORTED)
endif()

if(MSVC)
  SET_PROPERTY(TARGET LibUSB PROPERTY IMPORTED_IMPLIB ${usb_STATIC_LIBRARY})
endif()
SET_PROPERTY(TARGET LibUSB PROPERTY IMPORTED_LOCATION ${usb_LIBRARY})
SET_PROPERTY(TARGET LibUSB PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${LibUSB_INCLUDE_DIRS})
