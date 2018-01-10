// .NAME SeekCameraLib_EXPORTS - manage Windows system differences
// .SECTION Description
// The SeekCameraLibExport manages DLL export syntax differences
// between different operating systems.

#ifndef __SeekCameraLibExport_h
#define __SeekCameraLibExport_h

#if defined(WIN32) && !defined(SeekCameraLib_STATIC)
 #if defined(SeekCameraLib_EXPORTS)
  #define SeekCameraLibExport __declspec( dllexport )
 #else
  #define SeekCameraLibExport __declspec( dllimport )
 #endif
#else
 #define SeekCameraLibExport
#endif

#endif
