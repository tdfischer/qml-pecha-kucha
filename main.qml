import QtQuick 1.0
import QtMultimediaKit 1.1

Rectangle {
    color: "black"
    id: root
    property bool debug: false
    width: 300
    height: 300
    Component.onCompleted: deck.start()


    Item {
        Audio {
            id: slideEffect
            source: "slide.wav"
        }

        Audio {
            id: scrapeEffect
            source: "scrape.wav"
        }

        id: deck
        anchors.fill: parent
        property int slide: -1
        property alias mainSlide: main.frame
        property alias bufferSlide: buffer.frame
        property int duration: 300
        property int speed: 20*1000
        property int time: speed
        
        SequentialAnimation {
            id: timer
            NumberAnimation {
                property: "time"
                from: deck.speed
                target: deck
                to: 0
                duration: deck.speed
            }
            NumberAnimation {
                property: "time"
                to: deck.speed
                duration: 300
            }
            ScriptAction {
                script: deck.next()
            }
        }

        function start() {
            timer.start()
            console.log("Start!")
        }

        property bool _ended: false

        function next() {
            if (slide >= slideFiles.length-1) {
                if (_ended) {
                    main.flash()
                    scrapeEffect.playbackRate = 0.9+(0.2*Math.random())
                    scrapeEffect.play()
                }
                byline.hidden = false
                _ended = true;
                timer.stop()
                deck.time = 0
            } else {
                byline.hidden = true
                slide += 1;
                timer.stop();
                swapAnimation.start();
                slideEffect.playbackRate = 0.9+(0.2*Math.random())
                slideEffect.play()
            }
        }

        SequentialAnimation {
            id: swapAnimation
            ScriptAction {
                script: {
                    buffer.y = deck.y+deck.height
                    deck.bufferSlide = deck.slide
                    buffer.opacity = 0;
                    main.opacity = 1;
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    property: "time"
                    target: deck
                    to: deck.speed
                    duration: deck.duration/2
                    easing.type: Easing.OutExpo
                }
                NumberAnimation {
                    property: "height"
                    target:main
                    to: deck.height/4*3
                    duration: deck.duration/2
                }
                NumberAnimation {
                    property: "height"
                    target:buffer
                    from: deck.height*2
                    to: deck.height
                    duration: deck.duration
                }
                NumberAnimation {
                    property: "opacity"
                    target: main
                    to: 0
                    duration: deck.duration
                }
                NumberAnimation {
                    property: "opacity"
                    target: buffer
                    to: 1
                    duration: deck.duration
                }
                NumberAnimation {
                    property: "y"
                    target: main
                    to: deck.height+deck.y
                    duration: deck.duration
                }
                NumberAnimation {
                    property: "y"
                    target: buffer
                    to: deck.y
                    duration: deck.duration
                }
            }
            ScriptAction {
                script: {
                    deck.mainSlide = deck.slide
                    main.y = deck.y
                    buffer.y = deck.y
                    main.height = deck.height
                    main.opacity = 1;
                    buffer.opacity = 0;
                    deck.bufferSlide += 1;
                    if (deck.slide < slideFiles.length-1)
                        timer.start()
                    deck.time = 0
                }
            }
        }

        Buffer {id: main}
        Buffer {id: buffer;frame: 0;opacity:0}

        MouseArea {
            onClicked: deck.next()
            anchors.fill: parent
        }
    }

    Rectangle {
        id: byline
        color: "black"
        anchors.right: root.right
        anchors.bottom: root.bottom
        width: root.width/8*6
        height: hidden ? 0 : root.height/3
        property bool hidden: false
        Behavior on height {
            NumberAnimation {duration: 400;easing.type:Easing.OutBounce}
        }
        Row {
            anchors.margins: 10
            anchors.right: parent.right
            anchors.top: parent.top
            Text {
                text: author
                color: "white"
                font.pointSize: 102
            }
            Text {
                text: author
                color: "white"
                font.pointSize: 48
            }
        }
    }

    Item {
        opacity: Math.max(1-deck.time/deck.speed, 0.3)
        anchors {
            bottom: root.bottom
            left: root.left
            right: root.right
        }
        height: 40
        Rectangle {
            clip: true
            anchors.margins: 5
            anchors.fill: parent
            radius: 5
            color: (deck.slide == slideFiles.length-1) ? "red" : "black"
            Behavior on color  {
                PropertyAnimation {duration: deck.duration }
            }
            Item {
                anchors.margins: 3
                anchors.fill: parent
                Text {
                    text: (deck.slide+1)+"/"+(slideFiles.length);color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.margins: 3
                height: parent.height
                width: parent.width*(deck.time/deck.speed)
                color: "white"
            }
        }
    }
}
