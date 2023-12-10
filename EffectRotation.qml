import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Angle"
            value: 0.5
            min: -180.0
            max: 180.0
            scaledValue: 0.0
            oldScaledValue: 0.0
        }
        onDataChanged: updateParameters(topLeft.row)
    }

    onWidthChanged: updateRotationMatrix()
    onHeightChanged: updateRotationMatrix()

    function updateParameters(index) {
        updateValues(index)
        angle = parameters.get(0).scaledValue
        updateRotationMatrix()
    }

    function updateRotationMatrix() {
        var m = Qt.matrix4x4()
        m.translate(Qt.vector3d(width / 2, height / 2, 0.0))
        m.rotate(angle, Qt.vector3d(0.0, 0.0, 1.0))
        m.translate(Qt.vector3d(-width / 2, -height / 2, 0.0))
        transformation = m
    }

    // Transform slider values, and bind result to shader uniforms
    property real angle: parameters.get(0).scaledValue
    property matrix4x4 transformation: Qt.matrix4x4()

    vertexShaderFilename: "transformation.vsh"
    fragmentShaderFilename: "identity.fsh"
}
