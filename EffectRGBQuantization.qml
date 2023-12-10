import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Red"
            value: 0.5
            min: 2.0
            max: 64.0
            scaledValue: 31.0
            oldScaledValue: 31.0
        }
        ListElement {
            name: "Green"
            value: 0.5
            min: 2.0
            max: 64.0
            scaledValue: 31.0
            oldScaledValue: 31.0
        }
        ListElement {
            name: "Blue"
            value: 0.5
            min: 2.0
            max: 64.0
            scaledValue: 31.0
            oldScaledValue: 31.0
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
        if (index < 3) {
            updateIntValues(index)
        } else {
            updateValues(index)
        }
        redLevels = parseInt(parameters.get(0).scaledValue)
        greenLevels = parseInt(parameters.get(1).scaledValue)
        blueLevels = parseInt(parameters.get(2).scaledValue)
        alpha = parameters.get(3).scaledValue
    }

    // Transform slider values, and bind result to shader uniforms
    property int redLevels: parseInt(parameters.get(0).scaledValue)
    property int greenLevels: parseInt(parameters.get(1).scaledValue)
    property int blueLevels: parseInt(parameters.get(2).scaledValue)
    property real alpha: parameters.get(3).scaledValue

    fragmentShaderFilename: "rgbquantization.fsh"
}
