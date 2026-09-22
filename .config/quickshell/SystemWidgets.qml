import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray

Row {
  id: root

  spacing: Style.componentHorizontalMargin

  property string uptime: "--"
  property int cpuUsage: 0
  property int ramUsage: 0
  property string diskFree: "--"
  property string weather: "--"
  property bool idleInhibited: false
  property real previousCpuTotal: 0
  property real previousCpuIdle: 0

  signal toggleIdleInhibited()

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool audioReady: sink !== null && sink.ready && sink.audio !== null
  readonly property bool muted: audioReady ? sink.audio.muted : false
  readonly property int volume: audioReady ? Math.round(sink.audio.volume * 100) : 0

  function refreshStats() {
    statsProcess.running = false
    statsProcess.running = true
  }

  function refreshUptime() {
    uptimeProcess.running = false
    uptimeProcess.running = true
  }

  function refreshWeather() {
    weatherProcess.running = false
    weatherProcess.running = true
  }

  PwObjectTracker {
    objects: root.sink !== null ? [root.sink] : []
  }

  Process {
    id: statsProcess
    command: ["sh", "-c", "head -n 1 /proc/stat; free -b | awk '/^Mem:/ {printf \"%s %s\\n\", $2, $7}'; df -hP / | awk 'NR==2 {print $4}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        if (lines.length < 3)
          return

        const cpu = lines[0].trim().split(/\s+/).slice(1).map(Number)
        const total = cpu.reduce((sum, value) => sum + value, 0)
        const idle = cpu[3] + cpu[4]

        if (root.previousCpuTotal > 0 && total > root.previousCpuTotal) {
          const usage = 1 - (idle - root.previousCpuIdle) / (total - root.previousCpuTotal)
          root.cpuUsage = Math.max(0, Math.min(100, Math.round(usage * 100)))
        }

        root.previousCpuTotal = total
        root.previousCpuIdle = idle

        const memory = lines[1].trim().split(/\s+/).map(Number)
        if (memory.length >= 2 && memory[0] > 0)
          root.ramUsage = Math.round((1 - memory[1] / memory[0]) * 100)

        root.diskFree = lines[2].trim()
      }
    }
  }

  Process {
    id: uptimeProcess
    command: ["awk", "{printf \"%.1f d\", $1 / 86400}", "/proc/uptime"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.uptime = text.trim()
    }
  }

  Process {
    id: weatherProcess
    command: ["curl", "-fsS", "--max-time", "10", "https://wttr.in?format=%c%t"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.weather = text.trim() || "--"
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: root.refreshStats()
  }

  Timer {
    interval: 3600000
    running: true
    repeat: true
    onTriggered: root.refreshUptime()
  }

  Timer {
    interval: 3600000
    running: true
    repeat: true
    onTriggered: root.refreshWeather()
  }

  Rectangle {
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: idleContent.implicitWidth + Style.componentHorizontalPadding
    implicitHeight: Style.componentHeight

    Row {
      id: idleContent
      anchors.centerIn: parent
      spacing: 8

      Text {
        id: idleIcon
        anchors.verticalCenter: parent.verticalCenter
        text: root.idleInhibited ? "" : ""
        color: "white"
        font.family: Style.iconFontFamily
        font.pixelSize: Style.fontSize - 4
      }

      Text {
        id: idleStatus
        anchors.verticalCenter: parent.verticalCenter
        text: root.idleInhibited ? "Activated" : "Deactivated"
        color: "white"
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
        width: idleMouse.containsMouse ? implicitWidth : 0
        opacity: idleMouse.containsMouse ? 1 : 0
        clip: true

        Behavior on width {
          NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 120
            easing.type: Easing.OutCubic
          }
        }
      }
    }

    MouseArea {
      id: idleMouse
      anchors.fill: parent
      hoverEnabled: true
      onClicked: root.toggleIdleInhibited()
    }
  }

  Rectangle {
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: uptimeText.implicitWidth + Style.componentHorizontalPadding
    implicitHeight: uptimeText.implicitHeight + Style.componentVerticalPadding

    Text {
      id: uptimeText
      anchors.centerIn: parent
      text: "󰅐 " + root.uptime
      color: "white"
      font.family: Style.fontFamily
      font.pixelSize: Style.fontSize
    }
  }

  Rectangle {
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: cpuContent.implicitWidth + Style.componentHorizontalPadding
    implicitHeight: cpuContent.implicitHeight + Style.componentVerticalPadding

    Row {
      id: cpuContent
      anchors.centerIn: parent
      spacing: 8

      Text {
        id: cpuIcon
        anchors.baseline: cpuText.baseline
        text: ""
        color: "white"
        font.family: Style.iconFontFamily
        font.pixelSize: Style.fontSize
      }

      Text {
        id: cpuText
        text: root.cpuUsage + "%"
        color: "white"
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
      }
    }
  }

  Rectangle {
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: ramContent.implicitWidth + Style.componentHorizontalPadding
    implicitHeight: ramContent.implicitHeight + Style.componentVerticalPadding

    Row {
      id: ramContent
      anchors.centerIn: parent
      spacing: 8

      Text {
        id: ramIcon
        anchors.baseline: ramText.baseline
        text: ""
        color: "white"
        font.family: Style.iconFontFamily
        font.pixelSize: Style.fontSize
      }

      Text {
        id: ramText
        text: root.ramUsage + "%"
        color: "white"
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
      }
    }
  }

  Rectangle {
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: diskContent.implicitWidth + Style.componentHorizontalPadding
    implicitHeight: diskContent.implicitHeight + Style.componentVerticalPadding

    Row {
      id: diskContent
      anchors.centerIn: parent
      spacing: 8

      Text {
        id: diskIcon
        anchors.baseline: diskText.baseline
        text: ""
        color: "white"
        font.family: Style.iconFontFamily
        font.pixelSize: Style.fontSize
      }

      Text {
        id: diskText
        text: root.diskFree
        color: "white"
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
      }
    }
  }

  Rectangle {
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: volumeContent.implicitWidth + Style.componentHorizontalPadding
    implicitHeight: volumeContent.implicitHeight + Style.componentVerticalPadding

    Row {
      id: volumeContent
      anchors.centerIn: parent
      spacing: 8

      Text {
        id: volumeIcon
        anchors.baseline: volumeText.baseline
        text: root.muted ? "" : root.volume < 33 ? "" : root.volume < 66 ? "" : ""
        color: "white"
        font.family: Style.iconFontFamily
        font.pixelSize: Style.fontSize
      }

      Text {
        id: volumeText
        text: (root.muted ? 0 : root.volume) + "%"
        color: "white"
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
      }
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (!root.audioReady)
          return

        if (mouse.button === Qt.LeftButton)
          Quickshell.execDetached(["pavucontrol"])
        else if (mouse.button === Qt.RightButton)
          root.sink.audio.muted = !root.sink.audio.muted
      }
    }
  }

  Rectangle {
    id: tray
    visible: SystemTray.items.values.length > 0
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: visible ? trayItems.implicitWidth + Style.componentHorizontalPadding : 0
    implicitHeight: visible ? Style.componentHeight : 0

    Row {
      id: trayItems
      anchors.centerIn: parent
      spacing: 10

      Repeater {
        model: SystemTray.items

        delegate: Item {
          required property var modelData

          width: 18
          height: 18

          Image {
            anchors.fill: parent
            source: modelData.icon
            sourceSize.width: 18
            sourceSize.height: 18
            fillMode: Image.PreserveAspectFit
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => {
              if (mouse.button === Qt.LeftButton && !modelData.onlyMenu)
                modelData.activate()
              else if (mouse.button === Qt.RightButton)
                modelData.secondaryActivate()
            }
          }
        }
      }
    }
  }

  Rectangle {
    color: Style.componentBackground
    radius: Style.componentRadius
    implicitWidth: weatherText.implicitWidth + Style.componentHorizontalPadding
    implicitHeight: weatherText.implicitHeight + Style.componentVerticalPadding

    Text {
      id: weatherText
      anchors.centerIn: parent
      text: root.weather
      color: "white"
      font.family: Style.fontFamily
      font.pixelSize: Style.fontSize
    }

    MouseArea {
      anchors.fill: parent
      onClicked: Quickshell.execDetached(["librewolf", "--new-window", "https://www.accuweather.com/en/ca/toronto/m5h/daily-weather-forecast/55488"])
    }
  }
}
