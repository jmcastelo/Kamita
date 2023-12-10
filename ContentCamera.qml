import QtQuick 2.15
import QtMultimedia 5.15

VideoOutput {
    id: video
    source: camera

    property alias camera: camera

    Camera {
        id: camera
    }
}
