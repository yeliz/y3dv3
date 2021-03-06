package com.yogurt3d.presets.material
{
	import com.yogurt3d.core.material.MaterialBase;
	import com.yogurt3d.core.material.agalgen.AGALGEN;
	import com.yogurt3d.core.material.enum.ERegisterShaderType;
	import com.yogurt3d.core.material.parameters.FragmentInput;
	import com.yogurt3d.core.material.parameters.SurfaceOutput;
	import com.yogurt3d.core.texture.ITexture;
	import com.yogurt3d.utils.Color;
	import com.yogurt3d.utils.TextureMapDefaults;
	
	
	public class MaterialDiffuseTexture extends MaterialBase{
		
		
		public function MaterialDiffuseTexture(texture:ITexture = null, _opacity:Number=1.0){
			super();
			
			lightFunction = Lambert;
			surfaceFunction = mySurfaceFunction;
			vertexFunction = emptyFunction;
			
			createConstantFromVector( ERegisterShaderType.FRAGMENT, "opacity", Vector.<Number>([_opacity, 0, 0, 0]) );
			createConstantFromTexture("colorMap", (texture)?texture:TextureMapDefaults.CHECKER_BOARD );
			
			ambientColor = new Color(0,0,0,1);
			emissiveColor = new Color(0,0,0,1);
		}
		
		private function mySurfaceFunction( surfaceInput:FragmentInput, surfaceOutput:SurfaceOutput, gen:AGALGEN ):String{
			
			var str:String = "\n\n//****SurfaceFunction START****/"+ "\n";
			
			str += gen.tex( surfaceOutput.Albedo, surfaceInput.uvMain, getConstant("colorMap")) + "\n";
			str += "mov " + surfaceOutput.Alpha + " " + getConstant("opacity").x + "\n";
			
			str += "\n\n//****SurfaceFunction END****/"+ "\n";
			return str;
		}
		
		public function get opacity( ):Number{
			return getConstantVec("opacity")[0];
		}
		
		public function set opacity( value:Number ):void{
			getConstantVec("opacity")[0] = value;
		}
		
		public function get texture():ITexture {
			return getConstantTex("colorMap");
		}
		public function set texture(value:ITexture):void{
			if( value == null )
			{
				setConstantTex( "colorMap", TextureMapDefaults.CHECKER_BOARD );
			}else{
				setConstantTex( "colorMap", value );
			}
		}
	}
	
}