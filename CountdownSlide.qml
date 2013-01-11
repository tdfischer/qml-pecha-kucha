import QtQuick 1.1

Rectangle {
    anchors.fill: parent
    width: root.width
    height: parent.height
    visible: parent.frame == -1
    color: "white"
    Text {
        y: txt.y+txt.height-txt.paintedHeight
        x: parent.x+parent.width/16*1
        font.pointSize: 24
        text: "Starting in..."
    }
    Text {
        id: txt
        font.pointSize: 128
        text: deck.time/1000
        x: parent.x+parent.width/8
        anchors.verticalCenter: parent.verticalCenter
    }
}
