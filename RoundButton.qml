import QtQuick 2.15

Rectangle {
    id: root

    property color bgColor: "#0088FF"
    property color bgColorSelected: "#3399FF"
    property string text

    width: 2 * fontSize
    height: width
    radius: width / 2
    color: mouseArea.pressed ? bgColorSelected : bgColor

    signal clicked

    Text {
        id: text
        text: root.text
        anchors.centerIn: parent
        font.pointSize: fontSize
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
