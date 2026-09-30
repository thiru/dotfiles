import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
  id: root

  spacing: 4
  property var screen
  readonly property var monitor: Hyprland.monitorFor(root.screen)

  Repeater {
    model: ScriptModel {
      values: root.monitor === null
        ? []
        : Hyprland.workspaces.values.filter(workspace => workspace.monitor === root.monitor)
    }

    delegate: Rectangle {
      required property var modelData

      width: workspace.implicitWidth + Style.componentHorizontalPadding
      height: workspace.implicitHeight + Style.componentVerticalPadding
      radius: Style.componentRadius
      color: modelData.focused ?  "#F9E2AF" : Style.componentBackground

      Text {
        id: workspace
        anchors.centerIn: parent
        text: modelData.name
        color: modelData.focused ? "black" : "white"
        font.bold: modelData.focused
        font.pixelSize: Style.fontSize
      }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          if (Hyprland.usingLua)
            Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData.id + " })")
          else
            Hyprland.dispatch("workspace " + modelData.id)
        }
      }
    }
  }
}
