import QtQuick 2.5

Item {
    Image {
        source: "qrc:/background/img/background.png"
    }

    Canvas {
        width: 600; height: 400;
        onPaint: {
            var area_main = getContext("2d")
            area_main.lineWidth = 1
            area_main.strokeStyle = Qt.rgba(1, 1, 1, 0.4)
            area_main.beginPath()
            area_main.moveTo(myProperty.am_x_point0, myProperty.am_y_point0)
            area_main.lineTo(myProperty.am_x_point1, myProperty.am_y_point1)
            area_main.lineTo(myProperty.am_x_point2, myProperty.am_y_point2)
            area_main.lineTo(myProperty.am_x_point3, myProperty.am_y_point3)
            area_main.closePath()
            area_main.stroke()
        }
    }
}
