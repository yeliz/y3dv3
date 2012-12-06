package com.yogurt3d.presets.material.yogurtistan
{
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.material.MaterialBase;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.core.utils.Color;
	
	import flash.display3D.Context3D;

	public class MaterialYogurtistanAvatar extends MaterialBase
	{
		private var m_pass:YogurtistanPassAvatar;
		
		public function MaterialYogurtistanAvatar(_gradient:TextureMap,
												  _emmisiveMask:TextureMap=null,
												  _colorMap:TextureMap=null,
												  _specularMap:TextureMap=null,
												  _rimMask:TextureMap=null,
												  _specularMask:TextureMap=null,
												  _color:Color=null,
												  _ks:Number=1.0,//if texture is used for ks, default=-1
												  _kr:Number=1.0,
												  _blendConstant:Number=1.5,
												  _fspecPower:Number=1.0,
												  _fRimPower:Number=2.0,
												  _kRim:Number=1.0, 
												  _kSpec:Number=1.0,
												  _opacity:Number=1.0)
		{
			super(false);
			
			m_pass = new YogurtistanPassAvatar(_gradient, _emmisiveMask, 
				_colorMap, _specularMap, _rimMask, _specularMask, _color, _ks, 
				_kr, _blendConstant, _fspecPower, _fRimPower, _kRim, _kSpec, _opacity);	
			
		}
		
		public function set spVal(_value:Number):void{
			m_pass.spVal = _value;
		}
		public function get spVal():Number{
			return m_pass.spVal;
		}
		
		public function get emmisiveMask():TextureMap
		{
			return m_pass.emmisiveMask;
		}
		
		public function set emmisiveMask(value:TextureMap):void
		{
			m_pass.emmisiveMask = value;
		}
		
		public function get colorMap():TextureMap
		{
			return m_pass.colorMap;
		}
		
		public function set colorMap(value:TextureMap):void
		{
			m_pass.colorMap = value;	
		}
		
		public function get specularMap():TextureMap
		{
			return m_pass.specularMap;
		}
		
		public function set specularMap(value:TextureMap):void
		{
			m_pass.specularMap = value;
		}
				
		public function get gradient():TextureMap
		{
			return m_pass.gradient;
		}
		
		public function set gradient(value:TextureMap):void
		{
			m_pass.gradient = value;	
		}
		
		public function get specularMask():TextureMap
		{
			return m_pass.specularMask;
		}
		
		public function set specularMask(value:TextureMap):void
		{
			m_pass.specularMask = value;
			
		}
		
		public function get rimMask():TextureMap
		{
			return m_pass.rimMask;
		}
		
		public function set rimMask(value:TextureMap):void
		{
			m_pass.rimMask = value;
			
		}
		
		public function get ksColor():Number{
			return m_pass.ksColor;
		}
		
		public function set ksColor(value:Number):void{
			m_pass.ksColor = value;
		}
		
		public function get krColor():Number{
			return m_pass.krColor;
		}
		
		public function set krColor(value:Number):void{
			m_pass.krColor = value;
		}
		
		public function get fRimPower():Number
		{
			return m_pass.fRimPower;
		}
		
		public function set fRimPower(value:Number):void
		{
			m_pass.fRimPower = value;
		}
		
		public function get kRim():Number{
			return m_pass.kRim;
		}
		
		public function set kRim(value:Number):void{
			m_pass.kRim = value;
		}
		
		public function get fspecPower():Number
		{
			return m_pass.fspecPower;
		}
		
		public function set fspecPower(value:Number):void
		{
			m_pass.fspecPower = value;
		}
		
		public function get kSpec():Number
		{
			return m_pass.kSpec;
		}
		
		public function set kSpec(value:Number):void
		{
			m_pass.kSpec = value;
		}
		
		public function get color():Color
		{
			return m_pass.color;
		}
		
		public function set color(value:Color):void
		{
			m_pass.color = value;
		}
		
		public function get blendConstant():Number{
			return m_pass.blendConstant;
		}
		
		public function set blendConstant(_value:Number):void{
			m_pass.blendConstant= _value;
		}
		
		public function get opacity():Number
		{
			return m_pass.opacity;
		}
		
		public function set opacity(value:Number):void
		{
			m_pass.opacity = value;
		}
		
		
		public override function set vertexFunction(value:Function):void
		{
			if( value != null )
			{
				m_vertexFunction = value;
			}else{
				m_vertexFunction = emptyFunction;
			}
			m_pass.vertexFunction = m_vertexFunction;
		}
		
		public override function render(_object:SceneObjectRenderable, 
										_lights:Vector.<Light>, _device:Context3D, _camera:Camera3D):void
		{		
			
			m_pass.render(_object, _lights[0], _device,_camera);
			
		}
	}
}