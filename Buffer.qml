import QtQuick 1.1
Image {
    CountdownSlide {}
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    source: slideFiles[Math.min(slideFiles.length, Math.max(0, frame))]
    property int frame: -1
    fillMode: Image.PreserveAspectFit
    Text {
        font.pointSize: 72
        text: "buffer"
        color: "red"
        anchors.centerIn: parent
        visible: root.debug
    }

    function flash() {
        flashAnim.start()
    }

    Rectangle {
        id: flash
        color: "white"
        opacity: 0
        anchors.fill: parent
    }

    ParallelAnimation {
        id: flashAnim
        NumberAnimation {
            property: "x"
            target: parent.parent
            duration: 150
            to: deck.x
            from: deck.x-deck.width/10
            easing.type: Easing.OutElastic
        }
        SequentialAnimation {
            NumberAnimation {
                property:"opacity"
                target: flash
                from: 0
                to: 1
                duration: 50
            }
            NumberAnimation {
                property:"opacity"
                target: flash
                from: 1
                to: 0
                duration: 100
            }
        }
    }
}
