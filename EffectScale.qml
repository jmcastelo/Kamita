import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Factor"
            value: 0.5
            min: 0.0
            max: 2.0
            scaledValue: 1.0
            oldScaledValue: 1.0
        }
        onDataChanged: updateParameters(topLeft.row)
    }

    onWidthChanged: updateScalenMatrix()
    onHeightChanged: updateScaleMatrix()

    function updateParameters(index) {
        updateValues(index)
        factor = parameters.get(0).scaledValue
        updateScaleMatrix()
    }

    function updateScaleMatrix() {
        var m = Qt.matrix4x4()
        m.translate(Qt.vector3d(width / 2, height / 2, 0.0))
        m.scale(factor)
        m.translate(Qt.vector3d(-width / 2, -height / 2, 0.0))
        transformation = m
    }

    // Transform slider values, and bind result to shader uniforms
    property real factor: parameters.get(0).scaledValue
    property matrix4x4 transformation: Qt.matrix4x4()

    vertexShaderFilename: "transformation.vsh"
    fragmentShaderFilename: "identity.fsh"
}
