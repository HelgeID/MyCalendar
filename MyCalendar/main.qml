import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

Window {
    id: root
    visible: true
    title: qsTr("MyCalendar")
    width: 600; height: 400;
    //flags: Qt.FramelessWindowHint
    flags: Qt.Window
           |Qt.WindowMinimizeButtonHint
           |Qt.WindowMaximizeButtonHint
           |Qt.WindowCloseButtonHint
           |Qt.CustomizeWindowHint

    maximumHeight: height; maximumWidth: width
    minimumHeight: height; minimumWidth: width

    MyData { id: myData }

    property int previousX
    property int previousY

    Rectangle {
        anchors.fill: parent

        MouseArea {
            id: topArea
            height: 5
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            cursorShape: Qt.SizeVerCursor

            onPressed: {
                previousY = mouseY //remember the Y position
            }

            onMouseYChanged: {
                var dy = mouseY - previousY
                root.setY(root.y + dy)
                root.setHeight(root.height - dy)
            }
        }

        MouseArea {
            id: bottomArea
            height: 5
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            cursorShape: Qt.SizeVerCursor

            onPressed: {
                previousY = mouseY //remember the Y position
            }

            onMouseYChanged: {
                var dy = mouseY - previousY
                root.setHeight(root.height + dy)
            }
        }

        MouseArea {
            id: leftArea
            width: 5
            anchors {
                top: topArea.bottom
                bottom: bottomArea.top
                left: parent.left
            }
            cursorShape: Qt.SizeHorCursor

            onPressed: {
                previousX = mouseX //remember the X position
            }

            onMouseXChanged: {
                var dx = mouseX - previousX
                root.setX(root.x + dx)
                root.setWidth(root.width - dx)
            }
        }

        MouseArea {
            id: rightArea
            width: 5
            anchors {
                top: topArea.bottom
                bottom: bottomArea.top
                right: parent.right
            }
            cursorShape:  Qt.SizeHorCursor

            onPressed: {
                previousX = mouseX //remember the X position
            }

            onMouseXChanged: {
                var dx = mouseX - previousX
                root.setWidth(root.width + dx)
            }
        }

        MouseArea {
            anchors {
                top: topArea.bottom
                bottom: bottomArea.top
                left: leftArea.right
                right: rightArea.left
            }

            onPressed: {
                previousX = mouseX //remember the X position
                previousY = mouseY //remember the Y position
            }

            onMouseXChanged: {
                var dx = mouseX - previousX
                root.setX(root.x + dx)
            }

            onMouseYChanged: {
                var dy = mouseY - previousY
                root.setY(root.y + dy)
            }
        }
    }

    Rectangle {
        id: mainRect

        //Include property
        MyProperty { id: myProperty }

        InfoText { id: infoText }

        //MySaveTimer
        Timer {
            id: mySaveTimer
            interval: 750; running: false; repeat: false
            onTriggered: {
                myData.addNote(infoText.text);
            }
        }

        //MyBackground
        Loader {
            anchors.fill: parent
            source: "MyBackground.qml"
        }

        //MyCalendar
        Loader {
            id: myCalendar
            anchors.fill: parent
            source: "MyCalendar.qml"
        }
        Connections {
            target: myCalendar.item
            onSigDay: { myData.dateDay = value }
            onSigMonth: { myData.dateMonth = value }
            onSigYear: { myData.dateYear = value }
        }

        //MyNotes
        Loader {
            id: myNotes
            source: "MyNotes.qml"
            focus: true
            x: 110; y: 5;
            visible: false
        }

        //MyText
        Loader {
            id: myText
            source: "MyText.qml"
            //focus: true
            x: myProperty.prop_text_x
            y: myProperty.prop_text_y
        }

        //MyTextButton
        Loader {
            id: myTextButton
            source: "MyTextButton.qml"
            readonly property MyTextButton mTB: item
        }
        Connections {
            target: myTextButton.item
            onSigSave: mySaveTimer.start()
        }

        //Button Calendar
        ToolButton {
            id: calendarButton
            x: 15; y: 60;
            width: 70; height: 70;
            Image {
                anchors.centerIn: parent
                smooth: true
                sourceSize.width: 64; sourceSize.height: 64;
                source: "qrc:/button/img/calendar.png"
                opacity: 0.4
            }

            onClicked: {
                if (myTextButton.mTB.active_wide_area !== true) {
                    //console.log("calendar enabled");
                    if (myCalendar.visible !== true) {
                        myCalendar.visible = true
                        myNotes.visible = false
                        myTextButton.mTB.cleanBtnVisible = true
                        myTextButton.mTB.saveBtnVisible = true
                        myTextButton.mTB.deleteBtnVisible = false
                    }
                }
            }

            style: ButtonStyle {
                background: Rectangle {
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.08)
                    radius: 5
                }
            }

            //ToolTip.visible: hovered
            //ToolTip.text: "Календарь"
        }

        //Button Field
        ToolButton {
            id: fieldButton
            x: 15; y: 137;
            width: 70; height: 70;
            Image {
                anchors.centerIn: parent
                smooth: true
                sourceSize.width: 64; sourceSize.height: 64;
                source: "qrc:/button/img/field.png"
                opacity: 0.4
            }

            onClicked: {
                if (myTextButton.mTB.active_wide_area !== true) {
                    //console.log("field enabled");
                    if (myNotes.visible !== true) {
                        myNotes.visible = true
                        myCalendar.visible = false
                        myTextButton.mTB.cleanBtnVisible = false
                        myTextButton.mTB.saveBtnVisible = false
                        myTextButton.mTB.deleteBtnVisible = true
                    }
                }
            }

            style: ButtonStyle {
                background: Rectangle {
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.08)
                    radius: 5
                }
            }

            //ToolTip.visible: hovered
            //ToolTip.text: "Заметки"
        }

        //Button Exit
        ToolButton {
            id: exitButton
            x: 15; y: 214;
            width: 70; height: 70;
            Image {
                anchors.centerIn: parent
                smooth: true
                sourceSize.width: 64; sourceSize.height: 64;
                source: "qrc:/button/img/exit.png"
                opacity: 0.4
            }

            onClicked: {
                close()
            }

            style: ButtonStyle {
                background: Rectangle {
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.08)
                    radius: 5
                }
            }

            //ToolTip.visible: hovered
            //ToolTip.text: "Выход из приложения"
        }
    }
}
