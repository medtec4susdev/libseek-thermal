INCLUDE_DIRECTORIES(
  ${CMAKE_CURRENT_LIST_DIR}/../src
  ${OpenCV_INCLUDE_DIRS}
  ${LIBUSB_INCLUDE_DIRS}
)

LINK_LIBRARIES(
  seek_static
  ${OpenCV_LIBS}
  ${LIBUSB_LIBS}
)

ADD_EXECUTABLE(seek_test seek_test.cpp)
ADD_EXECUTABLE(seek_test_pro seek_test_pro.cpp)
ADD_EXECUTABLE(seek_viewer seek_viewer.cpp args.h)
add_executable(seek_create_flat_field seek_create_flat_field.cpp)

INSTALL(TARGETS
  seek_test
  seek_test_pro
  seek_viewer
  seek_create_flat_field
  DESTINATION "bin"
)
