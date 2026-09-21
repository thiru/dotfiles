import QtQuick
import QtQuick.Controls
import Quickshell

PopupWindow {
  id: root

  required property Item anchorItem
  property bool open: false
  property bool mounted: false
  property int month: new Date().getMonth()
  property int year: new Date().getFullYear()
  property date selectedDate: new Date()
  signal dismissed()
  readonly property var monthNames: [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]

  implicitWidth: 320
  implicitHeight: 340
  visible: mounted

  onVisibleChanged: {
    if (!root.visible && root.mounted && root.open)
      root.dismissed()
  }

  anchor {
    item: root.anchorItem
    edges: Edges.Bottom | Edges.Right
    gravity: Edges.Bottom | Edges.Right
    margins.top: Style.componentVerticalPadding
    adjustment: PopupAdjustment.Flip | PopupAdjustment.Slide | PopupAdjustment.Resize
  }

  onOpenChanged: {
    if (root.open) {
      hideTimer.stop()
      root.mounted = true
    } else {
      hideTimer.restart()
    }
  }

  Timer {
    id: hideTimer
    interval: 180
    onTriggered: {
      if (!root.open)
        root.mounted = false
    }
  }

  Rectangle {
    id: background
    anchors.fill: parent
    radius: Style.componentRadius
    color: Style.componentBackground
    border.color: "#55FFFFFF"
    border.width: 1
    opacity: root.open ? 1 : 0
    scale: root.open ? 1 : 0.94

    Behavior on opacity {
      NumberAnimation {
        duration: 180
        easing.type: Easing.OutCubic
      }
    }

    Behavior on scale {
      NumberAnimation {
        duration: 180
        easing.type: Easing.OutBack
      }
    }

    Column {
      anchors.fill: parent
      anchors.margins: Style.componentHorizontalPadding
      spacing: 10

      Row {
        width: parent.width
        height: 32
        spacing: 8

        Rectangle {
          width: 32
          height: 32
          radius: Style.componentRadius
          color: previousMouse.containsMouse ? "#33FFFFFF" : "transparent"

          Text {
            anchors.centerIn: parent
            text: "‹"
            color: "white"
            font.family: Style.fontFamily
            font.pixelSize: Style.fontSize
          }

          MouseArea {
            id: previousMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.previousMonth()
          }
        }

        Text {
          width: parent.width - 80
          height: 32
          text: root.monthNames[root.month] + " " + root.year
          color: "white"
          font.family: Style.fontFamily
          font.pixelSize: Style.fontSize
          font.bold: true
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
          width: 32
          height: 32
          radius: Style.componentRadius
          color: nextMouse.containsMouse ? "#33FFFFFF" : "transparent"

          Text {
            anchors.centerIn: parent
            text: "›"
            color: "white"
            font.family: Style.fontFamily
            font.pixelSize: Style.fontSize
          }

          MouseArea {
            id: nextMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.nextMonth()
          }
        }
      }

      Row {
        width: parent.width
        height: 20

        Repeater {
          model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

          Text {
            width: parent.width / 7
            height: 20
            text: modelData
            color: "#BFFFFFFF"
            font.family: Style.fontFamily
            font.pixelSize: Style.fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }
        }
      }

      MonthGrid {
        id: monthGrid
        width: parent.width
        height: parent.height - 74
        month: root.month
        year: root.year
        locale: Qt.locale()
        spacing: 4

        delegate: Rectangle {
          required property var model

          width: monthGrid.width / 7 - 4
          height: monthGrid.height / 6 - 4
          radius: Style.componentRadius
          color: model.today ? "#55FFFFFF" : selected ? "#33FFFFFF" : "transparent"
          opacity: model.month === root.month ? 1 : 0.35

          readonly property bool selected: Qt.formatDate(model.date, "yyyy-MM-dd") === Qt.formatDate(root.selectedDate, "yyyy-MM-dd")

          Text {
            anchors.centerIn: parent
            text: model.day
            color: "white"
            font.family: Style.fontFamily
            font.pixelSize: Style.fontSize
            font.bold: model.today || parent.selected
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              if (model.month === root.month)
                root.selectedDate = model.date
            }
          }
        }
      }
    }
  }

  function previousMonth() {
    if (root.month === 0) {
      root.month = 11
      root.year -= 1
    } else {
      root.month -= 1
    }
  }

  function nextMonth() {
    if (root.month === 11) {
      root.month = 0
      root.year += 1
    } else {
      root.month += 1
    }
  }
}
