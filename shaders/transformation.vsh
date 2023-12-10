attribute vec4 qt_Vertex;
attribute vec2 qt_MultiTexCoord0;
uniform mat4 qt_Matrix;
uniform mat4 transformation;
varying vec2 qt_TexCoord0;

void main(void)
{
    qt_TexCoord0 = qt_MultiTexCoord0;
    gl_Position = qt_Matrix * transformation * qt_Vertex;
}
