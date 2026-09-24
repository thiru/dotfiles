import QtQuick
import Quickshell.Hyprland

Rectangle {
  readonly property int maxTitleLength: 90

  color: Style.componentBackground
  radius: Style.componentRadius
  implicitWidth: title.implicitWidth + Style.componentHorizontalPadding
  implicitHeight: title.implicitHeight + Style.componentVerticalPadding
  visible: title.text.length > 0

  Text {
    id: title
    text: {
      const activeTitle = Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "";
      return activeTitle.length > maxTitleLength ? activeTitle.slice(0, maxTitleLength) + "…" : activeTitle;
    }
    color: "white"
    font.family: Style.fontFamily
    font.pixelSize: Style.fontSize
    elide: Text.ElideRight
    verticalAlignment: Text.AlignVCenter
    anchors {
      left: parent.left
      right: parent.right
      verticalCenter: parent.verticalCenter
      leftMargin: Style.componentHorizontalPadding / 2
      rightMargin: Style.componentHorizontalPadding / 2
    }
  }
}
