/*
 * IAxisAlignedBoundingBox.as
 * This file is part of Yogurt3D Flash Rendering Engine 
 *
 * Copyright (C) 2011 - Yogurt3D Corp.
 *
 * Yogurt3D Flash Rendering Engine is free software; you can redistribute it and/or
 * modify it under the terms of the YOGURT3D CLICK-THROUGH AGREEMENT
 * License.
 * 
 * Yogurt3D Flash Rendering Engine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * 
 * You should have received a copy of the YOGURT3D CLICK-THROUGH AGREEMENT
 * License along with this library. If not, see <http://www.yogurt3d.com/yogurt3d/downloads/yogurt3d-click-through-agreement.html>. 
 */
 
 
package com.yogurt3d.core.volumes.interfaces
{
	import com.yogurt3d.core.objects.IEngineObject;
	import com.yogurt3d.core.volumes.AxisAlignedBoundingBox;
	
	import flash.geom.Matrix3D;

	/**
	 * 
	 * 
 	 * @author Yogurt3D Engine Core Team
 	 * @company Yogurt3D Corp.
 	 **/
	public interface IAxisAlignedBoundingBox extends IEngineObject
	{
		function get min():Vector.<Number>;
		function get max():Vector.<Number>;
		function get center():Vector.<Number>;
		function get extent():Vector.<Number>;
		
		function update( _transformation:Matrix3D ):void;
		function intersectAABB( _aabb:com.yogurt3d.core.volumes.AxisAlignedBoundingBox ):Boolean;
		function intersectRay( _rayStartPoint:Vector.<Number>, _rayDirection:Vector.<Number>, _intersectionPointAndDistance:Vector.<Number> ):Boolean;
	}
}
