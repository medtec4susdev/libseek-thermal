/*
 *  Test program seek lib
 *  Author: Maarten Vandersteegen
 */
#include <opencv2/highgui/highgui.hpp>
#include "seek.h"
#include <iostream>
#include "args.h" // Parsing command line options

int main(int argc, char** argv)
{
    // Setup arguments for parser
    args::ArgumentParser parser("Seek Create Flat Field");
    // Options
    args::HelpFlag               help(parser, "help", "Display this help menu", {'h', "help"});
    args::ValueFlag<std::string> _cam(parser, "cam", "File nameCamera type: [seek|seekpro]. (default: seekpro)", {'c', "cam"}, "seekpro");
    args::ValueFlag<std::string> _outfile(parser, "outfile", "Name of the output file. (default: ffield_output.png)", {'o', "outfile"}, "");
    args::ValueFlag<int>         _smoothing(parser, "smoothing", "Number of images to average before creating an output image. (default: 100)", {'s', "smoothing"}, 100);

    // Seek
    cv::Mat frame_u16, frame, avg_frame;
    LibSeek::SeekThermalPro seekpro;
    LibSeek::SeekThermal seek;
    LibSeek::SeekCam* cam;

    try
    {
        parser.ParseCLI(argc, argv);
    }
    catch (args::Help)
    {
        std::cout << parser;
        return 0;
    }
    catch (args::ParseError e)
    {
        std::cerr << e.what() << std::endl;
        std::cerr << parser;
        return 1;
    }
    catch (args::ValidationError e)
    {
        std::cerr << e.what() << std::endl;
        std::cerr << parser;
        return 1;
    }

    if (args::get(_outfile) == "") {
      std::cout << "No output file specified.\n" << parser << std::endl;
      return 1;
    }

    if (args::get(_cam) == "seekpro")
        cam = &seekpro;
    else
        cam = &seek;

    if (!cam->open()) {
        std::cout << "failed to open seek cam" << std::endl;
        return -1;
    }

    int smoothing = args::get(_smoothing);
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

    cv::imwrite(args::get(_outfile), frame_u16);
    return 0;
}
