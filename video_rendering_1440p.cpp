#include<opencv2/imgcodecs.hpp>
#include<fstream>
#include<opencv2/opencv.hpp>
#include<opencv2/dnn.hpp>
#include<opencv2/dnn/all_layers.hpp>
#include<vector>
#include<opencv2/highgui.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/objdetect.hpp>
#include<iostream>
#include<string>
int main()
{
	std::string video_path = "C:/Users/3301/Videos/mkbhd.mkv";
	cv::VideoCapture cap(video_path);
	cv::CascadeClassifier faceCascade;
	cv::UMat vid_matrix;
	faceCascade.load("C:/Users/3301/Desktop/todo/Programs/Practice/Projects/Resources/harrcascade_frontalface_default.xml");
	if (faceCascade.empty())
	{
		std::cout << "Xml file is not loaded yet" << std::endl;
	}
	//cap.read(vid_matrix);
	//hv::imshow("image", vid_matrix);
//	cv::waitKey(0);


	while (true)
	{
		cap.read(vid_matrix);
		cv::UMat GrayScaled, Blurred, Canny, Dilated, Eroded;
		cv::cvtColor(vid_matrix, GrayScaled, cv::COLOR_BGR2GRAY);
		cv::GaussianBlur(vid_matrix, Blurred, cv::Size(3, 3), 3, 0);
		cv::Canny(Blurred, Canny, 50, 150);
		cv::imshow("image", vid_matrix);
		cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3, 3));
		cv::dilate(Canny, Dilated, kernel);
		cv::erode(Dilated, Eroded, kernel);
		cv::imshow("Marquees", vid_matrix);
		cv::imshow("Marquees Gray", GrayScaled);
		cv::imshow("Marquess Canny", Blurred);
		cv::imshow("Marquees Dilated", Dilated);
		cv::imshow("Marquees Eroded", Eroded);
		cv::waitKey(1);
		

	}

	return 0;
}



