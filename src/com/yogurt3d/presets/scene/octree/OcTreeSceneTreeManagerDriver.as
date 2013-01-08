/*
* OcTreeSceneTreeManagerDriver.as
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

package com.yogurt3d.presets.scene.octree
{
	import com.yogurt3d.core.sceneobjects.scenetree.IRenderableManager;
	import com.yogurt3d.core.sceneobjects.scenetree.SceneTreeManagerDriver;
	
	
	public class OcTreeSceneTreeManagerDriver extends SceneTreeManagerDriver
	{
		public function OcTreeSceneTreeManagerDriver()
		{
			super();
		}
		
		public override function get name():String{
			return "OcSceneTreeManagerDriver";
		}
		
		public override function createTreeManager():IRenderableManager{
			return new OcTreeSceneTreeManager();
		}
	}
}