/*
 *  Test program seek lib
 *  Author: Maarten Vandersteegen
 */
#include <opencv2/highgui/highgui.hpp>
#include "seek.h"
#include <iostream>
#include "cxxopts.hpp" // Parsing command line options

cxxopts::Options generate_description(std::string program_name)
{
    // Get file name from path
    const size_t last_slash_idx = program_name.find_last_of("\\/");
    if (std::string::npos != last_slash_idx)
        program_name.erase(0, last_slash_idx + 1);

    // Options
    cxxopts::Options options(program_name, "");
    options.add_options()
      ("h,help",      "Show this help")
      ("c,cam",       "File nameCamera type: [seek|seekpro]", cxxopts::value<std::string>()->default_value("seekpro"))
      ("s,smoothing", "Number of images to average before creating an output image", cxxopts::value<int>()->default_value("100"))
      ("o,outfile",   "Name of the output file", cxxopts::value<std::string>()->default_value("ffield_output"))
      ;
    return options;
}

int main(int argc, char** argv)
{
    // Options
    cxxopts::Options options = generate_description(argv[0]);
    bool help;
    int smoothing;
    std::string outfile;
    std::string cam;

    // Seek
    //cv::Mat frame_u16, frame, avg_frame;
    LibSeek::SeekThermalPro seekpro;
    LibSeek::SeekThermal seek;
    LibSeek::SeekCam* cam;

    try
    {
        auto result = options.parse(argc, argv);
        smoothing = result["smoothing"].as<int>();
        outfile   = result["outfile"].as<std::string>();
        help      = result["help"].as<bool>();
        cam       = (result["cam"].as<std::string>() == "seekpro") ? &seekpro : &seek;
    }
    catch (cxxopts::OptionException &e)
    {
        std::cerr << "ERROR: " << e.what() << std::endl;
        std::cout << options.help() << std::endl;
        return -1;
    }

    if (help) {
        std::cout << options.help() << std::endl;
        return 0;
    }

    if (!cam->open()) {
        std::cout << "failed to open seek cam" << std::endl;
        return -1;
    }

    for (int i=0; i<smoothing; i++) {

        if (!cam->grab()) {
            std::cout << "no more LWIR img" << std::endl;
            return -1;
        }

        cam->retrieve(frame_u16);
        frame_u16.convertTo(frame, CV_32FC1);

        if (avg_frame.rows == 0) {
            frame.copyTo(avg_frame);
        } else {
            avg_frame += frame;
        }

        cv::waitKey(10);
    }

    avg_frame /= smoothing;
    avg_frame.convertTo(frame_u16, CV_16UC1);

    cv::imwrite(outfile, frame_u16);
    return 0;
}
