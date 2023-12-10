import QtQuick 2.15

Rectangle {
    id: root
    layer.enabled: true
    smooth: true

    property alias effect: seed

    ShaderEffectSource {
        id: theSource
        smooth: root.smooth
        hideSource: true
        recursive: false
        live: true
    }

    ShaderEffectSource {
        id: theFeedbackSource
        smooth: root.smooth
        hideSource: false
        recursive: false
        live: false
    }

    ShaderEffectSource {
        id: theMemorySource
        smooth: root.smooth
        hideSource: false
        recursive: true
        live: false
        sourceItem: memory
    }

    EffectMemory {
        id: memory
        anchors.fill: parent
        targetWidth: parent.width
        targetHeight: parent.height
        feedbackSource: theFeedbackSource
        memorySource: theMemorySource
        memory: seed.memory
    }

    EffectSeed {
        id: seed
        anchors.fill: parent
        targetWidth: parent.width
        targetHeight: parent.height
        source: theSource
        memorySource: theMemorySource
        feedback: false
    }

    function updateSource(source) {
        theSource.sourceItem = source
    }

    function updateFeedbackSource(source) {
        theFeedbackSource.sourceItem = source
        if (!source) {
            seed.feedback = false
        }
    }

    function paintFeedbackSource() {
        if (!seed.feedback) {
            seed.feedback = true
        }
        theFeedbackSource.scheduleUpdate()
        theMemorySource.scheduleUpdate()
    }
}
