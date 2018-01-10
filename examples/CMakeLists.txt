add_executable (seek_test seek_test.cpp)
add_executable (seek_test_pro seek_test_pro.cpp)
add_executable (seek_viewer seek_viewer.cpp args.h)

find_package(boost QUIET)
if(boost_FOUND)
  add_executable (seek_create_flat_field seek_create_flat_field.cpp)
  target_link_libraries(seek_create_flat_field PUBLIC SeekCameraLib)
  install (TARGETS seek_create_flat_field
    DESTINATION bin
    )
endif()

target_link_libraries(seek_test PUBLIC SeekCameraLib opencv_highgui)
target_link_libraries(seek_test_pro PUBLIC SeekCameraLib opencv_highgui)
target_link_libraries(seek_viewer PUBLIC SeekCameraLib opencv_highgui)

install (TARGETS
  seek_test
  seek_test_pro
  seek_viewer
  DESTINATION bin
)
