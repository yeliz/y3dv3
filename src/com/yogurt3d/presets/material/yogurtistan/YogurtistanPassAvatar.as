package com.yogurt3d.presets.material.yogurtistan
{
	import com.yogurt3d.core.agalgen.IRegister;
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.geoms.SkeletalAnimatedMesh;
	import com.yogurt3d.core.geoms.SkinnedSubMesh;
	import com.yogurt3d.core.geoms.SubMesh;
	import com.yogurt3d.core.geoms.interfaces.IMesh;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.material.Y3DProgram;
	import com.yogurt3d.core.material.enum.EBlendMode;
	import com.yogurt3d.core.material.enum.ERegisterShaderType;
	import com.yogurt3d.core.material.parameters.FragmentInput;
	import com.yogurt3d.core.material.parameters.VertexInput;
	import com.yogurt3d.core.material.parameters.VertexOutput;
	import com.yogurt3d.core.material.pass.Pass;
	import com.yogurt3d.core.namespaces.YOGURT3D_INTERNAL;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.core.utils.Color;
	import com.yogurt3d.core.utils.ShaderUtils;
	import com.yogurt3d.core.utils.TextureMapDefaults;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	public class YogurtistanPassAvatar extends Pass
	{
		private var m_color					:Color;
		private var m_ksColor				:Number;
		private var m_krColor				:Number;
		private var m_blendConstant			:Number;
		private var m_fspecPower			:Number;
		private var m_fRimPower				:Number;
		private var m_kRim					:Number;
		private var m_kSpec					:Number;
		private var m_opacity				:Number;	
		private var m_spVal					:Number;
		
		private var m_gradient				:TextureMap;
		private var m_emmisiveMask			:TextureMap;
		private var m_colorMap				:TextureMap;
		private var m_specularMap			:TextureMap;
		private var m_specularMask			:TextureMap;
		private var m_rimMask				:TextureMap;
		
	//	protected var m_currentCamera		:Camera3D;
		
		public function YogurtistanPassAvatar(_gradient:TextureMap,
											  _emmisiveMask:TextureMap=null,
											  _colorMap:TextureMap=null,
											  _specularMap:TextureMap=null,
											  _rimMask:TextureMap=null,
											  _specularMask:TextureMap=null,
											  _color:Color=null,
											  _ks:Number=1.0,
											  _kr:Number=1.0,
											  _blendConstant:Number=1.5,
											  _fspecPower:Number=1.0,
											  _fRimPower:Number=2.0,
											  _kRim:Number=1.0, 
											  _kSpec:Number=1.0,
											  _opacity:Number=1.0)
		{
			m_surfaceParams.blendEnabled = true;
			m_surfaceParams.blendMode = EBlendMode.ALPHA;
			
			m_surfaceParams.writeDepth = true;
			m_surfaceParams.depthFunction = Context3DCompareMode.LESS;
			m_surfaceParams.culling = Context3DTriangleFace.FRONT;
			
			m_color = _color;
			if(_color == null)
				m_color = new Color(1,1,1,1);
			
			m_opacity = _opacity;
			m_blendConstant = _blendConstant;
			m_fspecPower = _fspecPower;
			m_kRim	= _kRim;
			m_ksColor = _ks;
			m_krColor = _kr;
			m_fRimPower = _fRimPower;
			m_kSpec = _kSpec;
			m_spVal = 200;
			
			m_gradient = _gradient;

			m_colorMap = (_colorMap)?_colorMap:TextureMapDefaults.WHITE;
			m_specularMap = (_specularMap)?_specularMap:TextureMapDefaults.BLACK;
			m_specularMask = (_specularMask)?_specularMask:TextureMapDefaults.BLACK;
			m_emmisiveMask = (_emmisiveMask)?_emmisiveMask:TextureMapDefaults.BLACK;
			m_rimMask = (_rimMask)?_rimMask:TextureMapDefaults.BLACK;
			
			if(m_specularMask != TextureMapDefaults.BLACK)
				m_ksColor = 0.0;
			
			if(m_rimMask != TextureMapDefaults.BLACK)
				m_krColor = 0.0;
			
			if(m_specularMap != TextureMapDefaults.BLACK)
				m_kSpec = 0;
			
			createConstantFromVector( ERegisterShaderType.FRAGMENT, "constant1", Vector.<Number>([ 0.0, 0.5, 1.0, m_opacity ]));
			createConstantFromVector( ERegisterShaderType.FRAGMENT, "constant2", Vector.<Number>([ m_blendConstant, 0.1, m_spVal, m_kSpec ]));
			createConstantFromVector( ERegisterShaderType.FRAGMENT, "constant3", Vector.<Number>([ m_color.r, m_color.g, m_color.b, 0.00000001 ]));
			createConstantFromVector( ERegisterShaderType.FRAGMENT, "constant4", Vector.<Number>([ m_fspecPower, m_kRim, m_ksColor, m_krColor ]));
			createConstantFromVector( ERegisterShaderType.FRAGMENT, "constant5", Vector.<Number>([ m_fRimPower, 0, 0, 0]));
			
			createConstantFromTexture(ERegisterShaderType.FRAGMENT, "gradient", m_gradient );
	//		createConstantFromTexture(ERegisterShaderType.FRAGMENT, "ambGrad", m_ambientGradient );
			createConstantFromTexture(ERegisterShaderType.FRAGMENT, "colorMap", m_colorMap );
			createConstantFromTexture(ERegisterShaderType.FRAGMENT, "specMap", m_specularMap);
			createConstantFromTexture(ERegisterShaderType.FRAGMENT, "rimMask", m_rimMask);
			createConstantFromTexture(ERegisterShaderType.FRAGMENT, "specMask", m_specularMask );
			createConstantFromTexture(ERegisterShaderType.FRAGMENT, "emissiveMask", m_emmisiveMask);
		
			
			createConstantFromVectorFunction(ERegisterShaderType.FRAGMENT, 
				"cameraPos", function():Vector.<Number>{
					var pos:Vector3D = m_currentCamera.transformation.matrixGlobal.position;
					return Vector.<Number>([ pos.x,pos.y,pos.z,1]);
				});
			
			//lightDir
			createConstantFromVectorFunction(ERegisterShaderType.FRAGMENT, 
				"lightDir", function():Vector.<Number>{
					return m_currentLight.directionVector;
				});
			
			//lightColor
			createConstantFromVectorFunction(ERegisterShaderType.FRAGMENT, 
				"lightColor", function():Vector.<Number>{
					return m_currentLight.color.getColorVectorRaw();
				});
		}
		
		public override function uploadConstants(device:Context3D):void{
			
			// set vectorConstants
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["constant1"].register.index, m_constants["constant1"].vec );
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["constant2"].register.index, m_constants["constant2"].vec );
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["constant3"].register.index, m_constants["constant3"].vec );
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["constant4"].register.index, m_constants["constant4"].vec );
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["constant5"].register.index, m_constants["constant5"].vec );
			
			// set vectorFunctionsConstants
			
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["lightDir"].register.index, m_constants["lightDir"].callFunction() );
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["lightColor"].register.index, m_constants["lightColor"].callFunction() );
			device.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, m_constants["cameraPos"].register.index, m_constants["cameraPos"].callFunction() );
			
			// set textureConstants
			m_vsManager.setTexture(device, m_constants["gradient"].register.index, m_gradient.getTextureForDevice(device) );
			m_vsManager.setTexture(device, m_constants["colorMap"].register.index, m_colorMap.getTextureForDevice(device) );
			m_vsManager.setTexture(device, m_constants["specMap"].register.index, m_specularMap.getTextureForDevice(device) );
			m_vsManager.setTexture(device, m_constants["rimMask"].register.index, m_rimMask.getTextureForDevice(device) );
			m_vsManager.setTexture(device, m_constants["specMask"].register.index, m_specularMask.getTextureForDevice(device) );
			m_vsManager.setTexture(device, m_constants["emissiveMask"].register.index, m_emmisiveMask.getTextureForDevice(device) );
		
		}
		
		protected override function preRender(device:Context3D, _object:SceneObjectRenderable, _camera:Camera3D):void{
			var m:Matrix3D = new Matrix3D();
			m.copyFrom( _camera.transformation.matrixGlobal );
			m.invert();
			m.append( _camera.frustum.projectionMatrix );
			
			device.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, gen.VC["Model"].index, _object.transformation.matrixGlobal, true );
			device.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, gen.VC["ViewProjection"].index, m, true );
						
			m_currentCamera = _camera;
			m_vsManager.markTexture(device);
			uploadConstants(device);
			m_vsManager.sweepTexture(device);
		}
		
		public override function render(_object:SceneObjectRenderable, _light:Light, _device:Context3D, _camera:Camera3D):void{
			m_currentLight = _light;
			
			var program:Y3DProgram = getProgram(_device, _object, _light);
			
			_device.setProgram( program.program );
			
			_device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			_device.setColorMask( m_surfaceParams.colorMaskR, m_surfaceParams.colorMaskG, m_surfaceParams.colorMaskB, m_surfaceParams.colorMaskA);
			_device.setDepthTest( m_surfaceParams.writeDepth, m_surfaceParams.depthFunction );
			_device.setCulling( m_surfaceParams.culling );
			
			preRender(_device, _object, _camera);
			
			m_vsManager.markVertex(_device);
			var _mesh:IMesh = _object.geometry;
			for( var submeshindex:uint = 0; submeshindex < _mesh.subMeshList.length; submeshindex++ )
			{
				var subMesh:SubMesh = _mesh.subMeshList[submeshindex];
				var _skinnedsubmesh:SkinnedSubMesh = subMesh as SkinnedSubMesh
				if( _skinnedsubmesh != null )
				{
					for( var boneIndex:int = 0; boneIndex < _skinnedsubmesh.originalBoneIndex.length; boneIndex++)
					{	
						var originalBoneIndex:uint = _skinnedsubmesh.originalBoneIndex[boneIndex];
						_device.setProgramConstantsFromVector( Context3DProgramType.VERTEX, gen.VC["BoneMatrices"].index  + (boneIndex*3), SkeletalAnimatedMesh(_object.geometry).bones[originalBoneIndex].transformationMatrix.rawData, 3 );
					}
				}
				
				
				m_vsManager.setStream( _device,  m_vertexInput.YOGURT3D_INTERNAL::m_vertexpos.index, subMesh.getPositonBufferByContext3D(_device),0, Context3DVertexBufferFormat.FLOAT_3);
				m_vsManager.setStream( _device,  m_vertexInput.YOGURT3D_INTERNAL::m_normal.index, subMesh.getNormalBufferByContext3D(_device),0, Context3DVertexBufferFormat.FLOAT_3);
				m_vsManager.setStream( _device,  m_vertexInput.YOGURT3D_INTERNAL::m_uvMain.index, subMesh.getUVBufferByContext3D(_device),0, Context3DVertexBufferFormat.FLOAT_2);
				
			
				var skinnedSubmesh:SkinnedSubMesh = subMesh as SkinnedSubMesh;
				var buffer:VertexBuffer3D = skinnedSubmesh.getBoneDataBufferByContext3D(_device);
				m_vsManager.setStream( _device, m_vertexInput.YOGURT3D_INTERNAL::m_boneData.index,   buffer, 0, Context3DVertexBufferFormat.FLOAT_4 );
				m_vsManager.setStream( _device, m_vertexInput.YOGURT3D_INTERNAL::m_boneData.index+1, buffer, 4, Context3DVertexBufferFormat.FLOAT_4 );
				m_vsManager.setStream( _device, m_vertexInput.YOGURT3D_INTERNAL::m_boneData.index+2, buffer, 8, Context3DVertexBufferFormat.FLOAT_4 );
				m_vsManager.setStream( _device, m_vertexInput.YOGURT3D_INTERNAL::m_boneData.index+3, buffer, 12,Context3DVertexBufferFormat.FLOAT_4 );
		
				_device.drawTriangles(subMesh.getIndexBufferByContext3D(_device), 0, subMesh.triangleCount);
			}
			m_vsManager.sweepVertex(_device);
			postRender(_device);
		}
		
		public override function getVertexShader(isSkeletal:Boolean):ByteArray{
			
			var input:VertexInput = m_vertexInput = new VertexInput(gen);
			var out:VertexOutput = m_vertexOutput;
			var vt1:IRegister = gen.createVT("vt1",4);
			var vt2:IRegister = gen.createVT("vt2",4);
			var vt3:IRegister = gen.createVT("vt3",4);
			var vt4:IRegister = gen.createVT("boneResult",4);
			var vt5:IRegister = gen.createVT("vt5",4);
			var vt6:IRegister = gen.createVT("vt6",4);
			
			gen.createVC("Model",4);
			gen.createVC("ViewProjection",4);
			gen.createVC("BoneMatrices",4);
			
			var posVec3:Array = [vt3.x, vt3.y, vt3.z, vt3.w];
			var posVec2:Array = [vt2.x, vt2.y, vt2.z, vt2.w];
			
			var code:String = [
				
				gen.code("mov", vt2, "va"+(input.boneData.index+1)), 
				gen.code("mov", vt2, input.boneData), // bone Indices
				
				gen.code("mov", vt3, "va"+(input.boneData.index+3)), 
				gen.code("mov", vt3, "va"+(input.boneData.index+2)) // bone Weight
				
			].join("\n") + "\n";
			
			for( var i:int = 0; i < 8; i++ )
			{
				code += gen.code("mul", vt1 ,posVec3[ i % 4 ], "vc[" + posVec2[ i % 4 ] + "+"+gen.VC["BoneMatrices"].index+"]") + "\n";
				
				if( i == 0 )
				{
					code += gen.code("mov", vt4, vt1)+ "\n";	
				}else{
					code += gen.code("add", vt4, vt1, vt4)+ "\n";
				}	
				
				code += gen.code("mul", vt1, posVec3[ i % 4 ], "vc[" + posVec2[ i % 4 ] + "+"+(gen.VC["BoneMatrices"].index+1)+"]")+ "\n";
				
				if( i == 0 )
				{
					code += gen.code("mov", vt5, vt1)+ "\n";
				}else{
					code += gen.code("add", vt5, vt1, vt5)+ "\n";
				}
				
				code += gen.code("mul", vt1, posVec3[ i % 4 ], "vc[" + posVec2[ i % 4 ] + "+"+(gen.VC["BoneMatrices"].index+2)+"]")+ "\n";
				
				if( i == 0 )
				{
					code += gen.code("mov", vt6, vt1)+ "\n";
				}else{
					code += gen.code("add", vt6, vt1, vt6)+ "\n";
				}
				
				if( i == 3 )
				{
					code += [
						gen.code("mov", vt2, "va"+(input.boneData.index + int( ( i + 1 ) / 4 ))),
						gen.code("mov", vt3, "va"+(input.boneData.index + 2 +int( ( i + 1 ) / 4 ))),
					].join("\n")+ "\n";
				}
			}
			
			code += "\n";
			
			gen.destroyVT("vt1");
			gen.destroyVT("vt2");
			gen.destroyVT("vt3");
			gen.destroyVT("vt5");
			gen.destroyVT("vt6");
			
			var worldPos:IRegister = gen.createVT("worldPos",4);
			var normalTemp:IRegister = gen.createVT("normTemp",3);
			
			code += [
				"//Calculate world pos",
				gen.code("m34", worldPos.xyz, input.vertexpos, vt4),
				gen.code("mov", worldPos.w, input.vertexpos.w),
				gen.code("m44", worldPos, worldPos, gen.VC["Model"]),
				gen.code("mov", out.worldPos, worldPos),
				"//Screen Pos",
				gen.code("m44", "op", worldPos, gen.VC["ViewProjection"]),	
				
				"//Calculate normals",
				gen.code("m33",normalTemp, input.normal.xyz, vt4),
				gen.code("m33",normalTemp, normalTemp, gen.VC["Model"]),
				gen.code("nrm",normalTemp, normalTemp),
				gen.code("mov",out.normal.xyz, normalTemp),
				gen.code("mov",out.normal.w, input.normal.w),		
				"//UV",
				gen.code("mov", out.uvMain, input.uvMain )
				
			].join("\n");
				
		//	trace(gen.printCode( code ));
			
			return ShaderUtils.vertexAssambler.assemble(Context3DProgramType.VERTEX, code, false );
		}
		
		public override function getFragmentShader(_light:Light):ByteArray{
			gen.destroyAllTmp();
			m_vertexOutput = new FragmentInput(gen);
			
			var camPos:IRegister 	= gen.FC["cameraPos"];
			var lightDir:IRegister 	= gen.FC["lightDir"];
			var lightCol:IRegister 	= gen.FC["lightColor"];
			
			var zero:String 		= gen.FC["constant1"].x;
			var half:String 		= gen.FC["constant1"].y;
			var one:String 			= gen.FC["constant1"].z;
			var opacity:String 		= gen.FC["constant1"].w;
			
			var bconst:String		= gen.FC["constant2"].x; 
			var up:String			= gen.FC["constant1"].xzx;
			var approx:String 		= gen.FC["constant3"].w;
			
			var fspecPow:String 	= gen.FC["constant4"].x;
			var krim:String 		= gen.FC["constant4"].y;
			var ksCol:String		= gen.FC["constant4"].z;
			var krCol:String		= gen.FC["constant4"].w;
			var fRimPow:String		= gen.FC["constant5"].x;
			
			var worldPos:IRegister 	= m_vertexOutput.worldPos;
			var normal:IRegister 	= m_vertexOutput.normal;
			var uv:IRegister 		= m_vertexOutput.uvMain;
			
			var view:IRegister 		= gen.createFT("view", 4);
			var temp1:IRegister 	= gen.createFT("temp1", 4);
			var temp2:IRegister 	= gen.createFT("temp2", 4);
			var temp3:IRegister 	= gen.createFT("temp3", 4);
			var temp4:IRegister 	= gen.createFT("temp4", 4);
			var temp5:IRegister 	= gen.createFT("temp5", 4);
			var result:IRegister 	= gen.createFT("result", 4);
			
			var code:String = [
				
				// View - Independent
				// Step 1 : Half Lambert Term
				
				gen.code("mov", temp1, lightDir),			 				// temp1 = lightDir
				gen.code("nrm", temp1.xyz, temp1.xyz),	 				// norm(L)
				
				gen.code("dp3", temp1.x, normal.xyz, temp1.xyz), 			// temp1.x = dot(N.L)
				gen.code("mul", temp1.y, temp1.x, half),					// dot(N.L) * 0.5
				gen.code("add", temp1.y, temp1.y, half),					// lambert = dot(N.L) * 0.5 + 0.5
				
				// Step 2: Warping (lambert)
				gen.code("mov", temp1.x, zero),
				gen.tex(temp2, temp1.yx, gen.FS["gradient"], "2d", "clamp", "linear", m_gradient.mipmap),
				gen.code("mul", temp2, temp2, bconst), 
				
				// Step 3: color of light * Warping (lambert)
				gen.code("mul", temp2, temp2, lightCol), 
				
				// Step 4: ambient term a(dot(n.u) )
				gen.code("dp3", temp1.z, normal.xyz, up), 
				gen.code("add", temp1.z, temp1.z, one), 
				gen.code("mul", temp5.x, temp1.z, half), 
				gen.code("mov", temp5.y, one),
				gen.tex(temp3, temp5.xy, gen.FS["gradient"], "2d", "clamp", "linear", m_gradient.mipmap),//TODO
			
				// a(n.u) + color of light * Warping (lambert)
				gen.code("add", temp2, temp2, temp3), 
				
				// Step 5: Get Color map
				gen.tex(result, uv, gen.FS["colorMap"], "2d", "wrap", "linear", m_colorMap.mipmap, true, m_colorMap.transparent, gen.FC["constant2"].y),
				gen.code("mul", result, temp2, result), 
				gen.code("mul", result.xyz, result.xyz, gen.FC["constant3"].xyz),
				
				// View Dependent
				// Step 6: Phong Specular Term
				gen.reflectionVector(temp2, lightDir, normal),				// R = reflect vector (L, N)	
				gen.code("sub", view, camPos, worldPos), 						// View Vector = V
				gen.code("nrm", view.xyz, view.xyz), 							// norm(V)
				gen.code("dp3", temp1.z, view, temp2),						// dot(v.r)
				
				gen.tex(temp2, uv, gen.FS["specMap"], "2d", "wrap", "linear", m_specularMap.mipmap),
				gen.code("mul", temp2.x, temp2.x, gen.FC["constant2"].z),
				gen.code("add", temp2.x, temp2.x, gen.FC["constant2"].w),	// kspec = if there is specular map, get it from it else get from kSpec
				gen.code("pow", temp2.x, temp1.z, temp2.x), 					// kspec = pow(dot(v.r), kspec)
				
				// if L.n > 0 max (0, pow(dot(n.l), kspec))
				gen.code("max", temp2.y, zero, temp2.x), 						//max (0, pow(dot(n.l), kspec))
				gen.code("sge", temp5.y, temp1.z, approx), 					// dot(v.r) >= 0.0000001
				gen.code("mul", temp2.y, temp2.y, temp5.y), 					// temp2.y = phong specular term
				
				gen.fresnel(temp2.z, normal, view, fspecPow, one), 			//fs = DFT
				gen.code("add", temp2.z , temp2.z, half),						// fs = DFT + 0.5
				gen.code("mul", temp2.z, temp2.z, temp2.y), 					// fs * phong specular term
				
				gen.code("pow", temp2.w, temp1.z, krim),						//pow(dot(v.r), krim)
				gen.code("max", temp2.w, temp2.w, zero),						// max (0, pow(dot(v.r), krim))
				gen.code("mul", temp2.w, temp5.y, temp2.w), 					// temp2.w = rim specular
				
				// temp3 =amb  result = independent result,  temp2.y temp2.w temp1 = free 
				gen.fresnel(temp1.x, normal, view, fRimPow, one),
				gen.tex(temp4, uv, gen.FS["rimMask"], "2d", "wrap", "linear", m_rimMask.mipmap),
				gen.code("add", temp4.x, temp4.x, temp4.x),
				gen.code("add", temp4.x, temp4.x, krCol),
				
				gen.code("mul", temp1.x, temp1.x, temp4.x),					// fr * kr
				gen.code("mul", temp1.y, temp1.x, temp2.w), 					//   fr * kr * rim spec
				
				gen.code("max", temp1.z, temp2.z, temp1.y),
				gen.code("mul", temp4, lightCol, temp1.z),
				
				
				gen.tex(view, uv, gen.FS["specMask"], "2d", "wrap", "linear", m_specularMask.mipmap),
				gen.code("add", view.x, view.x, view.x),
				gen.code("add", view.x, view.x, ksCol),
				
				gen.code("mul", temp4, temp4, view.x),
				
				gen.code("mul", temp3, temp1.x, temp3),//ambien based view dependent
				gen.code("mul", temp3, temp5.x, temp3),
				
				gen.code("add", temp4, temp4, temp3),
				gen.code("add", result, result, temp4),
				
				gen.tex(temp2, uv, gen.FS["emissiveMask"], "2d", "wrap", "linear", m_emmisiveMask.mipmap),
				gen.code("add", result.xyz, result.xyz, temp2.xyz),
				
				gen.code("mov", result.w, opacity),
				gen.code("mov", "oc", result)

			].join("\n");
			
	//		trace(gen.printCode( code ));
			return ShaderUtils.fragmentAssambler.assemble(Context3DProgramType.FRAGMENT, code, false );
		}
		
		
		/******************************************************************************************************
		 * Set/Get Constants
		 *****************************************************************************************************/
		public function get spVal():Number{
			return m_spVal;
		}
		
		public function set spVal(_value:Number):void{
			m_spVal = _value;
			getConstantVec("constant2")[2] = m_spVal;
		}
		
		public function get ksColor():Number{
			return m_ksColor;
		}
		
		public function set ksColor(value:Number):void{
			
			if(m_specularMask != TextureMapDefaults.BLACK)
				value = 0;
			
			m_ksColor = value;
			getConstantVec("constant4")[2] = m_ksColor;
		}
	
		
		public function get krColor():Number{
			return m_krColor;
		}
		
		public function set krColor(value:Number):void{
			if(m_rimMask != TextureMapDefaults.BLACK)
				value = 0;

			m_krColor = value;
			getConstantVec("constant4")[3] = m_krColor;
		}
		
		public function get fRimPower():Number
		{
			return m_fRimPower;
		}
		
		public function set fRimPower(value:Number):void
		{
			m_fRimPower = value;
			getConstantVec("constant5")[0] = m_fRimPower;
		}
		
		public function get kRim():Number{
			return m_kRim;
		}
		
		public function set kRim(value:Number):void{
			m_kRim = value;
			getConstantVec("constant4")[1] = m_kRim;
		}
		
		public function get fspecPower():Number
		{
			return m_fspecPower;
		}
		
		public function set fspecPower(value:Number):void
		{
			m_fspecPower = value;
			getConstantVec("constant4")[0] = m_fspecPower;
		}
		
		public function get kSpec():Number
		{
			return m_kSpec;
		}
		
		public function set kSpec(value:Number):void
		{
			if(m_specularMap != TextureMapDefaults.BLACK)
				value = 0;
			
			m_kSpec = value;
			getConstantVec("constant2")[3] = m_kSpec;
		}
		
		public function get color():Color
		{
			return m_color;
		}
		
		public function set color(value:Color):void
		{
			m_color = value;
			getConstantVec("constant3")[0] = m_color.r;
			getConstantVec("constant3")[1] = m_color.g;
			getConstantVec("constant3")[2] = m_color.b;
		}
		
		public function get blendConstant():Number{
			return m_blendConstant;
		}
		
		public function set blendConstant(_value:Number):void{
			m_blendConstant = _value;
			getConstantVec("constant2")[0] = m_blendConstant;
		}
		
		public function get opacity():Number
		{
			return m_opacity;
		}
		
		public function set opacity(value:Number):void
		{
			m_opacity = value;
			getConstantVec("constant1")[3] = m_opacity;
		}
		
		/******************************************************************************************************
		 * Set/Get Textures
		 *****************************************************************************************************/
		
		public function get gradient():TextureMap
		{
			return m_gradient;
		}
		
		public function set gradient(value:TextureMap):void
		{
			m_gradient = value;	
		}
		
		public function get emmisiveMask():TextureMap
		{
			return m_emmisiveMask;
		}
		
		public function set emmisiveMask(value:TextureMap):void
		{
			if(value){
				m_emmisiveMask = value;
			}else{
				m_emmisiveMask = TextureMapDefaults.BLACK;
			}
		}
		
		public function get rimMask():TextureMap
		{
			return m_rimMask;
		}
		
		public function set rimMask(value:TextureMap):void
		{
			if(value){
				m_rimMask = value;
			}else{
				m_rimMask = TextureMapDefaults.BLACK;
			}
			
			krColor = m_krColor;
		}
		
		public function get specularMask():TextureMap
		{
			return m_specularMask;
		}
		
		public function set specularMask(value:TextureMap):void
		{
			if(value){
				m_specularMask = value;
			}else{
				m_specularMask = TextureMapDefaults.BLACK;
			}
			ksColor = m_ksColor;
		}
		
		public function get specularMap():TextureMap
		{
			return m_specularMap;
		}
		
		public function set specularMap(value:TextureMap):void
		{
			if(value){
				m_specularMap = value;
			}else{
				m_specularMap = TextureMapDefaults.BLACK;
			}
			kSpec = m_kSpec;
		}
		
		public function get colorMap():TextureMap
		{
			return m_colorMap;
		}
		
		public function set colorMap(value:TextureMap):void
		{
			if(value)
				m_colorMap = value;
			else
				m_colorMap = TextureMapDefaults.WHITE;
		}
	
	}
}