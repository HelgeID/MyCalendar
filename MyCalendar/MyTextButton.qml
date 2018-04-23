import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Item {
    property bool active_wide_area: false

    property bool saveBtnVisible: true
    property bool cleanBtnVisible: true
    property bool deleteBtnVisible: false

    signal sigDelete()

    signal sigSave()
    signal sigClean()

    signal sigCopy()
    signal sigCut()
    signal sigPaste()
    signal sigRemove()

    signal sigUndo()
    signal sigRedo()


    Rectangle {
        id: root_rec

        Rectangle {
            id: area_second1
            color: "transparent"
            border.color: Qt.rgba(1, 1, 1, 0.2)
            border.width: 2
            radius: 2
            x: myProperty.as1_x; y: myProperty.as1_y;
            implicitWidth: myProperty.as1_width;
            implicitHeight: myProperty.as1_height;
            visible: true;
        }

        Rectangle {
            id: area_second2
            color: "transparent"
            border.color: Qt.rgba(1, 1, 1, 0.2)
            border.width: 2
            radius: 2
            x: myProperty.as2_x; y: myProperty.as2_y;
            implicitWidth: myProperty.as2_width;
            implicitHeight: myProperty.as2_height;
            visible: false;
        }

        ToolButton {
            id: extensionBtn
            x: 434; y: 370;
            width: 40; height: 20;
            text: "<<"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: {
                //Off Calendar
                if (myCalendar.visible !== false)
                    myCalendar.visible = false;
                //Off Notes
                else if (myNotes.visible !== false)
                    myNotes.visible = false;

                mySeqAnim.start();
            }

            ToolTip.visible: hovered
            ToolTip.text: "Раскрыть/Скрыть поле ввода"
        }

        ToolButton {
            id: deleteBtn
            x: 485; y: 370;
            width: 91; height: 20;
            text: "delete"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigDelete(); }
            visible: deleteBtnVisible ? true : false

            ToolTip.visible: hovered
            ToolTip.text: "Удалить запись"
        }

        ToolButton {
            id: cleanBtn
            x: 485; y: 370;
            width: 40; height: 20;
            text: "clean"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigClean(); }
            visible: cleanBtnVisible ? true : false

            ToolTip.visible: hovered
            ToolTip.text: "Очистить поле ввода"
        }

        ToolButton {
            id: saveBtn
            x: 536; y: 370;
            width: 40; height: 20;
            text: "save"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigSave(); }
            visible: saveBtnVisible ? true : false

            ToolTip.visible: hovered
            ToolTip.text: "Сохранить запись"
        }

        ToolButton {
            id: copyBtn
            x: 307; y: 370;
            width: 40; height: 20;
            text: "copy"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigCopy(); }
            visible: false

            ToolTip.visible: hovered
            ToolTip.text: "Скопировать текст"
        }

        ToolButton {
            id: cutBtn
            x: 358; y: 370;
            width: 40; height: 20;
            text: "cut"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigCut(); }
            visible: false

            ToolTip.visible: hovered
            ToolTip.text: "Вырезать текст"
        }

        ToolButton {
            id: pasteBtn
            x: 409; y: 370;
            width: 40; height: 20;
            text: "paste"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigPaste(); }
            visible: false

            ToolTip.visible: hovered
            ToolTip.text: "Вставить текст"
        }

        ToolButton {
            id: removeBtn
            x: 460; y: 370;
            width: 40; height: 20;
            text: "remove"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigRemove(); }
            visible: false

            ToolTip.visible: hovered
            ToolTip.text: "Удалить текст"
        }

        ToolButton {
            id: undoBtn
            x: 531; y: 370;
            width: 20; height: 20;
            text: "<"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigUndo(); }
            visible: false

            ToolTip.visible: hovered
            ToolTip.text: "<- Назад"
        }

        ToolButton {
            id: redoBtn
            x: 562; y: 370;
            width: 20; height: 20;
            text: ">"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    border.color: Qt.rgba(0, 0, 0, 0.2)
                    color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                    radius: 3
                }
            }
            onClicked: { sigRedo(); }
            visible: false

            ToolTip.visible: hovered
            ToolTip.text: "Вперед ->"
        }

        function data_processing_when_Started() {
            area_second1.visible = false;
            area_second2.visible = false;

            /* processing BTNS */
            extensionBtn.enabled = false;
            cleanBtnVisible = false;
            saveBtnVisible = false;
            deleteBtnVisible = false;

            copyBtn.visible = cutBtn.visible = pasteBtn.visible = removeBtn.visible = false;
            undoBtn.visible = redoBtn.visible = false;
        }

        function data_processing_when_Stopped() {
            if (pathAnim.path !== myPathAnim_in) {
                area_second2.visible = true;
                extensionBtn.text = ">>";
                cleanBtn.x = 185;
                saveBtn.x = 236;
                myProperty.prop_text_x = 130;
                myProperty.prop_text_width = 460;

                active_wide_area = true;

                copyBtn.visible = cutBtn.visible = pasteBtn.visible = removeBtn.visible = true;
                undoBtn.visible = redoBtn.visible = true;
            }
            else {
                area_second1.visible = true;
                extensionBtn.text = "<<";
                cleanBtn.x = 485;
                saveBtn.x = 536;
                myProperty.prop_text_x = 420;
                myProperty.prop_text_width = 170;

                active_wide_area = false;

                //On Calendar
                if (myCalendar.visible === false)
                    myCalendar.visible = true;

                copyBtn.visible = cutBtn.visible = pasteBtn.visible = removeBtn.visible = false;
                undoBtn.visible = redoBtn.visible = false;
            }

            /* processing BTNS */
            extensionBtn.enabled = true;
            cleanBtnVisible = true;
            saveBtnVisible = true;
        }

        SequentialAnimation {
            id: mySeqAnim

            PathAnimation {
                id: pathAnim
                duration: 1000
                path: myPathAnim_in
                target: extensionBtn
                anchorPoint: Qt.point(extensionBtn.width-40, extensionBtn.height-20)
                easing.type: Easing.InQuad
            }

            onStarted: {
                root_rec.data_processing_when_Started();
            }

            onStopped: {
                pathAnim.path !== myPathAnim_out ? pathAnim.path = myPathAnim_out : pathAnim.path = myPathAnim_in;
                root_rec.data_processing_when_Stopped();
            }
        }

        Path {startX:434; startY:370; PathLine {x:134; y:370;} id: myPathAnim_in;}
        Path {startX:134; startY:370; PathLine {x:434; y:370;} id: myPathAnim_out;}
    }
}
