import QtQuick

Rectangle {
  id: root
  color: Style.componentBackground
  radius: Style.componentRadius
  implicitWidth: clock.implicitWidth + Style.componentHorizontalPadding
  implicitHeight: clock.implicitHeight + Style.componentVerticalPadding

  Text {
    id: clock
    text: Time.time
    color: "white"
    font.family: Style.fontFamily
    font.pixelSize: Style.fontSize
    anchors.centerIn: parent
  }

  MouseArea {
    anchors.fill: parent
    onClicked: root.calendarOpen = !root.calendarOpen
  }

  property bool calendarOpen: false
}
