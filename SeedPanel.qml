import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15

Rectangle {
    id: root

    property Seed seed
    property int index
    property bool highlight: true
    property int receivedFocusFrom: 0
    property alias enableButton: enableButton

    anchors.margins: scaledMargin

    height: header.anchors.topMargin + header.height + header.anchors.bottomMargin + parameterPanel.anchors.topMargin + parameterPanel.height + parameterPanel.anchors.bottomMargin

    radius: 5
    color: "#33000000"
    border.color: "lightblue"
    border.width: highlight ? 1 : 0
    opacity: 1.0

    signal inputChanged(string id)
    signal feedbackEnabled(bool enabled)
    signal pressed(int index)

    Rectangle {
        id: header
        color: "transparent"
        height: itemHeight
        anchors.margins: scaledMargin
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: inputSelector
            height: itemHeight
            anchors.left: parent.left
            anchors.right: enableButton.left
            anchors.margins: scaledMargin
            color: "black"
            opacity: 0.8
            radius: 5
            border.color: "lightblue"
            border.width: inputList.focus ? 1 : 0

            property alias inputList: listview

            ListView {
                id: listview
                anchors.fill: parent

                model: inputModel
                delegate: inputDelegate

                clip: true

                maximumFlickVelocity: itemHeight * 8
                flickDeceleration: 800
                highlight: Rectangle { color: "lightsteelblue"; radius: 5; opacity: 0.3 }
                highlightFollowsCurrentItem: true
                keyNavigationEnabled: false

                property int selectedIndex: 0

                onFocusChanged: {
                    if (!focus) {
                        positionViewAtIndex(currentIndex, ListView.Contain)
                        selectedIndex = currentIndex
                    }
                }

                Keys.onPressed: {
                    if (event.key === Qt.Key_Right) {
                        selectedIndex = (selectedIndex + 1) % count
                        positionViewAtIndex(selectedIndex, ListView.Contain)
                        event.accepted = true
                    } else if (event.key === Qt.Key_Left) {
                        selectedIndex--
                        if (selectedIndex < 0)
                            selectedIndex = count - 1
                        positionViewAtIndex(selectedIndex, ListView.Contain)
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return) {
                        currentIndex = selectedIndex
                        currentItem.clicked()
                        event.accepted = true
                    } else {
                        event.accepted = false
                    }
                }

                onFlickEnded: {
                    selectedIndex = indexAt(visibleArea.xPosition * contentWidth + width / 2, visibleArea.yPosition * contentHeight + height / 2)
                    positionViewAtIndex(selectedIndex, ListView.Contain)
                }

                function makeSelectedCurrent() {
                    currentIndex = selectedIndex
                }

                Component {
                    id: inputDelegate
                    CustomButton {
                        id: button
                        text: displayName
                        anchors.left: parent.left
                        anchors.right: parent.right
                        onClicked: {
                            listview.makeSelectedCurrent()
                            parameterPanel.parameterList.currentIndex = -1
                            listview.focus = true
                            root.pressed(root.index)
                            inputChanged(deviceId)
                        }
                    }
                }
            }
        }

        RoundButton {
            id: enableButton
            text: ""
            bgColor: toggled ? "gold" : "#333333"
            bgColorSelected: "transparent"
            anchors.right: parent.right
            anchors.margins: scaledMargin
            anchors.verticalCenter: parent.verticalCenter
            property bool toggled: false
            onClicked: {
                toggled = !toggled
                feedbackEnabled(toggled)
            }
        }
    }

    ListModel {
        id: inputModel
        ListElement { displayName: "Image"; deviceId: "Image" }
        Component.onCompleted: {
           [QtMultimedia.availableCameras].forEach(function(e){append(e)})
        }
    }


    ParameterPanel {
        id: parameterPanel
        anchors.top: header.bottom
        anchors.left: header.left
        anchors.right: header.right
        model: seed.effect.parameters
        onPressed : {
            root.pressed(root.index)
        }
    }

    onFocusChanged: {
        if (focus) {
            if (receivedFocusFrom == 1) {
                inputSelector.inputList.focus = true
            } else if (receivedFocusFrom == -1) {
                parameterPanel.parameterList.currentIndex = parameterPanel.parameterList.count - 1
                parameterPanel.parameterList.focus = true
            } else if (receivedFocusFrom == 0) {
                if (parameterPanel.parameterList.currentIndex != -1) {
                    parameterPanel.parameterList.focus = true
                } else {
                    inputSelector.inputList.focus = true
                }
            }
            highlight = true
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_E) {
            inputSelector.inputList.focus = false
            parameterPanel.parameterList.focus = false
            event.accepted = false
        } else if (event.key === Qt.Key_Down) {
            if (parameterPanel.parameterList.focus && (parameterPanel.parameterList.currentIndex == -1)) {
                highlight = false
                event.accepted = false
            } else if (!parameterPanel.parameterList.focus) {
                parameterPanel.parameterList.focus = true
                parameterPanel.parameterList.currentIndex = 0
                event.accepted = true
            } else {
                event.accepted = false
            }
        } else if (event.key === Qt.Key_Up) {
            if (inputSelector.inputList.focus) {
                highlight = false
                event.accepted = false
            } else if (parameterPanel.parameterList.focus && parameterPanel.parameterList.currentIndex == -1) {
                inputSelector.inputList.focus = true
                event.accepted = true
            } else {
                event.accepted = true
            }
        } else {
            event.accepted = false
        }
    }
}
