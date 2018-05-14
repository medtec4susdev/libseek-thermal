IF (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

  IF (NOT LIBUSB_ROOT_DIR)
    SET(LIBUSB_ROOT_DIR "" CACHE PATH "Path to the libusb library root directory")
    MESSAGE(FATAL_ERROR "LibUSB not found, please specify LIBUSB_ROOT_DIR")
  ENDIF ()

  SET(LIBUSB_INCLUDE_DIRS ${LIBUSB_ROOT_DIR}/include)
  SET(LIBUSB_INCLUDES     ${LIBUSB_ROOT_DIR}/include)
  SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
  SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".dll")

  # Library dir
  IF(MSVC OR ${CMAKE_GENERATOR} MATCHES "Xcode")
    SET(LIBUSB_LIBRARY_DIR  ${LIBUSB_ROOT_DIR}/MS32/dll)  # 32bits
  ELSE ()
    SET(LIBUSB_LIBRARY_DIR  ${LIBUSB_ROOT_DIR}/MinGW32/dll)  # 32bits
  ENDIF ()

  # Library
  FIND_LIBRARY(LIBUSB_LIBS
    NAMES usb-1.0 libusb usb libusb-1.0
    PATHS ${LIBUSB_LIBRARY_DIR}
    NO_DEFAULT_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_CMAKE_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_SYSTEM_PATH
    )

ELSE ()

  # Copied from original repository https://github.com/maartenvds/libseek-thermal
  SET(LIBUSB_INCLUDE_DIRS /usr/include/libusb-1.0)
  SET(LIBUSB_INCLUDES     /usr/include/libusb-1.0)
  SET(LIBUSB_LIBS -lusb-1.0)

ENDIF ()
