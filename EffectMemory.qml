import QtQuick 2.15

Effect {
    property variant feedbackSource
    property variant memorySource
    property real memory

    fragmentShaderFilename: "memory.fsh"
}
