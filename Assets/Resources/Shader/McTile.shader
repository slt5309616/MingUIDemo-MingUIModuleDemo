Shader "MC/McTile"
{
	Properties{
		_Color("Main Color", Color) = (1,1,1,0.6) }

		SubShader{
		Pass{
		Blend SrcAlpha OneMinusSrcAlpha
		Color[_Color]
		Lighting Off
		Cull Off
	}
	}
		FallBack "VertexLit"
}