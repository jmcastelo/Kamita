import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: mainWindow
    color: "black"

    width: 640
    height: 480

    visible: true

    property real factor: 0.0125
    property real base: controlPanel.width * factor
    property real itemHeight: 5 * base
    property real scaledMargin: 0.75 * base
    property real fontSize: 1.5 * base

    Item {
        id: mainItem
        anchors.fill: parent

        Loader {
            id: contentLoader
        }

        function openImage(path) {
            contentLoader.source = "ContentImage.qml"
            contentLoader.item.source = path
            updateSource()
        }

        function openCamera(id) {
            contentLoader.source = "ContentCamera.qml"
            contentLoader.item.camera.deviceId = id
            updateSource()
        }

        function updateSource() {
            if (contentLoader.item) {
                contentLoader.item.parent = mainItem
                contentLoader.item.anchors.fill = mainItem
                seed.updateSource(contentLoader.item)
                //contentLoader.item.visible = false
                //controlPanel.updateSources()
            }
        }

        Seed {
            id: seed
            color: "transparent"
            anchors.fill: parent
        }

        GridLayout {
            id: grid
            visible: false
            z: 2
            anchors.fill: parent
            rows: 8
            columns: 8
            rowSpacing: 0
            columnSpacing: 0
            Repeater{
                id: repeater
                model: grid.rows * grid.columns
                delegate: Rectangle {
                    property int i : parseInt(index / grid.rows)
                    property int j : index % grid.columns
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.row: i
                    Layout.column: j
                    color:"transparent"
                    border.color: "white"
                    border.width: 1
                }
            }
        }

        Controls {
            id: controlPanel
            opacity: 1.0
            enabled: true
            focus: true
            seed: seed
            onCameraInputSelected: mainItem.openCamera(id)
            onImageInputSelected: mainItem.openImage(path)
        }

        Component.onCompleted: {
            grabWindow.source = seed
        }

        Keys.onPressed: {
            if ((event.key === Qt.Key_Tab)  && (event.modifiers & Qt.ControlModifier)) {
                controlPanel.leftAnchored = !controlPanel.leftAnchored
                event.accepted = true
            } else if (event.key === Qt.Key_Tab) {
                if (controlPanel.opacity == 0.0) {
                    controlPanel.opacity = 1.0
                    controlPanel.enabled = true
                    controlPanel.focus = true
                } else {
                    controlPanel.opacity = 0.0
                    controlPanel.enabled = false
                    controlPanel.focus = false
                    focus = true
                }
                event.accepted = true;
            } else if (event.key === Qt.Key_Q) {
                grid.visible = !grid.visible
                event.accepted = true
            } else if ((event.key === Qt.Key_R) && (event.modifiers & Qt.ControlModifier)) {
                controlPanel.grabButton.clicked()
                event.accepted = true
            } else if ((event.key === Qt.Key_T) && (event.modifiers & Qt.ControlModifier)) {
                controlPanel.screenshotButton.clicked()
                event.accepted = true
            }
        }
    }
}
