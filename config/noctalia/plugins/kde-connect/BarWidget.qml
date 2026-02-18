import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Modules.Panels.Settings
import qs.Services.Hardware
import qs.Services.UI
import qs.Widgets
import "./Services"

Item {
  id: root

  property var pluginApi: null

  property ShellScreen screen

  // Widget properties passed from Bar.qml for per-instance settings
  property string widgetId: ""
  property string section: ""

  // Explicit screenName property ensures reactive binding when screen changes
  readonly property string screenName: screen ? screen.name : ""

  implicitWidth: pill.width
  implicitHeight: pill.height

  visible: true

  BarPill {
    id: pill

    function getIcon(device) {
      if (!KDEConnect.daemonAvailable)
        return "exclamation-circle"

      if (device === null || !device.reachable)
        return "device-mobile-off"

      if (device.notificationIds.length > 0)
        return "device-mobile-message"
      else if (device.charging)
        return "device-mobile-charging"
      else
        return "device-mobile"
    }

    screen: root.screen
    oppositeDirection: BarService.getPillDirection(root)
    customIconColor: Color.resolveColorKeyOptional(root.iconColorKey)
    customTextColor: Color.resolveColorKeyOptional(root.textColorKey)
    icon: getIcon(KDEConnect.mainDevice)
    autoHide: false // Important to be false so we can hover as long as we want
    text: !KDEConnect.daemonAvailable || KDEConnect.mainDevice === null || KDEConnect.mainDevice.battery === -1 ? "" : (KDEConnect.mainDevice.battery + "%")
    tooltipText: pluginApi?.tr("bar.tooltip")
    onClicked: {
      if (pluginApi) {
        pluginApi.openPanel(root.screen, this);
      }
    }
  }
}
