import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    MyData { id: myData }

    Connections {
        target: myNotes.item
        onSigActive:    { textInput.text = text }
        onSigDelete:    { textInput.text = "" }
    }

    Connections {
        target: myTextButton.item
        onSigSave:      { infoText.text = textInput.text }
        onSigClean:     { textInput.text = "" }
        onSigCopy:      { textInput.copy() }
        onSigCut:       { textInput.cut() }
        onSigPaste:     { textInput.paste() }
        onSigRemove:    { textInput.remove(textInput.selectionStart, textInput.selectionEnd) }
        onSigUndo:      { textInput.undo() }
        onSigRedo:      { textInput.redo() }
    }

    TextArea {
        id: textInput
        x: 0; y: 10;
        width: myProperty.prop_text_width
        height: myProperty.prop_text_height
        text: {
            infoText.text
        }
        frameVisible: false
        textColor: "black"

        style: TextAreaStyle {
            backgroundColor: Qt.rgba(1, 1, 1, 0.1)
            selectionColor: Qt.rgba(1, 1, 1, 0.3)

            handle: Rectangle {
                implicitWidth: 24
                implicitHeight: 14
                border.color: Qt.rgba(1, 1, 1, 0.5)
                color: styleData.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                radius: 3
            }

            scrollBarBackground: Rectangle  {
                implicitWidth: 24
                implicitHeight: 14
                color: "transparent"
            }

            incrementControl: null
            decrementControl: null
        }
    }
}
