import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Shift"
            value: 0.0
            min: 0.0
            max: 1.0
            scaledValue: 0.0
            oldScaledValue: 0.0
        }
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
        shift = parameters.get(0).scaledValue
        alpha = parameters.get(1).scaledValue
    }

    // Transform slider values, and bind result to shader uniforms
    property real shift: parameters.get(0).scaledValue
    property real alpha: parameters.get(1).scaledValue

    fragmentShaderFilename: "hueshift.fsh"
}
