import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Hue"
            value: 0.5
            min: 0.0
            max: 1.0
            scaledValue: 0.5
            oldScaledValue: 0.5
        }
        ListElement {
            name: "Width"
            value: 0.2
            min: 0.0
            max: 1.0
            scaledValue: 0.2
            oldScaledValue: 0.2
        }
        ListElement {
            name: "Gain"
            value: 0.1
            min: 0.0
            max: 1.0
            scaledValue: 0.1
            oldScaledValue: 0.1
        }
        ListElement {
            name: "Loss"
            value: 0.2
            min: 0.0
            max: 1.0
            scaledValue: 0.2
            oldScaledValue: 0.2
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
        targetHue = parameters.get(0).scaledValue
        hueWidth = parameters.get(1).scaledValue
        gain = parameters.get(2).scaledValue
        loss = parameters.get(3).scaledValue
        alpha = parameters.get(4).scaledValue
    }

    // Transform slider values, and bind result to shader uniforms
    property real targetHue: parameters.get(0).scaledValue
    property real hueWidth: parameters.get(1).scaledValue
    property real gain: parameters.get(2).scaledValue
    property real loss: parameters.get(3).scaledValue
    property real alpha: parameters.get(4).scaledValue

    fragmentShaderFilename: "isolate.fsh"
}
