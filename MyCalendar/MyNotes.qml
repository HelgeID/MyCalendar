import QtQuick 2.5

Item {
    signal sigActive(var text)
    signal sigDelete()

    MyData { id: myData }

    Connections {
        target: myCalendar.item
        onSigDay: { myData.dateDay = value }
        onSigMonth: { myData.dateMonth = value }
        onSigYear: { myData.dateYear = value }
    }

    Connections {
        target: myTextButton.item
        onSigSave: {
            var array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"];
            var dateMonthName;
            for (var i = 12; i != 0; i--)
                if (myData.dateMonth === i)
                    dateMonthName = array[i-1];
            dataModel.append ({
                                  dateDay: myData.dateDay.toString().length > 1 ? myData.dateDay.toString() : '0' + myData.dateDay.toString(),
                                  dateMonthYear: dateMonthName.toString() + "/" + myData.dateYear.toString()
                              });
        }

        onSigDelete: {
            if (dataView.currentIndex === active && active !== -1) {
                dataModel.remove(active)
                myData.delNote(active + 1)
                sigDelete()
                active = -1
            }
        }
    }

    property int active: -1
    width: 300; height: 380;
    ListModel {
        id: dataModel

        Component.onCompleted: {
            var counter = myData.takeCounter();
            //console.log(counter);
            for (var i = 1; i <= counter; i++)
                dataModel.append ({
                                      dateDay: myData.getNoteDateDay(i),
                                      dateMonthYear: myData.getNoteDateMonthYear(i)
                                  });
        }
    }

    Component {
        id: dataDelegate
        Item {
            width: dataView.cellWidth; height: dataView.cellHeight
            Column {
                Image {
                    source: "note/img/note.png"; anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        text: dateDay; anchors.right: parent.right
                        color: model.index === active ? "black" : Qt.rgba(1.0, 1.0, 1.0, 0.8)
                        font.family: "Ubuntu"
                        font.pixelSize: 16
                    }
                    //opacity: 0.4
                }
                Text {
                    text: dateMonthYear; anchors.horizontalCenter: parent.horizontalCenter
                    color: model.index === active ? "black" : Qt.rgba(1.0, 1.0, 1.0, 0.8)
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mouse.button === Qt.LeftButton) {
                        dataView.currentIndex = model.index
                        forceActiveFocus()
                    }
                }
                onDoubleClicked: {
                    active = dataView.currentIndex
                    sigActive(myData.getNote(active + 1))
                    forceActiveFocus()
                }
            }
        }
    }

    Component {
        id: dataHighlight
        Rectangle {
            width: dataView.cellWidth; height: dataView.cellHeight
            color: Qt.rgba(1, 1, 1, 0.2); radius: 5
            x: dataView.currentItem.x
            y: dataView.currentItem.y
            Behavior on x { SpringAnimation { spring: 2; damping: 0.1 } }
            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
        }
    }

    GridView {
        id: dataView
        anchors.fill: parent
        cellWidth: 60; cellHeight: 80

        model: dataModel
        delegate: dataDelegate
        highlight: dataHighlight

        Keys.onPressed: {
            if (event.key === Qt.Key_Return && myNotes.visible === true)
                pressEnter()
            else if (event.key === Qt.Key_R && myNotes.visible === true)
                pressR()
        }

        function pressEnter() {
            //console.log("Enter key pressed");
            active = dataView.currentIndex;
            sigActive(myData.getNote(active + 1));
        }
        function pressR() {
            //console.log("R key pressed");
            active = -1;
            sigActive("");
        }

        focus: true
    }
}
