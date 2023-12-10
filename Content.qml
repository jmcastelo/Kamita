import QtQuick 2.15

Rectangle {
    id: root
    layer.enabled: true
    smooth: true

    property alias effect: effectLoader.item
    property string effectSource
    property bool enabled: true

    signal sourcePainted()

    ShaderEffectSource {
        id: theSource
        smooth: root.smooth
        hideSource: false
        recursive: false
        live: false
        onSourceItemChanged: if (sourceItem) scheduleUpdate()
        onScheduledUpdateCompleted: {
            if (sourceItem) {
                root.sourcePainted()
                scheduleUpdate()
            }
        }
    }

    Loader {
        id: effectLoader
        source: effectSource
    }

    onWidthChanged: {
        if (effectLoader.item)
            effectLoader.item.targetWidth = root.width
    }

    onHeightChanged: {
        if (effectLoader.item)
            effectLoader.item.targetHeight = root.height
    }

    onEffectSourceChanged: {
        effectLoader.source = effectSource
        effectLoader.item.parent = root
        effectLoader.item.targetWidth = root.width
        effectLoader.item.targetHeight = root.height
        effectLoader.item.source = theSource
        effectLoader.item.anchors.fill = root
    }

    function init() {
        root.effectSource = "Effect.qml"
    }

    function updateSource(source) {
        theSource.sourceItem = source
    }
}
