#pragma once
#include "Util.h"

#define SDLKey unsigned char
#define Uint8 unsigned char

namespace mx3 
{
	
		
	class InputDevice
	{
	public:
		//Singletonshit
		static InputDevice *sharedInstance (void);
		static void unload (void);
			

	public:
		inline bool isKeyPressed (SDLKey key)
		{
			return m_pBuffer [key];
		}

		inline void update (void)
		{
			if (_touchup_handled) {
				_is_touchup_active = false;
				_touchup_handled = false;
			}

			if (_touchdown_handled) {
				_is_touchdown_active = false;
				_touchdown_handled = false;
			}

			if (_touch_moving_handled) {
				_touch_moving_handled = false;
				_is_touch_moving = false;
			}
			
		}
		
		vector2D touchLocation ()
		{
			return _touch_location;
		}
		
		void setTouchLocation (vector2D vec)
		{
			_touch_location = vec;
		}
		
		bool isTouchActive ()
		{
			return _is_touch_active;
		}
		
		void setTouchActive (bool b)
		{
			_is_touch_active = b;
		}
		
		bool touchUpReceived ()
		{
			_touchup_handled = true;
			return _is_touchup_active;
		}
		
		void setTouchUpReceived(bool b) {
			_is_touchup_active = b;
			_touchup_handled = false;
		}

		bool touchDownReceived() {
			_touchdown_handled = true;
			return _is_touchdown_active;
		}

		void setTouchDownReceived(bool b) {
			_touchdown_handled = false;
			_is_touchdown_active = b;
		}

		void setTouchMoved(bool b) {
			_touch_moving_handled = false;
			_is_touch_moving = b;
		}

		bool touchMoved() {
			_touch_moving_handled = true;
			return _is_touch_moving;
		}

	protected:
		Uint8 *m_pBuffer;
		vector2D _touch_location;
		bool _is_touch_active;
		bool _is_touchup_active;
		bool _is_touchdown_active;
		bool _is_touch_moving;

		bool _touchup_handled;
		bool _touchdown_handled;
		bool _touch_moving_handled;

		
	private:
		InputDevice (void);
		~InputDevice (void);
		
		static InputDevice* _sharedInstance;

	};

}
