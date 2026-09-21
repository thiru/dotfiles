import Quickshell
import Quickshell.Io

Scope {
  id: root

  property bool barVisible: true

  Bar {
    barVisible: root.barVisible
  }

  IpcHandler {
    target: "bar"

    function toggle(): void {
      root.barVisible = !root.barVisible
    }
  }
}
