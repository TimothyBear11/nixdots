import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Rectangle {
  id: newNoteCard

  property string noteColor: "#FFF9C4"
  property var pluginApi: null

  signal saveClicked(string content, string editedColor)
  signal cancelClicked()

  width: parent ? parent.width : 200
  height: 200 * Style.uiScaleRatio
  color: noteColor
  radius: Style.radiusM
  border.color: Color.mPrimary
  border.width: 2

  // Save button (top-right)
  Rectangle {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: Style.marginXS
    width: 28 * Style.uiScaleRatio
    height: 28 * Style.uiScaleRatio
    radius: Style.radiusS
    color: saveBtnArea.containsMouse ? Qt.rgba(0, 0, 0, 0.12) : Qt.rgba(0, 0, 0, 0.06)
    z: 20

    NIcon {
      anchors.centerIn: parent
      icon: "check"
      pointSize: Style.fontSizeS
      color: "#37474F"
    }

    MouseArea {
      id: saveBtnArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: newNoteCard.saveClicked(textArea.text, newNoteCard.noteColor)
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Style.marginM
    anchors.rightMargin: 36 * Style.uiScaleRatio
    spacing: 2

    Flickable {
      id: flickable
      Layout.fillWidth: true
      Layout.fillHeight: true
      contentWidth: width
      contentHeight: textArea.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      flickableDirection: Flickable.VerticalFlick

      TextEdit {
        id: textArea
        width: flickable.width
        color: "#3E2723"
        font.pointSize: Style.fontSizeS * Style.uiScaleRatio
        wrapMode: TextEdit.Wrap
        selectByMouse: true
        focus: newNoteCard.visible

        NText {
          visible: textArea.text.length === 0 && !textArea.activeFocus
          text: newNoteCard.pluginApi?.tr("editor.placeholder") || "Start writing in Markdown..."
          font.pointSize: Style.fontSizeS * Style.uiScaleRatio
          color: Qt.rgba(0, 0, 0, 0.3)
        }

        Keys.onPressed: (event) => {
          if (event.key === Qt.Key_Escape) {
            newNoteCard.cancelClicked();
            event.accepted = true;
          } else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) &&
                     (event.modifiers & Qt.ControlModifier)) {
            newNoteCard.saveClicked(textArea.text, newNoteCard.noteColor);
            event.accepted = true;
          } else if (event.key === Qt.Key_S && (event.modifiers & Qt.ControlModifier)) {
            newNoteCard.saveClicked(textArea.text, newNoteCard.noteColor);
            event.accepted = true;
          }
        }
      }
    }

    // Shortcut hint
    NText {
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignRight
      text: newNoteCard.pluginApi?.tr("editor.hint") || "Ctrl+Enter save · Esc cancel"
      font.pointSize: (Style.fontSizeXS - 1) * Style.uiScaleRatio
      color: Qt.rgba(0, 0, 0, 0.3)
    }
  }

  onVisibleChanged: {
    if (visible) {
      textArea.text = "";
      textArea.forceActiveFocus();
    }
  }

  function getText() {
    return textArea.text;
  }
}
