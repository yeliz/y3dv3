/*
 * SphereSceneObject.as
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
 
 
package com.yogurt3d.presets.sceneobjects
{
	import com.yogurt3d.core.managers.IDManager;
	import com.yogurt3d.YOGURT3D_INTERNAL;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.geometry.SphereMesh;
	
	/**
	 * 
	 * 
 	 * @author Yogurt3D Engine Core Team
 	 * @company Yogurt3D Corp.
 	 **/
	public class SphereSceneObject extends SceneObjectRenderable
	{
		YOGURT3D_INTERNAL var m_radius		:Number;
		YOGURT3D_INTERNAL var m_parallels	:int;
		YOGURT3D_INTERNAL var m_meridians	:int;
		
		use namespace YOGURT3D_INTERNAL;
		
		public function SphereSceneObject(_radius:Number = 1.0, _parallels:int = 16, _meridians:int = 16)
		{
			m_radius		= _radius;
			m_parallels		= _parallels;
			m_meridians		= _meridians;
			
			super();
		}
		
		override protected function trackObject():void
		{
			IDManager.trackObject(this, SphereSceneObject);
		}
		
		override protected function initInternals():void
		{
			super.initInternals();
			
			geometry		= new SphereMesh(m_radius, m_parallels, m_meridians);
		}
	}
}
