import QtQuick 2.15

Rectangle {
    id: root
    color: mouseArea.pressed ? bgColorSelected : bgColor
    height: itemHeight
    //width: metrics.tightBoundingRect.width * 1.3

    property string text
    property color bgColor: "transparent"
    property color bgColorSelected: "#14aaff"
    property color textColor: "white"
    property alias enabled: mouseArea.enabled
    property bool active: true
    property alias horizontalAlign: text.horizontalAlignment
    property alias strikeout: text.font.strikeout
    property alias textWidth: metrics.tightBoundingRect.width

    signal clicked

    Rectangle {
        id: rect
        color: "transparent"
        anchors.fill: parent
        radius: parent.radius
        anchors.margins: scaledMargin

        property alias text: text
        property alias metrics: metrics

        Text {
            id: text
            clip: true
            text: root.text
            anchors.fill: parent
            font.pointSize: fontSize
            font.strikeout: false
            color: textColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        TextMetrics {
            id: metrics
            font: text.font
            text: text.text
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
        enabled: active
    }
}
