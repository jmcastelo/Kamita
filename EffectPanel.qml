import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    property Content content
    property int index
    property bool highlight: false
    property int receivedFocusFrom: 0
    property alias effectList: effectSelector.effectList
    property alias destroyButton: destroyButton
    property alias enableButton: enableButton

    anchors.margins: scaledMargin

    height: header.anchors.topMargin + header.height + header.anchors.bottomMargin + parameterPanel.anchors.topMargin + parameterPanel.height + parameterPanel.anchors.bottomMargin

    radius: 5
    color: "#33000000"
    border.color: "lightblue"
    border.width: highlight ? 1 : 0
    opacity: 1.0

    signal effectChanged
    signal effectEnabled(int index, bool enabled)
    signal effectDestroyed(int index)
    signal pressed(int index)

    Rectangle {
        id: dragBar
        color: "lightblue"
        opacity: root.highlight ? 1.0 : 0.5
        width: 2 * scaledMargin
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: header
        color: "transparent"
        height: itemHeight
        anchors.margins: scaledMargin
        anchors.top: parent.top
        anchors.left: dragBar.right
        anchors.right: parent.right

        Rectangle {
            id: effectSelector
            height: itemHeight
            anchors.left: parent.left
            anchors.right: enableButton.left
            anchors.margins: scaledMargin
            color: "black"
            opacity: 0.8
            radius: 5
            border.color: "lightblue"
            border.width: effectList.focus ? 1 : 0

            property alias effectList: listview

            ListView {
                id: listview
                anchors.fill: parent

                model: EffectSelectionList {}
                delegate: effectDelegate

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
                    id: effectDelegate
                    CustomButton {
                        id: button
                        text: name
                        anchors.left: parent.left
                        anchors.right: parent.right
                        onClicked: {
                            listview.makeSelectedCurrent()
                            content.effectSource = source
                            parameterPanel.model = content.effect.parameters
                            parameterPanel.parameterList.currentIndex = -1
                            listview.focus = true
                            root.pressed(root.index)
                            effectChanged()
                        }
                    }
                }
            }
        }

        RoundButton {
            id: enableButton
            text: ""
            bgColor: toggled ? "#00FF00" : "#333333"
            bgColorSelected: "transparent"
            anchors.right: destroyButton.left
            anchors.margins: scaledMargin
            anchors.verticalCenter: parent.verticalCenter
            property bool toggled: true
            onClicked: {
                toggled = !toggled
                effectEnabled(root.index, toggled)
            }
        }

        RoundButton {
            id: destroyButton
            text: qsTr("")
            bgColor: "#FF0000"
            bgColorSelected: "#FF3333"
            anchors.right: parent.right
            anchors.margins: scaledMargin
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                 effectDestroyed(index)
            }
        }
    }


    ParameterPanel {
        id: parameterPanel
        anchors.left: header.left
        anchors.right: header.right
        anchors.top: header.bottom
        onPressed : {
            root.pressed(root.index)
        }
    }

    onFocusChanged: {
        if (focus) {
            if (receivedFocusFrom == 1) {
                effectSelector.effectList.focus = true
            } else if (receivedFocusFrom == -1) {
                if (parameterPanel.parameterList.count > 0) {
                    parameterPanel.parameterList.currentIndex = parameterPanel.parameterList.count - 1
                    parameterPanel.parameterList.focus = true
                } else {
                    effectSelector.effectList.focus = true
                }
            } else if (receivedFocusFrom == 0) {
                if ((parameterPanel.parameterList.count > 0) && (parameterPanel.parameterList.currentIndex != -1)) {
                    parameterPanel.parameterList.focus = true
                } else {
                    effectSelector.effectList.focus = true
                }
            }
            highlight = true
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_E) {
            effectSelector.effectList.focus = false
            parameterPanel.parameterList.focus = false
            event.accepted = false
        } else if (event.key === Qt.Key_Down) {
            if (parameterPanel.parameterList.count > 0) {
                if ((parameterPanel.parameterList.focus && (parameterPanel.parameterList.currentIndex == -1))) {
                    highlight = false
                    event.accepted = false
                } else if (!parameterPanel.parameterList.focus) {
                    parameterPanel.parameterList.focus = true
                    parameterPanel.parameterList.currentIndex = 0
                    event.accepted = true
                } else {
                    event.accepted = false
                }
            } else {
                effectSelector.effectList.focus = false
                highlight = false
                event.accepted = false
            }
        } else if (event.key === Qt.Key_Up) {
            if (effectSelector.effectList.focus) {
                effectSelector.effectList.focus = false
                highlight = false
                event.accepted = false
            } else if (parameterPanel.parameterList.focus && parameterPanel.parameterList.currentIndex == -1) {
                effectSelector.effectList.focus = true
                event.accepted = true
            } else {
                event.accepted = true
            }
        } else {
            event.accepted = false
        }
    }
}
