import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQml 2.15

Rectangle {
    id: controls
    width: 500
    color: "#88000000"
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    z: 2

    property Seed seed
    property alias grabButton: grabButton
    property alias screenshotButton: screenshotButton
    property var effectPanels: []
    property var contents: []
    property int focusedPanel: -1
    property int lastEnabled: -1
    property bool leftAnchored: true
    property bool loop: false

    signal cameraInputSelected(string id)
    signal imageInputSelected(var path)

    onFocusChanged: {
        if (focus) {
            if (focusedPanel == -1) {
                seedPanel.receivedFocusFrom = 0
                seedPanel.forceActiveFocus()
            } else if (effectPanels.length > 0) {
                effectPanels[focusedPanel].receivedFocusFrom = 0
                effectPanels[focusedPanel].forceActiveFocus()
            }
        }
    }

    onLeftAnchoredChanged: {
        if (leftAnchored) {
            anchors.right = undefined
            anchors.left = parent.left
            handle.anchors.right = undefined
            handle.anchors.left = right
        } else {
            anchors.left = undefined
            anchors.right = parent.right
            handle.anchors.left = undefined
            handle.anchors.right = left
        }
    }

    RowLayout {
        id: rowLayoutA
        height: itemHeight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: scaledMargin

        CustomButton {
            id: addEffectButton
            text: qsTr("Add Effect")
            bgColor: "green"
            bgColorSelected: "lightgreen"
            radius: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlign: Qt.AlignHCenter
            onClicked: {
                addEffect()
            }
        }

        CustomButton {
            id: smoothButton
            text: "Smooth"
            strikeout: !smoothiness
            bgColor: "darkred"
            bgColorSelected: "red"
            radius: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlign: Qt.AlignHCenter
            property bool smoothiness: true
            onClicked: {
                smoothiness = !smoothiness
                seed.smooth = smoothiness
                contents.forEach(function(content){ content.smooth = smoothiness })
            }
        }
    }

    RowLayout {
        id: rowLayoutB
        height: itemHeight
        anchors.top: rowLayoutA.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: scaledMargin

        CustomButton {
            id: grabButton
            text: "Record Video"
            bgColor: grabbing ? "darkred" : "steelblue"
            bgColorSelected: grabbing ? "red" : "lightsteelblue"
            radius: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlign: Qt.AlignHCenter
            property bool grabbing: false
            onClicked: {
                if (!grabbing) {
                    text = "Stop Recording"
                    grabbing = true
                    grabWindow.start()
                } else {
                    text = "Record Video"
                    grabbing = false
                    grabWindow.stop()
                }
            }
        }

        CustomButton {
            id: screenshotButton
            text: qsTr("Take Screenshot")
            bgColor: "steelblue"
            bgColorSelected: "lightsteelblue"
            radius: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlign: Qt.AlignHCenter
            onClicked: {
                var path = grabWindow.outputDir + new Date().toLocaleString(Qt.locale(), "yyyy-MM-ddTHH:mm:ss") + ".png";
                if (lastEnabled >= 0) {
                    contents[lastEnabled].grabToImage(function(result){ result.saveToFile(path) })
                } else {
                    seed.grabToImage(function(result){ result.saveToFile(path) })
                }
            }
        }

        CustomButton {
            id: outputDirButton
            text: qsTr("Output Dir")
            bgColor: "steelblue"
            bgColorSelected: "lightsteelblue"
            radius: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlign: Qt.AlignHCenter
            onClicked: outputDirDialog.visible = true
        }

    }

    SeedPanel {
        id: seedPanel
        index: -1
        seed: controls.seed
        anchors.top: rowLayoutB.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: scaledMargin
        onInputChanged: {
            if (id == "Image") {
                inputImageDialog.visible = true
            } else {
                controls.cameraInputSelected(id)
            }
        }
        onFeedbackEnabled: {
            loop = enabled
            if (loop) {
                connectLoop()
            } else {
                seed.updateFeedbackSource(null)
                disconnectLoop()
            }
        }
        onPressed: highlightPanel(index)
    }

    FolderDialog {
        id: outputDirDialog
        visible: false
        title: "Please choose output directory"
        currentFolder: grabWindow ? grabWindow.outputUrl : ""
        options: FolderDialog.ShowDirsOnly
        onAccepted: {
            grabWindow.outputUrl = folder
        }
    }

    FileDialog {
        id: inputImageDialog
        visible: false
        title: "Please choose input image"
        folder: grabWindow ? grabWindow.outputUrl : ""
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)"]
        onAccepted: {
            controls.imageInputSelected(file)
        }
    }

    Keys.onPressed: {
        if ((event.key === Qt.Key_A) && (event.modifiers & Qt.ControlModifier)) {
            addEffect()
            event.accepted = true
        } else if ((event.key === Qt.Key_F) && (event.modifiers & Qt.ControlModifier)) {
            seedPanel.enableButton.clicked()
            event.accepted = true
        } else if ((event.key === Qt.Key_O) && (event.modifiers & Qt.ControlModifier)) {
            outputDirButton.clicked()
            event.accepted = true
        } else if ((event.key === Qt.Key_S) && (event.modifiers & Qt.ControlModifier)) {
            smoothButton.clicked()
            event.accepted = true
        } else if ((event.key === Qt.Key_X) && (event.modifiers & Qt.ControlModifier) && (effectPanels.length > 0) && (focusedPanel >= 0)) {
            effectPanels[focusedPanel].destroyButton.clicked()
            event.accepted = true
        } else if ((event.key === Qt.Key_Z) && (event.modifiers & Qt.ControlModifier) && (effectPanels.length > 0) && (focusedPanel >= 0)) {
            effectPanels[focusedPanel].enableButton.clicked()
            event.accepted = true
        } else if ((event.key === Qt.Key_PageDown) && (effectPanels.length > 0) && (focusedPanel >= 0)) {
            moveEffectDown(effectPanels[focusedPanel].index)
            event.accepted = true
        } else if ((event.key === Qt.Key_PageUp) && (effectPanels.length > 0) && (focusedPanel >= 0)) {
            moveEffectUp(effectPanels[focusedPanel].index)
            event.accepted = true
        } else {
            updatePanelsFocus(event)
        }
    }

    function updatePanelsFocus(event) {
        if (event.key === Qt.Key_Down) {
            focusedPanel++
            if (focusedPanel >= effectPanels.length) {
                focusedPanel = -1
            }
            if (focusedPanel == -1) {
                seedPanel.receivedFocusFrom = 1
                seedPanel.forceActiveFocus()
            } else {
                effectPanels[focusedPanel].receivedFocusFrom = 1
                effectPanels[focusedPanel].forceActiveFocus()
            }
            event.accepted = true
        } else if (event.key === Qt.Key_Up) {
            focusedPanel--
            if (focusedPanel < -1) {
                focusedPanel = effectPanels.length - 1
            }
            if (focusedPanel == -1) {
                seedPanel.receivedFocusFrom = -1
                seedPanel.forceActiveFocus()
            } else {
                effectPanels[focusedPanel].receivedFocusFrom = -1
                effectPanels[focusedPanel].forceActiveFocus()
            }
            event.accepted = true
        } else {
            event.accepted = false
        }
    }

    function addEffect() {
        var component1 = Qt.createComponent("Content.qml")
        var content = component1.createObject(parent)

        content.color = "transparent"
        content.anchors.fill = parent
        content.init()

        var component2 = Qt.createComponent("EffectPanel.qml")
        var effectPanel = component2.createObject(scrollableArea.effectColumn)

        effectPanel.content = content
        effectPanel.effectList.forceActiveFocus()
        effectPanel.anchors.left = scrollableArea.effectColumn.left
        effectPanel.anchors.right = scrollableArea.effectColumn.right
        effectPanel.pressed.connect(highlightPanel)
        effectPanel.effectChanged.connect(updateSources)
        effectPanel.effectChanged.connect(adjustEffectPanels)
        effectPanel.effectEnabled.connect(enableEffect)
        effectPanel.effectDestroyed.connect(destroyEffect)

        effectPanels.splice(focusedPanel + 1, 0, effectPanel)
        contents.splice(focusedPanel + 1, 0, content)

        if (loop) {
            disconnectLoop()
        }

        recalculateIndices()
        highlightPanel(effectPanel.index)
        updateSources()
        adjustEffectPanels()

        if (loop) {
            connectLoop()
        }
    }

    function highlightPanel(index) {
        seedPanel.highlight = false
        effectPanels.forEach(function(panel){ panel.highlight = false })
        if (index === -1) {
            seedPanel.highlight = true
        } else {
            effectPanels[index].highlight = true
        }
        focusedPanel = index
    }

    function disconnectLoop() {
        if (lastEnabled >= 0) {
            contents[lastEnabled].sourcePainted.disconnect(seed.paintFeedbackSource)
            contents[lastEnabled].effectChanged.disconnect(updateFeedbackSource)
        }
    }

    function connectLoop() {
        if (lastEnabled >= 0) {
            seed.updateFeedbackSource(contents[lastEnabled].effect)
            contents[lastEnabled].sourcePainted.connect(seed.paintFeedbackSource)
            contents[lastEnabled].effectChanged.connect(updateFeedbackSource)
        }
    }

    function updateFeedbackSource() {
        if (lastEnabled >= 0) {
            seed.updateFeedbackSource(contents[lastEnabled].effect)
        } else {
            seed.updateFeedbackSource(null)
        }
    }

    function updateSources() {
        var l = contents.length

        if (l > 0) {
            seed.visible = false
            contents.forEach(function(content){ content.visible = false })

            for (var i = 0; i < l; i++) {
                if (contents[i].enabled) {
                    contents[i].updateSource(seed.effect)
                    break
                } else {
                    contents[i].updateSource(null)
                }
            }

            lastEnabled = i

            for (var j = i + 1; j < l; j++) {
                if (contents[j].enabled) {
                    contents[j].updateSource(contents[lastEnabled].effect)
                    lastEnabled = j
                } else {
                    contents[j].updateSource(null)
                }
            }
            if (lastEnabled < l) {
                contents[lastEnabled].visible = true
                grabWindow.source = contents[lastEnabled]
            } else {
                lastEnabled = -1
                if (loop) {
                    updateFeedbackSource()
                }
                seed.visible = true
                grabWindow.source = seed
            }
        } else {
            lastEnabled = -1
            if (loop) {
                updateFeedbackSource()
            }
            seed.visible = true
            grabWindow.source = seed
        }
    }

    function adjustEffectPanels() {
        var l = effectPanels.length

        if (l > 0) {
            effectPanels[0].y = effectPanels[0].anchors.topMargin
            scrollableArea.effectColumn.height = effectPanels[0].height + effectPanels[0].anchors.topMargin + effectPanels[0].anchors.bottomMargin

            for (var i = 1; i < l; i++) {
                effectPanels[i].y = effectPanels[i].anchors.topMargin + effectPanels[i -1].y + effectPanels[i - 1].height + effectPanels[i - 1].anchors.bottomMargin
                scrollableArea.effectColumn.height += effectPanels[i].height + effectPanels[i].anchors.topMargin + effectPanels[i].anchors.bottomMargin
            }

            scrollableArea.contentHeight = scrollableArea.effectColumn.height
        } else {
            scrollableArea.effectColumn.height = 0
            scrollableArea.contentHeight = 0
        }
    }

    function recalculateIndices() {
        for (var i = 0; i < effectPanels.length; i++) {
            effectPanels[i].index = i
        }
    }

    function enableEffect(index, enabled) {
        if (index >= 0) {
            var reconnectLoop = (index >= lastEnabled)
            if (loop && reconnectLoop) {
                disconnectLoop();
            }

            contents[index].enabled = enabled
            updateSources()

            if (loop && reconnectLoop) {
                connectLoop();
            }
        }
    }

    function destroyEffect(index) {
        if (index >= 0) {
            var reconnectLoop = (index === lastEnabled)
            if (loop && reconnectLoop) {
                disconnectLoop();
            }

            contents[index].destroy()
            contents.splice(index, 1)

            effectPanels[index].destroy()
            effectPanels.splice(index, 1)

            if (effectPanels.length > 0) {
                if (focusedPanel >= effectPanels.length)
                    focusedPanel = effectPanels.length - 1
                effectPanels[focusedPanel].focus = true
            } else {
                focusedPanel = -1
                seedPanel.focus = true
            }

            recalculateIndices()
            updateSources()
            adjustEffectPanels()

            if (loop && reconnectLoop) {
                connectLoop();
            }
        }
    }

    function moveEffectUp(index) {
        if (index > 0) {
            var reconnectLoop = ((index === lastEnabled) && contents[index - 1].enabled)
            if (loop && reconnectLoop) {
                disconnectLoop()
            }

            var c = contents[index]
            contents[index] = contents[index - 1]
            contents[index - 1] = c

            var e = effectPanels[index]
            effectPanels[index] = effectPanels[index - 1]
            effectPanels[index - 1] = e

            focusedPanel--

            recalculateIndices()
            updateSources()
            adjustEffectPanels()

            if (loop && reconnectLoop) {
                connectLoop();
            }
        }
    }

    function moveEffectDown(index) {
        if (index < effectPanels.length - 1) {
            var reconnectLoop = ((index + 1 === lastEnabled) && contents[index].enabled)
            if (loop && reconnectLoop) {
                disconnectLoop()
            }

            var c = contents[index]
            contents[index] = contents[index + 1]
            contents[index + 1] = c

            var e = effectPanels[index]
            effectPanels[index] = effectPanels[index + 1]
            effectPanels[index + 1] = e

            focusedPanel++
            if (focusedPanel >= effectPanels.length)
                focusedPanel = effectPanels.length - 1

            recalculateIndices()
            updateSources()
            adjustEffectPanels()

            if (loop && reconnectLoop) {
                connectLoop();
            }
        }
    }

    ScrollView {
        id: scrollableArea
        anchors.top: seedPanel.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: scaledMargin
        contentHeight: column.height
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        property alias effectColumn: column

        Keys.onPressed: updatePanelsFocus(event)

        Rectangle {
            id: column
            anchors.top: parent.top
            width: parent.width
            color: "transparent"

            MouseArea {
                id: mouseArea
                anchors.fill: parent

                drag.target: parent
                drag.axis: Drag.YAxis

                property int index
                property real y0

                onPressed: {
                    index = parent.childAt(mouse.x, mouse.y).index
                    if (index >= 0) {
                        focusedPanel = index
                        effectPanels[index].focus = true
                        effectPanels[index].z = 3
                    }
                    y0 = mouse.y
                }

                onPositionChanged: {
                    if (index >= 0) {
                        var delta = mouse.y - y0
                        effectPanels[index].y += delta
                        y0 = mouse.y
                        if (delta > 0)
                            swap12(mouse.y)
                        else
                            swap21(mouse.y)
                    }
                }

                onReleased: {
                    if (index >= 0) {
                        effectPanels[index].z = 2
                        adjustEffectPanels()
                        index = -1
                    }
                }

                function swap12(y) {
                    if ((index + 1 < effectPanels.length) && (y > effectPanels[index + 1].y + effectPanels[index + 1].height)) {
                        moveEffectDown(index)
                        index++
                    }
                }
                function swap21(y) {
                    if ((index > 0) && (y < effectPanels[index - 1].y)) {
                        moveEffectUp(index)
                        index--
                    }
                }
            }
        }
    }

    Rectangle {
        id: handle
        width: 7
        height: parent.height
        anchors.top: parent.top
        anchors.left: parent.right
        anchors.bottom: parent.bottom
        color: "lightsteelblue"
        opacity: 0.8

        MouseArea {
            id: handleMouseArea
            anchors.fill: parent
            onPositionChanged: {
                if (leftAnchored) {
                    controls.width += mouse.x
                } else {
                    controls.width -= mouse.x
                }
                adjustEffectPanels()
            }
        }
    }

    Rectangle {
        id: countDownLayer
        anchors.fill: parent
        color: "#55000000"
        visible: false
        z: 3

        Text {
            id: countDownText
            text: qsTr("3")
            anchors.fill: parent
            color: "white"
            font.pointSize: 10 * fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Connections {
            target: grabWindow
            function onCountDown(time) {
                countDownText.text = time
                countDownLayer.visible = true
            }
            function onCountDownEnded() {
                countDownText.text = "0"
                countDownLayer.visible = false
            }
        }
    }
}
