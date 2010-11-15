#pragma once
//#include <SDL/SDL.h>
#include <string>
#include <sstream>
#include <stdio.h>

class Timer
{
public:
	void update (void);
	
	Timer ()
	{
		printf("BAM");
		m_ulDelta = 0;
		m_ulLastTickCount = 0;
		m_ulTickCount = 0;
		temp = 0.0;
		frames = 0.0;
	}

/*	inline unsigned long delta (void)
	{
		return m_ulDelta;
	}*/
	
	inline double fdelta ()
	{
		return m_ulDelta;
	}

	std::string stringWithFPS (void)
	{
		float fps = 1.0 / m_ulDelta;
		std::stringstream s;
		s << "current fps: " << fps;
		return s.str();
	}
	
	void printFPS ()
	{
		frames ++;
		temp += m_ulDelta;
		//printf ("%f\n",temp);
		if (temp >= 0.5f)
		{
			printf ("fps: %f\n", frames / temp);
			
			temp = 0.0;
			frames = 0.0;
		}
	}
	
protected:
	double m_ulTickCount;
	double m_ulLastTickCount;
	double m_ulDelta;
	
	double temp;
	double frames;
};

