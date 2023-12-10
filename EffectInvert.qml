import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Alpha"
            value: 1.0
            min: 0.0
            max: 1.0
            scaledValue: 1.0
            oldScaledValue: 1.0
        }
        onDataChanged: updateParameters(topLeft.row)
    }

    function updateParameters(index) {
        updateValues(index)
        alpha = parameters.get(0).scaledValue
    }

    // Transform slider values, and bind result to shader uniforms
    property real alpha: parameters.get(0).scaledValue

    fragmentShaderFilename: "invert.fsh"
}
