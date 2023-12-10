import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Center"
            value: 0.55
            min: -10.0
            max: 10.0
            scaledValue: 1.0
            oldScaledValue: 1.0
        }
        ListElement {
            name: "Near"
            value: 0.5
            min: -10.0
            max: 10.0
            scaledValue: 0.0
            oldScaledValue: 0.0
        }
        ListElement {
            name: "Far"
            value: 0.5
            min: -10.0
            max: 10.0
            scaledValue: 0.0
            oldScaledValue: 0.0
        }
        ListElement {
            name: "Size"
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
        kernel1 = parameters.get(0).scaledValue
        kernel2 = parameters.get(1).scaledValue
        kernel3 = parameters.get(2).scaledValue
        step = parameters.get(3).scaledValue
        alpha = parameters.get(4).scaledValue
    }

    // Transform slider values, and bind result to shader uniforms
    property real kernel1: parameters.get(0).scaledValue
    property real kernel2: parameters.get(1).scaledValue
    property real kernel3: parameters.get(2).scaledValue
    property real step: parameters.get(3).scaledValue
    property real alpha: parameters.get(4).scaledValue

    fragmentShaderFilename: "convolution.fsh"
}
