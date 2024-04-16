#version 410

in vec3 varyingNormal;
in vec3 varyingLightDir;
in vec3 varyingVertPos;
in vec2 tc;
in vec4 glp;
out vec4 color;

layout (binding=0) uniform sampler2D reflectTex;
layout (binding=1) uniform sampler2D refractTex;
layout (binding=2) uniform sampler3D noiseTex;
//layout (binding=2) uniform sampler2D noiseTex;

struct PositionalLight
{	vec4 ambient;  
	vec4 diffuse;  
	vec4 specular;  
	vec3 position;
};

struct Material
{	vec4 ambient;  
	vec4 diffuse;  
	vec4 specular;  
	float shininess;
};

uniform vec4 globalAmbient;
uniform PositionalLight light;
uniform Material material;
uniform mat4 mv_matrix;	 
uniform mat4 proj_matrix;
uniform mat4 norm_matrix;
uniform int isAbove;

vec3 estimateWaveNormal(float offset, float mapScale, float hScale)
{	// estimate the normal using the noise texture
	// by looking up three height values around this vertex
	float h1 = (texture(noiseTex, vec3(((tc.s)    )*mapScale, 0.5, ((tc.t)+offset)*mapScale))).r * hScale;
	float h2 = (texture(noiseTex, vec3(((tc.s)-offset)*mapScale, 0.5, ((tc.t)-offset)*mapScale))).r * hScale;
	float h3 = (texture(noiseTex, vec3(((tc.s)+offset)*mapScale, 0.5, ((tc.t)-offset)*mapScale))).r * hScale;
	vec3 v1 = vec3(0, h1, -1);
	vec3 v2 = vec3(-1, h2, 1);
	vec3 v3 = vec3(1, h3, 1);
	vec3 v4 = v2-v1;
	vec3 v5 = v3-v1;
	vec3 normEst = normalize(cross(v4,v5));
	return normEst;
}

void main(void)
{	// normalize the light, normal, and view vectors:
	vec3 L = normalize(varyingLightDir);
	vec3 N = normalize(varyingNormal);
	vec3 V = normalize(-varyingVertPos);
	
	// estimate the normal using the noise texture
	// by looking up three height values around this vertex.
	// input parameters are offset for neighbors, and scaling for width and height
	N = estimateWaveNormal(.0002, 32.0, 16.0);
			
	// get the angle between the light and surface normal:
	float cosTheta = dot(L,N);
	
	// compute light reflection vector, with respect N:
	vec3 R = normalize(reflect(-L, N));
	
	// angle between the view vector and reflected light:
	float cosPhi = dot(V,R);

	// compute ADS contributions (per pixel):
	vec3 ambient = ((globalAmbient * material.ambient) + (light.ambient * material.ambient)).xyz;
	vec3 diffuse = light.diffuse.xyz * material.diffuse.xyz * max(cosTheta,0.0);
	vec3 specular = light.specular.xyz * material.specular.xyz * pow(max(cosPhi,0.0), material.shininess);
	
	vec4 mixColor, reflectColor, refractColor, blueColor;
	blueColor = vec4(0.0, 0.25, 1.0, 1.0);

	if (isAbove == 1)
	{	refractColor = texture(refractTex, (vec2(glp.x,glp.y))/(2.0*glp.w)+0.5);
		reflectColor = texture(reflectTex, (vec2(glp.x,-glp.y))/(2.0*glp.w)+0.5);
		mixColor = (0.2 * refractColor) + (1.0 * reflectColor);
	}
	else
	{	refractColor = texture(refractTex, (vec2(glp.x,glp.y))/(2.0*glp.w)+0.5);
		mixColor = (0.5 * blueColor) + (0.6 * refractColor);
	}
	color = vec4((mixColor.xyz * (ambient + diffuse) + 0.75*specular), 1.0);
//	color = vec4((blueColor.xyz * (ambient + diffuse) + specular), 1.0);
//	color = vec4(specular,1.0);
}
