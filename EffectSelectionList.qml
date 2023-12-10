import QtQuick 2.15

ListModel {
    id: effectList
    ListElement { name: "Identity"; source: "Effect.qml" }
    ListElement { name: "Black and White"; source: "EffectBlackAndWhite.qml" }
    ListElement { name: "Brightness"; source: "EffectBrightness.qml" }
    ListElement { name: "Channel Mix"; source: "EffectChannelMix.qml" }
    ListElement { name: "Contrast"; source: "EffectContrast.qml" }
    ListElement { name: "Convolution"; source: "EffectConvolution.qml" }
    ListElement { name: "Dilation"; source: "EffectDilation.qml" }
    ListElement { name: "Erosion"; source: "EffectErosion.qml" }
    ListElement { name: "Gamma"; source: "EffectGamma.qml" }
    ListElement { name: "Grayscale"; source: "EffectGrayscale.qml" }
    ListElement { name: "Hue Shift"; source: "EffectHueShift.qml" }
    ListElement { name: "Invert"; source: "EffectInvert.qml" }
    ListElement { name: "Isolate"; source: "EffectIsolate.qml" }
    ListElement { name: "Mask"; source: "EffectMask.qml" }
    ListElement { name: "Morphogradient"; source: "EffectMorphogradient.qml" }
    ListElement { name: "Pixelate"; source: "EffectPixelate.qml" }
    ListElement { name: "Posterize"; source: "EffectPosterize.qml" }
    ListElement { name: "RGB Quantization"; source: "EffectRGBQuantization.qml" }
    ListElement { name: "Rotation"; source: "EffectRotation.qml" }
    ListElement { name: "Saturation"; source: "EffectSaturation.qml" }
    ListElement { name: "Scale"; source: "EffectScale.qml" }
}
