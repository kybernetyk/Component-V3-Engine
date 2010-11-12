// Input.cpp: implementation of the Input class.
//
//////////////////////////////////////////////////////////////////////

#include "InputDevice.h"
#include <stddef.h>


InputDevice* InputDevice::_sharedInstance = 0;

InputDevice::InputDevice (void)
{
	_is_touch_active = false;
	_touchup_handled = false;
	_is_touchup_active = false;
}

InputDevice::~InputDevice (void)
{
	
}

InputDevice* InputDevice::sharedInstance (void)
{
	if(!_sharedInstance)
		_sharedInstance = new InputDevice;
	
	return _sharedInstance;
}

void InputDevice::unload (void)
{
	if (_sharedInstance)
	{
		delete _sharedInstance;
		_sharedInstance = NULL;
	}
}
