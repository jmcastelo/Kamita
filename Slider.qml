import QtQuick 2.15

Rectangle {
    id: root
    color: "transparent"
    radius: 5
    property alias value: grip.value
    property color fillColor: "#14aaff"
    property real gripSize: itemHeight / 2
    property real gripTolerance: 1.0
    property real increment: 0.5
    property bool enabled: true

    signal pressed()

    function gripMoveRight() {
        if (grip.x + increment <= grip.area.drag.maximumX) {
            grip.x += increment
            grip.area.updateValue()
        }
    }

    function gripMoveLeft() {
        if (grip.x - increment >= grip.area.drag.minimumX) {
            grip.x -= increment
            grip.area.updateValue()
        }
    }

    function gripUpdatePosition() {
        grip.updatePosition()
    }

    Rectangle {
        id: slider
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: itemHeight / 3
        color: "transparent"

        Rectangle {
            id: sliderbar
            anchors { fill: parent; margins: 1 }
            radius: 3
            color: Qt.lighter(root.fillColor, 1.5)
            border.width: 1
            border.color: root.fillColor
        }
        Rectangle {
            height: parent.height
            anchors.left: parent.left
            anchors.right: grip.horizontalCenter
            color: root.fillColor
            radius: 3
            border.width: 1
            border.color: Qt.darker(color, 1.5)
            opacity: 0.8
        }
        Rectangle {
            id: grip
            x: (value * parent.width) - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: root.gripTolerance * root.gripSize
            height: width
            radius: width / 2
            color: "transparent"

            property alias area: mouseArea
            property real value: 0.5

            function updatePosition() {
                x = value * parent.width - width / 2
            }

            Rectangle {
                id: sliderhandle
                anchors.centerIn: parent
                width: root.gripSize
                height: width
                radius: width / 2
                border.width: 1
                border.color: Qt.darker(color, 1.5)
                color: "gold"
            }

            MouseArea {
                id: mouseArea
                enabled: root.enabled
                anchors.fill:  parent
                drag {
                    target: grip
                    axis: Drag.XAxis
                    minimumX: -parent.width / 2
                    maximumX: root.width - parent.width / 2
                }
                onPressed: root.pressed()
                onPositionChanged:  {
                    if (drag.active)
                        updateValue()
                }
                onReleased: {
                    updateValue()
                }
                function updateValue() {
                    value = (grip.x + grip.width / 2) / slider.width
                }
            }
        }
    }
}
