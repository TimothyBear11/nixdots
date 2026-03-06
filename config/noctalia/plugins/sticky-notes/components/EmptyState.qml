import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Item {
  id: emptyState

  property var pluginApi: null

  ColumnLayout {
    anchors.centerIn: parent
    spacing: Style.marginM

    NIcon {
      Layout.alignment: Qt.AlignHCenter
      icon: "note"
      pointSize: Style.fontSizeXXL * 2
      color: Color.mOnSurfaceVariant
    }

    NText {
      Layout.alignment: Qt.AlignHCenter
      text: emptyState.pluginApi?.tr("notes.empty") || "No notes yet"
      font.pointSize: Style.fontSizeM * Style.uiScaleRatio
      color: Color.mOnSurfaceVariant
    }

    NText {
      Layout.alignment: Qt.AlignHCenter
      text: emptyState.pluginApi?.tr("notes.create-first") || "Click + to create your first note"
      font.pointSize: Style.fontSizeS * Style.uiScaleRatio
      color: Color.mOutline
    }
  }
}
