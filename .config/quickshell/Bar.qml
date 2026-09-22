import Quickshell
import Quickshell.Wayland

Scope {
  id: root

  property bool barVisible: true

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: barWindow
      required property var modelData
      screen: modelData
      visible: root.barVisible
      color: "transparent"

      anchors {
        top: true
        left: true
        right: true
      }

      margins {
        top: Style.componentVerticalMargin
        left: Style.componentHorizontalMargin
        right: Style.componentHorizontalMargin
      }

      implicitHeight: Style.componentHeight

      IdleInhibitor {
        id: idleInhibitor
        window: barWindow
      }

      WorkspaceSwitcher {
        id: workspaceSwitcher
        anchors.left: parent.left
        anchors.leftMargin: Style.componentHorizontalMargin
        anchors.verticalCenter: parent.verticalCenter
      }

      WindowTitle {
        anchors.left: workspaceSwitcher.right
        anchors.leftMargin: Style.componentHorizontalMargin
        anchors.verticalCenter: parent.verticalCenter
      }

      SystemWidgets {
        idleInhibited: idleInhibitor.enabled
        onToggleIdleInhibited: idleInhibitor.enabled = !idleInhibitor.enabled
        anchors.right: clockWidget.left
        anchors.rightMargin: Style.componentHorizontalMargin
        anchors.verticalCenter: parent.verticalCenter
      }

      ClockWidget {
        id: clockWidget
        anchors.right: parent.right
        anchors.rightMargin: Style.componentHorizontalMargin
        anchors.verticalCenter: parent.verticalCenter
      }

      CalendarPopup {
        id: calendarPopup
        anchorItem: clockWidget
        open: clockWidget.calendarOpen
        onDismissed: clockWidget.calendarOpen = false
      }
    }
  }
}
