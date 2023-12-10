import QtQuick 2.15

Rectangle {
    id: root
    color: "transparent"
    height: view.model ? view.model.count * sliderHeight : 0
    anchors.margins: view.model ? (view.model.count > 0 ? scaledMargin : 0) : 0

    property color lineColor: "black"
    property real gripSize: itemHeight / 2
    property real sliderHeight: itemHeight

    property alias parameterList: view

    property ListModel model: ListModel {}

    signal pressed()

    Component {
        id: editDelegate

        Rectangle {
            id: delegate
            width: parent.width
            height: root.sliderHeight
            color: "transparent"

            property alias theSlider: slider
            property alias theText: parameterName
            property alias theValue: parameterValue

            Text {
                id: parameterName
                text: name
                color: "white"
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: scaledMargin
                }
                font.pointSize: fontSize
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                width: 8 * fontSize

                MouseArea {
                    id : mouseArea
                    anchors.fill: parent
                    onPressed: {
                        view.currentIndex = view.indexAt(view.originX + delegate.x + parent.x + x, view.originY + delegate.y + parent.y + y)
                        //view.focus = true
                        view.forceActiveFocus()
                        root.pressed()
                    }
                }
            }

            TextInput {
                id: parameterValue
                text: Number(model.scaledValue).toLocaleString(Qt.locale(), 'f', 4)
                color: "white"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parameterName.right
                anchors.margins: scaledMargin
                font.pointSize: fontSize
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                width: 4 * fontSize
                validator: DoubleValidator {
                    bottom: model.min
                    top: model.max
                    decimals: 4
                    notation: DoubleValidator.StandardNotation
                }
                onAccepted: {
                    view.model.setProperty(index, "scaledValue", Number.fromLocaleString(Qt.locale(), text))
                    slider.value = model.value
                    slider.gripUpdatePosition()
                }
                onFocusChanged: {
                    if (focus) {
                        view.currentIndex = view.indexAt(view.originX + delegate.x + x, view.originY + delegate.y + y)
                        focus = true
                        root.pressed()
                    } else {
                        text = Number(model.scaledValue).toLocaleString(Qt.locale(), 'f', 4)
                    }
                }
                Keys.onEscapePressed: focus = false
            }

            Slider {
                id: slider
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parameterValue.right
                    leftMargin: scaledMargin + root.gripSize / 2
                    right: parent.right
                    rightMargin: scaledMargin + root.gripSize / 2
                }
                gripSize: root.gripSize
                value: model.value
                onValueChanged: {
                    view.model.setProperty(index, "value", value)
                    parameterValue.text = Number(model.scaledValue).toLocaleString(Qt.locale(), 'f', 4)
                }
                onPressed: {
                    view.currentIndex = view.indexAt(view.originX + delegate.x + x, view.originY + delegate.y + y)
                    //view.focus = true
                    view.forceActiveFocus()
                    root.pressed()
                }
            }
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        model: root.model
        delegate: editDelegate
        clip: true
        currentIndex: -1
        highlight: Rectangle { color: "lightsteelblue"; radius: 5; opacity: 0.2 }
        highlightFollowsCurrentItem: true
        keyNavigationEnabled: false

        onActiveFocusChanged: {
            if (!activeFocus) {
                currentIndex = -1
            }
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Down) {
                currentIndex++
                if (currentIndex >= count) {
                    currentIndex = -1
                    event.accepted = false
                } else {
                    event.accepted = true
                }
            } else if (event.key === Qt.Key_Up) {
                currentIndex--
                if (currentIndex < 0) {
                    currentIndex = -1
                    event.accepted = false
                } else {
                    event.accepted = true
                }
            } else if ((event.key === Qt.Key_E) && currentItem) {
                currentItem.theValue.focus = true
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                currentItem.theSlider.gripMoveLeft();
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                currentItem.theSlider.gripMoveRight();
                event.accepted = true
            } else {
                event.accepted = false
            }
        }
    }
}
