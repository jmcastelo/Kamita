import QtQuick 2.15

ShaderEffect {
    blending: false

    property variant source
    property ListModel parameters: ListModel {}
    property real targetWidth: 0
    property real targetHeight: 0
    property string fragmentShaderFilename: "identity.fsh"
    property string vertexShaderFilename

    onFragmentShaderFilenameChanged: {
        fragmentShader = fileReader.readFile(":shaders/" + fragmentShaderFilename)
    }
    onVertexShaderFilenameChanged:
        vertexShader = fileReader.readFile(":shaders/" + vertexShaderFilename)

    function updateValues(index) {
        if (parameters.get(index).scaledValue === parameters.get(index).oldScaledValue) {
            parameters.get(index).scaledValue = parameters.get(index).min + parameters.get(index).value * (parameters.get(index).max - parameters.get(index).min)
        } else {
            parameters.get(index).value = (parameters.get(index).scaledValue - parameters.get(index).min) / (parameters.get(index).max - parameters.get(index).min)
        }
        parameters.get(index).oldScaledValue = parameters.get(index).scaledValue
    }
    function updateIntValues(index) {
        if (parameters.get(index).scaledValue === parameters.get(index).oldScaledValue) {
            parameters.get(index).scaledValue = parseInt(parameters.get(index).min + parameters.get(index).value * (parameters.get(index).max - parameters.get(index).min))
        } else {
            parameters.get(index).value = (parameters.get(index).scaledValue - parameters.get(index).min) / (parameters.get(index).max - parameters.get(index).min)
        }
        parameters.get(index).oldScaledValue = parameters.get(index).scaledValue
    }
}
