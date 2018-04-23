import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.4

Item {
    signal sigDay(var value)
    signal sigMonth(var value)
    signal sigYear(var value)

    MyData { id: myData }

    Calendar {
        id: calendar
        x: 120 //position X
        y: 100 //position Y

        style: CalendarStyle {
            gridVisible: false
            gridColor: "transparent"

            background: Rectangle {
                implicitWidth: 260
                implicitHeight: 260
                color: "transparent"
            }

            navigationBar: Rectangle {
                Rectangle {
                    width: parent.width
                    height: 1
                    color: Qt.rgba(1, 1, 1, 0.3)
                }

                ToolButton {
                    id: prevMonth
                    x: 5; y: 269;
                    width: 80; height: 20;
                    text: "<- prev"
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 40
                            implicitHeight: 20
                            border.color: Qt.rgba(0, 0, 0, 0.2)
                            color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                            radius: 3
                        }
                    }
                    onClicked: control.showPreviousMonth()

                    ToolTip.visible: hovered
                    ToolTip.text: "Предыдущий месяц"
                }

                ToolButton {
                    id: nextMonth
                    x: 190; y: 269;
                    width: 80; height: 20;
                    text: "next ->"
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 40
                            implicitHeight: 20
                            border.color: Qt.rgba(0, 0, 0, 0.2)
                            color: control.pressed ? Qt.rgba(1, 1, 1, 0.5) : Qt.rgba(1, 1, 1, 0.3)
                            radius: 3
                        }
                    }
                    onClicked: control.showNextMonth()

                    ToolTip.visible: hovered
                    ToolTip.text: "Следующий месяц"
                }

                Label {
                    id: dateText
                    Text {
                        text: styleData.title
                        font.family: "Helvetica"
                        font.pointSize: 20
                        color: Qt.rgba(1, 1, 1, 0.4)
                    }
                    x: -10
                    y: -85
                }
            }

            dayOfWeekDelegate: Rectangle {
                width: parent.width
                height: 1
                color: "transparent"
                Text {
                    text: Qt.locale().dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                    font.pixelSize: 18
                    color: Qt.rgba(1, 1, 1, 0.4)
                }
                x: 8
                y: -25
            }

            dayDelegate: Rectangle {
                anchors.fill: parent
                anchors.leftMargin: (!addExtraMargin || control.weekNumbersVisible) && styleData.index % CalendarUtils.daysInAWeek === 0 ? 0 : -1
                anchors.rightMargin: !addExtraMargin && styleData.index % CalendarUtils.daysInAWeek === CalendarUtils.daysInAWeek - 1 ? 0 : -1
                anchors.bottomMargin: !addExtraMargin && styleData.index >= CalendarUtils.daysInAWeek * (CalendarUtils.weeksOnACalendarMonth - 1) ? 0 : -1
                anchors.topMargin: styleData.selected ? -1 : 0
                color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"

                border.color: styleData.date !== undefined && styleData.selected ? selectedDateColorBorder : "transparent"
                radius: 3

                readonly property bool addExtraMargin: control.frameVisible && styleData.selected
                readonly property color sameMonthDateTextColor: "#444"
                readonly property color selectedDateColor: Qt.rgba(1, 1, 1, 0.2)
                readonly property color selectedDateColorBorder: Qt.rgba(0, 0, 0, 0.2)
                readonly property color selectedDateTextColor: "black"
                readonly property color differentMonthDateTextColor: "#bbb"
                readonly property color invalidDateColor: "#dddddd"

                Label {
                    id: dayDelegateText
                    text: styleData.date.getDate()
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignRight
                    font.family: "Helvetica"
                    font.pixelSize: {
                        var pixelSize;
                        for (var i=0, indxSat=Locale.Saturday-1, indSun=Locale.Sunday-1; i<7; indxSat+=7, indSun+=7) {
                            if (styleData.index === indxSat || styleData.index === indSun) {
                                pixelSize = 15;
                                break;
                            }
                            pixelSize = 12;
                            ++i;
                        }
                        pixelSize;
                    }

                    color: {
                        var dayColor = invalidDateColor;
                        if (styleData.valid) {
                            dayColor = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                            if (styleData.selected)
                                dayColor = selectedDateTextColor;
                        }
                        dayColor;
                    }
                }
            }

            property Component panel: Item {
                id: panelItem

                implicitWidth: backgroundLoader.implicitWidth
                implicitHeight: backgroundLoader.implicitHeight

                property alias navigationBarItem: navigationBarLoader.item

                property alias dayOfWeekHeaderRow: dayOfWeekHeaderRow

                readonly property int weeksToShow: 6
                readonly property int rows: weeksToShow
                readonly property int columns: CalendarUtils.daysInAWeek

                // The combined available width and height to be shared amongst each cell.
                readonly property real availableWidth: viewContainer.width
                readonly property real availableHeight: viewContainer.height

                property int hoveredCellIndex: -1
                property int pressedCellIndex: -1
                property int pressCellIndex: -1

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: gridColor
                    visible: control.frameVisible
                }

                Item {
                    id: container
                    anchors.fill: parent
                    anchors.margins: control.frameVisible ? 1 : 0

                    Loader {
                        id: backgroundLoader
                        anchors.fill: parent
                        sourceComponent: background
                    }

                    Loader {
                        id: navigationBarLoader
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        sourceComponent: navigationBar
                        active: control.navigationBarVisible

                        property QtObject styleData: QtObject {
                            readonly property string title: control.__locale.standaloneMonthName(control.visibleMonth)
                                + new Date(control.visibleYear, control.visibleMonth, 1).toLocaleDateString(control.__locale, " yyyy")
                        }
                    }

                    Row {
                        id: dayOfWeekHeaderRow
                        anchors.top: navigationBarLoader.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: (control.weekNumbersVisible ? weekNumbersItem.width : 0)
                        anchors.right: parent.right
                        spacing: gridVisible ? __gridLineWidth : 0

                        Repeater {
                            id: repeater
                            model: CalendarHeaderModel {
                                locale: control.__locale
                            }
                            Loader {
                                id: dayOfWeekDelegateLoader
                                sourceComponent: dayOfWeekDelegate
                                width: __cellRectAt(index).width

                                readonly property int __index: index
                                readonly property var __dayOfWeek: dayOfWeek

                                property QtObject styleData: QtObject {
                                    readonly property alias index: dayOfWeekDelegateLoader.__index
                                    readonly property alias dayOfWeek: dayOfWeekDelegateLoader.__dayOfWeek
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: topGridLine
                        color: __horizontalSeparatorColor
                        width: parent.width
                        height: __gridLineWidth
                        visible: gridVisible
                        anchors.top: dayOfWeekHeaderRow.bottom
                    }

                    Row {
                        id: gridRow
                        width: weekNumbersItem.width + viewContainer.width
                        height: viewContainer.height
                        anchors.top: topGridLine.bottom

                        Column {
                            id: weekNumbersItem
                            visible: control.weekNumbersVisible
                            height: viewContainer.height
                            spacing: gridVisible ? __gridLineWidth : 0
                            Repeater {
                                id: weekNumberRepeater
                                model: panelItem.weeksToShow

                                Loader {
                                    id: weekNumberDelegateLoader
                                    height: __cellRectAt(index * panelItem.columns).height
                                    sourceComponent: weekNumberDelegate

                                    readonly property int __index: index
                                    property int __weekNumber: control.__model.weekNumberAt(index)

                                    Connections {
                                        target: control
                                        onVisibleMonthChanged: __weekNumber = control.__model.weekNumberAt(index)
                                        onVisibleYearChanged: __weekNumber = control.__model.weekNumberAt(index)
                                    }

                                    Connections {
                                        target: control.__model
                                        onCountChanged: __weekNumber = control.__model.weekNumberAt(index)
                                    }

                                    property QtObject styleData: QtObject {
                                        readonly property alias index: weekNumberDelegateLoader.__index
                                        readonly property int weekNumber: weekNumberDelegateLoader.__weekNumber
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: separator
                            anchors.topMargin: - dayOfWeekHeaderRow.height - 1
                            anchors.top: weekNumbersItem.top
                            anchors.bottom: weekNumbersItem.bottom

                            width: __gridLineWidth
                            color: __verticalSeparatorColor
                            visible: control.weekNumbersVisible
                        }

                        // Contains the grid lines and the grid itself.
                        Item {
                            id: viewContainer
                            width: container.width - (control.weekNumbersVisible ? weekNumbersItem.width + separator.width : 0)
                            height: container.height - navigationBarLoader.height - dayOfWeekHeaderRow.height - topGridLine.height

                            Repeater {
                                id: verticalGridLineRepeater
                                model: panelItem.columns - 1
                                delegate: Rectangle {
                                    x: __cellRectAt(index + 1).x - __gridLineWidth
                                    y: 0
                                    width: __gridLineWidth
                                    height: viewContainer.height
                                    color: gridColor
                                    visible: gridVisible
                                }
                            }

                            Repeater {
                                id: horizontalGridLineRepeater
                                model: panelItem.rows - 1
                                delegate: Rectangle {
                                    x: 0
                                    y: __cellRectAt((index + 1) * panelItem.columns).y - __gridLineWidth
                                    width: viewContainer.width
                                    height: __gridLineWidth
                                    color: gridColor
                                    visible: gridVisible
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent

                                hoverEnabled: Settings.hoverEnabled

                                function cellIndexAt(mouseX, mouseY) {
                                    var viewContainerPos = viewContainer.mapFromItem(mouseArea, mouseX, mouseY);
                                    var child = viewContainer.childAt(viewContainerPos.x, viewContainerPos.y);
                                    // In the tests, the mouseArea sometimes gets picked instead of the cells,
                                    // probably because stuff is still loading. To be safe, we check for that here.
                                    return child && child !== mouseArea ? child.__index : -1;
                                }

                                onEntered: {
                                    hoveredCellIndex = cellIndexAt(mouseX, mouseY);
                                    if (hoveredCellIndex === undefined) {
                                        hoveredCellIndex = cellIndexAt(mouseX, mouseY);
                                    }

                                    var date = view.model.dateAt(hoveredCellIndex);
                                    if (__isValidDate(date)) {
                                        control.hovered(date);
                                    }
                                }

                                onExited: {
                                    hoveredCellIndex = -1;
                                }

                                onPositionChanged: {
                                    var indexOfCell = cellIndexAt(mouse.x, mouse.y);
                                    var previousHoveredCellIndex = hoveredCellIndex;
                                    hoveredCellIndex = indexOfCell;
                                    if (indexOfCell !== -1) {
                                        var date = view.model.dateAt(indexOfCell);
                                        if (__isValidDate(date)) {
                                            if (hoveredCellIndex !== previousHoveredCellIndex)
                                                control.hovered(date);

                                            // The date must be different for the pressed signal to be emitted.
                                            if (pressed && date.getTime() !== control.selectedDate.getTime()) {
                                                control.pressed(date);

                                                // You can't select dates in a different month while dragging.
                                                if (date.getMonth() === control.selectedDate.getMonth()) {
                                                    control.selectedDate = date;
                                                    pressedCellIndex = indexOfCell;
                                                }
                                            }
                                        }
                                    }
                                }

                                onPressed: {
                                    pressCellIndex = cellIndexAt(mouse.x, mouse.y);
                                    if (pressCellIndex !== -1) {
                                        var date = view.model.dateAt(pressCellIndex);
                                        pressedCellIndex = pressCellIndex;
                                        if (__isValidDate(date)) {
                                            control.selectedDate = date;
                                            control.pressed(date);
                                        }
                                    }
                                }

                                onReleased: {
                                    var indexOfCell = cellIndexAt(mouse.x, mouse.y);
                                    if (indexOfCell !== -1) {
                                        // The cell index might be valid, but the date has to be too. We could let the
                                        // selected date validation take care of this, but then the selected date would
                                        // change to the earliest day if a day before the minimum date is clicked, for example.
                                        var date = view.model.dateAt(indexOfCell);
                                        if (__isValidDate(date)) {
                                            control.released(date);
                                        }
                                    }
                                    pressedCellIndex = -1;
                                }

                                onClicked: {
                                    var indexOfCell = cellIndexAt(mouse.x, mouse.y);
                                    if (indexOfCell !== -1 && indexOfCell === pressCellIndex) {
                                        var date = view.model.dateAt(indexOfCell);
                                        if (__isValidDate(date))
                                            control.clicked(date);
                                    }
                                    panelItem.takeDdMmYy();
                                }

                                onDoubleClicked: {
                                    var indexOfCell = cellIndexAt(mouse.x, mouse.y);
                                    if (indexOfCell !== -1) {
                                        var date = view.model.dateAt(indexOfCell);
                                        if (__isValidDate(date))
                                            control.doubleClicked(date);
                                    }
                                }

                                onPressAndHold: {
                                    var indexOfCell = cellIndexAt(mouse.x, mouse.y);
                                    if (indexOfCell !== -1 && indexOfCell === pressCellIndex) {
                                        var date = view.model.dateAt(indexOfCell);
                                        if (__isValidDate(date))
                                            control.pressAndHold(date);
                                    }
                                }
                            }

                            Connections {
                                target: control
                                onSelectedDateChanged: view.selectedDateChanged()
                            }

                            Repeater {
                                id: view

                                property int currentIndex: -1

                                model: control.__model

                                Component.onCompleted: selectedDateChanged()

                                function selectedDateChanged() {
                                    if (model !== undefined && model.locale !== undefined) {
                                        currentIndex = model.indexAt(control.selectedDate);
                                    }
                                }

                                delegate: Loader {
                                    id: delegateLoader

                                    x: __cellRectAt(index).x
                                    y: __cellRectAt(index).y
                                    width: __cellRectAt(index).width
                                    height: __cellRectAt(index).height
                                    sourceComponent: dayDelegate

                                    readonly property int __index: index
                                    readonly property date __date: date
                                    // We rely on the fact that an invalid QDate will be converted to a Date
                                    // whose year is -4713, which is always an invalid date since our
                                    // earliest minimum date is the year 1.
                                    readonly property bool valid: __isValidDate(date)

                                    property QtObject styleData: QtObject {
                                        readonly property alias index: delegateLoader.__index
                                        readonly property bool selected: control.selectedDate.getTime() === date.getTime()
                                        readonly property alias date: delegateLoader.__date
                                        readonly property bool valid: delegateLoader.valid
                                        // TODO: this will not be correct if the app is running when a new day begins.
                                        readonly property bool today: date.getTime() === new Date().setHours(0, 0, 0, 0)
                                        readonly property bool visibleMonth: date.getMonth() === control.visibleMonth
                                        readonly property bool hovered: panelItem.hoveredCellIndex == index
                                        readonly property bool pressed: panelItem.pressedCellIndex == index
                                        // todo: pressed property here, clicked and doubleClicked in the control itself
                                    }
                                }
                            }
                        }
                    }
                }

                function takeDdMmYy() {                  
                    //console.log(control.selectedDate.getDate());
                    myData.dateDay = control.selectedDate.getDate();
                    sigDay(myData.dateDay);

                    //console.log(control.visibleMonth);
                    myData.dateMonth = control.visibleMonth + 1;
                    sigMonth(myData.dateMonth);

                    //console.log(control.visibleYear);
                    myData.dateYear = control.visibleYear;
                    sigYear(myData.dateYear);
                }

                Timer {
                    interval: 1000; running: true; repeat: false
                    onTriggered: panelItem.takeDdMmYy();
                }
            }
        }
    }
}
