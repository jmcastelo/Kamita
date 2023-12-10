import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Size 1"
            value: 0.05
            min: 0.0
            max: 0.02
            scaledValue: 0.001
            oldScaledValue: 0.001
        }
        ListElement {
            name: "Size 2"
            value: 0.05
            min: 0.0
            max: 0.02
            scaledValue: 0.001
            oldScaledValue: 0.001
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
        step1 = parameters.get(0).scaledValue
        step2 = parameters.get(1).scaledValue
        alpha = parameters.get(2).scaledValue
    }

    // Transform slider values, and bind result to shader uniforms
    property real step1: parameters.get(0).scaledValue
    property real step2: parameters.get(1).scaledValue
    property real alpha: parameters.get(2).scaledValue

    fragmentShaderFilename: "morphogradient.fsh"
}
