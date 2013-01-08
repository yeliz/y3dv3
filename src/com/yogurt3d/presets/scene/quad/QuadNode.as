/*
* OctNode.as
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

package com.yogurt3d.presets.scene.quad
{
	import com.yogurt3d.core.volumes.AxisAlignedBoundingBox;
	
	import flash.geom.Vector3D;
	
	public class QuadNode
	{
		public var m_sumChildren					:int;
		
		public var m_numNodes						:int;
	
		public var m_min							:Vector3D;
		
		public var m_max							:Vector3D;
		
		public var m_looseMin						:Vector3D;
		
		public var m_looseMax						:Vector3D;
		
		public var m_center							:Vector3D;
		
		public var m_testSizeVector					:Vector3D;
		
		public var m_halfSizeVector					:Vector3D;
		
		public var m_testSizeVectorLength			:Number;
		
		public var children							:Vector.<Quadrant> = new Vector.<Quadrant>();
		
		public var nodes							:Vector.<QuadNode> = new Vector.<QuadNode>(4,true);
		
		public var m_parent							:QuadNode = null;
	
		public function QuadNode(parent:QuadNode)
		{
			m_sumChildren = 0;
			m_numNodes = 0;
			m_parent = parent;
		}
			
		public function isTwiceSize( boxOfOctant:AxisAlignedBoundingBox ):Boolean
		{
			var boxSize:Vector3D = boxOfOctant.sizeGlobal;
			
			return ((boxSize.x <= m_halfSizeVector.x) && (boxSize.z <= m_halfSizeVector.z));
		}
	}
}