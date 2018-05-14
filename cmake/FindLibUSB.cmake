IF (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

  IF (NOT LibUSB_ROOT_DIR)
    SET(LibUSB_ROOT_DIR "" CACHE PATH "Path to the LibUSB library root directory")
    MESSAGE(FATAL_ERROR "LibUSB not found, please specify LibUSB_ROOT_DIR")
  ENDIF ()

  SET(LibUSB_INCLUDE_DIRS ${LibUSB_ROOT_DIR}/include)
  SET(LibUSB_INCLUDES     ${LibUSB_ROOT_DIR}/include)
  SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
  SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".dll")

  # Library dir
  IF(MSVC OR ${CMAKE_GENERATOR} MATCHES "Xcode")
    SET(LibUSB_LIBRARY_DIR  ${LibUSB_ROOT_DIR}/MS32/dll)  # 32bits
  ELSE ()
    SET(LibUSB_LIBRARY_DIR  ${LibUSB_ROOT_DIR}/MinGW32/dll)  # 32bits
  ENDIF ()

  # Library
  FIND_LIBRARY(LibUSB_LIBS
    NAMES usb-1.0 libusb usb libusb-1.0
    PATHS ${LibUSB_LIBRARY_DIR}
    NO_DEFAULT_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_CMAKE_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_SYSTEM_PATH
    )

ELSE ()

  # Copied from original repository https://github.com/maartenvds/libseek-thermal
  SET(LibUSB_INCLUDE_DIRS /usr/include/LibUSB-1.0)
  SET(LibUSB_INCLUDES     /usr/include/LibUSB-1.0)
  SET(LibUSB_LIBS -lusb-1.0)

ENDIF ()
