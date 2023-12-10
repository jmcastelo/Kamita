import QtQuick 2.15

Effect {
    parameters: ListModel {
        ListElement {
            name: "Alpha"
            value: 0.75
            min: 0.0
            max: 1.0
            scaledValue: 0.75
            oldScaledValue: 0.75
        }
        ListElement {
            name: "Memory"
            value: 0.25
            min: 0.0
            max: 1.0
            scaledValue: 0.25
            oldScaledValue: 0.25
        }
        onDataChanged: updateParameters(topLeft.row)
    }

    function updateParameters(index) {
        updateValues(index)
        alpha = parameters.get(0).scaledValue
        memory = parameters.get(1).scaledValue
    }

    property bool feedback: false
    //property variant feedbackSource
    property variant memorySource
    property real alpha: parameters.get(0).scaledValue
    property real memory: parameters.get(1).scaledValue

    fragmentShaderFilename: "seed.fsh"
}
