/*
 *  Resource.h
 *  nxframework
 *
 *  Created by jrk on 01.04.09.
 *  Copyright 2009 flux forge. All rights reserved.
 *
 */
#pragma once
#ifndef __RESOURCE_H__
#define __RESOURCE_H__ 23
#include <string>

class Resource
{
public:		
	Resource();
	virtual ~Resource();
	
	inline int referenceCount()
	{
		return _resRefCount;
	}
	void setReferenceCount (int newCount)
	{
		_resRefCount = newCount;
	}
	void decreaceReferenceCount()
	{
		_resRefCount --;
	}
	void increaseReferenceCount()
	{
		_resRefCount ++;
	}
	
	std::string filename ()
	{
		return _filename;
	}
protected:
	int _resRefCount;
	std::string _filename;
	
};

	
#endif

