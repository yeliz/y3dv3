/*
* EffectScrathedFilm.as
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

package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	import com.yogurt3d.core.texture.TextureMap;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectScrathedFilm extends PostProcessingEffectBase
	{
		private var m_filter:FilterScrathedFilm;
		public function EffectScrathedFilm(_noise:TextureMap)
		{
			super();
			effects.push(m_filter = new FilterScrathedFilm(_noise));
		}
		
		public function get IS():Number
		{
			return m_filter.IS;
		}
		
		public function set IS(value:Number):void
		{
			m_filter.IS = value;
		}
		
		public function get scratchIntensity():Number
		{
			return m_filter.scratchIntensity;
		}
		
		public function set scratchIntensity(value:Number):void
		{
			m_filter.scratchIntensity = value;
		}
		
		public function get speed2():Number
		{
			return m_filter.speed2;
		}
		
		public function set speed2(value:Number):void
		{
			m_filter.speed2 = value;
		}
		
		public function get speed1():Number
		{
			return m_filter.speed1;
		}
		
		public function set speed1(value:Number):void
		{
			m_filter.speed1 = value;
		}
		
		public function get timer():Number
		{
			return m_filter.timer;
		}
		
		public function set timer(value:Number):void
		{
			m_filter.timer = value;
		}
	
	}
}
import com.adobe.AGALMiniAssembler;
import com.yogurt3d.core.Scene3D;
import com.yogurt3d.core.render.post.EffectBase;
import com.yogurt3d.core.render.post.PostProcessingEffectBase;
import com.yogurt3d.core.texture.TextureMap;
import com.yogurt3d.utils.ShaderUtils;

import flash.display3D.Context3DProgramType;
import flash.display3D.textures.TextureBase;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

internal class FilterScrathedFilm extends EffectBase
{
	private var m_noise:TextureMap = null;
	private var m_timer:Number = 5.0;
	private var m_speed1:Number = 0.03;// 0 - 0.2
	private var m_speed2:Number = 0.01;// 0 - 0.01
	private var m_scratchIntensity:Number = 0.65;// 0 - 0.65
	private var m_is:Number = 0.01;// 0 - 0.1
	
	public function FilterScrathedFilm(_noise:TextureMap )
	{
		super();	
		m_noise = _noise;
	}
	
	public function get IS():Number
	{
		return m_is;
	}
	
	public function set IS(value:Number):void
	{
		m_is = value;
	}
	
	public function get scratchIntensity():Number
	{
		return m_scratchIntensity;
	}
	
	public function set scratchIntensity(value:Number):void
	{
		m_scratchIntensity = value;
	}
	
	public function get speed2():Number
	{
		return m_speed2;
	}
	
	public function set speed2(value:Number):void
	{
		m_speed2 = value;
	}
	
	public function get speed1():Number
	{
		return m_speed1;
	}
	
	public function set speed1(value:Number):void
	{
		m_speed1 = value;
	}
	
	public function get timer():Number
	{
		return m_timer;
	}
	
	public function set timer(value:Number):void
	{
		m_timer = value;
	}
	
	public function get noiseTex():TextureMap
	{
		return m_noise;
	}
	
	public function set noise(value:TextureMap):void
	{
		m_noise = value;
	}
	
	public override function setEffectParameters(_rect:Rectangle, _sampler:TextureBase, _scene:Scene3D):void{
		device.setTextureAt( 0, _sampler);
		device.setTextureAt( 1, m_noise.getTextureForDevice(device));
		
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([m_timer * m_speed1, m_timer * m_speed2, m_scratchIntensity, m_is]));
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,  Vector.<Number>([1.0, 0.0, 2.0, 100.0]));
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2,  Vector.<Number>([0.3,0.59,0.11,0.0]));
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3,  Vector.<Number>([1.0,0.8,0.6,1.0]));
		
	}
	
	public override function clean():void{
		device.setTextureAt( 0, null);
		device.setTextureAt( 1, null);
	}
	
	public override function getFragmentProgram():ByteArray{
		return ShaderUtils.fragmentAssambler.assemble( AGALMiniAssembler.FRAGMENT,
			[
				"mov ft1.x fc0.x",//ScanLine = (Timer*Speed1);
				"mov ft1.y fc0.y",//Side = (Timer*Speed2);
				
				"tex ft0 v0 fs0<2d,wrap,linear>",//img = tex2D(SceneSampler,uv);
				"dp3 ft4.x ft0 fc2",
				"mul ft0 ft4.x fc3",
				
				"add ft1.z v0.x ft1.y",//IN.UV.x+Side
				"mov ft1.w ft1.x",//s = float2(IN.UV.x+Side,ScanLine);
				
				"tex ft2 ft1.zw fs1<2d,wrap,linear>",//scratch = tex2D(Noise2DSamp,s).x;
				"sub ft2.x ft2.x fc0.z",//(scratch - ScratchIntensity)
				"mul ft2.x ft2.x fc1.z",
				"div ft2.x ft2.x fc0.w",//scratch = 2.0f*(scratch - ScratchIntensity)/IS;
				
				"sub ft2.y fc1.x ft2.x",
				"abs ft2.y ft2.y",//abs(1.0f-scratch)
				"sub ft2.x fc1.x ft2.y",//1.0-abs(1.0f-scratch);
				"max ft2.x fc1.y ft2.x",// scratch = max(0,scratch);
				
				"mov ft3.xyz ft2.xxx",
				"mov ft3.w fc1.y",
				
				"add ft0 ft3 ft0",//img + float4(scratch.xxx,0);
				
				"mov ft0.w fc1.x",
				
				"mov oc ft0"
				
			].join("\n")
			
		);
	}
}