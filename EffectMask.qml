import QtQuick 2.15

Effect {
    property real scaleX: targetHeight >= targetWidth ? 1.0 : targetWidth / targetHeight
    property real scaleY: targetHeight >= targetWidth ? targetHeight / targetWidth : 1.0

    fragmentShaderFilename: "mask.fsh"
}
