import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets
import qs.Services.UI

import "../utils/markdown.js" as Markdown

Rectangle {
  id: noteCard

  // Model roles — auto-bound by Repeater
  required property int index
  required property string noteId
  required property string content
  required property string noteColor
  required property string modifiedStr

  // Parent-provided state
  property int editingIndex: -1
  property string editingContent: ""
  property var pluginApi: null

  // Computed
  property bool isEditing: editingIndex === index
  property bool confirmingDelete: false

  // Signals
  signal saveClicked(string editedContent, string editedColor)
  signal editClicked()
  signal deleteClicked()
  signal cancelClicked()

  HoverHandler { id: cardHover }

  width: parent ? parent.width : 200
  height: isEditing
    ? 200 * Style.uiScaleRatio
    : Math.min(
        Math.max(
          100 * Style.uiScaleRatio,
          noteContent.implicitHeight + timeRow.implicitHeight + (Style.marginM * 2) + Style.marginXS
        ),
        300 * Style.uiScaleRatio
      )
  color: noteCard.noteColor || "#FFF9C4"
  radius: Style.radiusM
  border.color: isEditing
    ? Color.mPrimary
    : Qt.darker(noteCard.noteColor || "#FFF9C4", 1.06)
  border.width: isEditing ? 2 : 1

  Behavior on border.color { ColorAnimation { duration: 150 } }
  Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

  // Shadow
  Rectangle {
    anchors.fill: parent
    anchors.topMargin: 2
    anchors.leftMargin: 2
    z: -1
    color: Qt.rgba(0, 0, 0, 0.08)
    radius: Style.radiusM
  }

  // ── Display mode ──
  ColumnLayout {
    id: noteContentCol
    anchors.fill: parent
    anchors.margins: Style.marginM
    spacing: Style.marginXS
    visible: !noteCard.isEditing && !noteCard.confirmingDelete

    Flickable {
      id: noteFlickable
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      contentWidth: width
      contentHeight: noteContent.implicitHeight
      boundsBehavior: Flickable.StopAtBounds
      flickableDirection: Flickable.VerticalFlick
      interactive: contentHeight > height

      ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

      TextEdit {
        id: noteContent
        width: parent.width
        height: contentHeight
        text: Markdown.render(noteCard.content || "", { noteColor: noteCard.noteColor || "#FFF9C4" })
        textFormat: TextEdit.RichText
        font.pointSize: Style.fontSizeS * Style.uiScaleRatio
        color: "#37474F"
        wrapMode: TextEdit.Wrap
        readOnly: true
        selectByMouse: true
        activeFocusOnTab: false
        visible: (noteCard.content || "").length > 0

        onLinkActivated: (link) => Qt.openUrlExternally(link)
      }
    }

    // Timestamp
    RowLayout {
      id: timeRow
      Layout.fillWidth: true
      Item { Layout.fillWidth: true }
      NText {
        text: noteCard.modifiedStr || ""
        font.pointSize: (Style.fontSizeXS - 1) * Style.uiScaleRatio
        color: Qt.rgba(0, 0, 0, 0.35)
      }
    }
  }

  // ── Hover action buttons ──
  Row {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: Style.marginXS
    spacing: 2
    visible: cardHover.hovered && !noteCard.isEditing && !noteCard.confirmingDelete
    z: 100

    opacity: cardHover.hovered ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    TextEdit {
      id: hiddenCopyHelper
      visible: false
      text: noteCard.content
    }

    Rectangle {
      width: 28 * Style.uiScaleRatio
      height: 28 * Style.uiScaleRatio
      radius: Style.radiusS
      color: copyBtnArea.containsMouse ? Qt.rgba(0, 0, 0, 0.12) : Qt.rgba(0, 0, 0, 0.06)

      NIcon {
        id: copyIcon
        anchors.centerIn: parent
        icon: "copy"
        pointSize: Style.fontSizeS
        color: "#37474F"
      }

      MouseArea {
        id: copyBtnArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          hiddenCopyHelper.selectAll();
          hiddenCopyHelper.copy();
          hiddenCopyHelper.deselect();
          copyIcon.icon = "copy-check"
          resetCopyIconTimer.start();
          ToastService.showNotice(noteCard.pluginApi?.tr("notes.copied") || "Copied to clipboard");
        }
      }

      Timer {
        id: resetCopyIconTimer
        interval: 1500
        onTriggered: copyIcon.icon = "copy"
      }
    }

    Rectangle {
      width: 28 * Style.uiScaleRatio
      height: 28 * Style.uiScaleRatio
      radius: Style.radiusS
      color: editBtnArea.containsMouse ? Qt.rgba(0, 0, 0, 0.12) : Qt.rgba(0, 0, 0, 0.06)

      NIcon {
        anchors.centerIn: parent
        icon: "pencil"
        pointSize: Style.fontSizeS
        color: "#37474F"
      }

      MouseArea {
        id: editBtnArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: noteCard.editClicked()
      }
    }

    Rectangle {
      width: 28 * Style.uiScaleRatio
      height: 28 * Style.uiScaleRatio
      radius: Style.radiusS
      color: deleteBtnArea.containsMouse ? Qt.rgba(0.8, 0, 0, 0.15) : Qt.rgba(0, 0, 0, 0.06)

      NIcon {
        anchors.centerIn: parent
        icon: "trash"
        pointSize: Style.fontSizeS
        color: "#C62828"
      }

      MouseArea {
        id: deleteBtnArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: noteCard.confirmingDelete = true
      }
    }
  }

  // ── Delete confirmation overlay (#5) ──
  Rectangle {
    anchors.fill: parent
    visible: noteCard.confirmingDelete
    color: Qt.rgba(0, 0, 0, 0.55)
    radius: noteCard.radius
    z: 200

    ColumnLayout {
      anchors.centerIn: parent
      spacing: Style.marginM

      NText {
        Layout.alignment: Qt.AlignHCenter
        text: noteCard.pluginApi?.tr("notes.delete-confirm") || "Delete this note?"
        color: "white"
        font.pointSize: Style.fontSizeM * Style.uiScaleRatio
      }

      RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Style.marginM

        Rectangle {
          width: 64 * Style.uiScaleRatio
          height: 30 * Style.uiScaleRatio
          radius: Style.radiusS
          color: cancelArea.containsMouse ? Qt.rgba(1,1,1,0.3) : Qt.rgba(1,1,1,0.15)

          NText {
            anchors.centerIn: parent
            text: noteCard.pluginApi?.tr("notes.cancel") || "Cancel"
            color: "white"
            font.pointSize: Style.fontSizeS * Style.uiScaleRatio
          }

          MouseArea {
            id: cancelArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: noteCard.confirmingDelete = false
          }
        }

        Rectangle {
          width: 64 * Style.uiScaleRatio
          height: 30 * Style.uiScaleRatio
          radius: Style.radiusS
          color: confirmArea.containsMouse ? "#E53935" : "#C62828"

          NText {
            anchors.centerIn: parent
            text: noteCard.pluginApi?.tr("editor.delete") || "Delete"
            color: "white"
            font.pointSize: Style.fontSizeS * Style.uiScaleRatio
          }

          MouseArea {
            id: confirmArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              noteCard.confirmingDelete = false;
              noteCard.deleteClicked();
            }
          }
        }
      }
    }
  }

  // ── Edit mode overlay ──
  Item {
    anchors.fill: parent
    visible: noteCard.isEditing

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
        onClicked: noteCard.saveClicked(editTextArea.text, noteCard.noteColor)
      }
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Style.marginM
      anchors.rightMargin: 36 * Style.uiScaleRatio
      spacing: 2

      Flickable {
        id: editFlickable
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: width
        contentHeight: editTextArea.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick

        TextEdit {
          id: editTextArea
          width: editFlickable.width
          color: "#3E2723"
          font.pointSize: Style.fontSizeS * Style.uiScaleRatio
          wrapMode: TextEdit.Wrap
          selectByMouse: true

          Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
              noteCard.cancelClicked();
              event.accepted = true;
            } else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) &&
                       (event.modifiers & Qt.ControlModifier)) {
              noteCard.saveClicked(editTextArea.text, noteCard.noteColor);
              event.accepted = true;
            } else if (event.key === Qt.Key_S && (event.modifiers & Qt.ControlModifier)) {
              noteCard.saveClicked(editTextArea.text, noteCard.noteColor);
              event.accepted = true;
            }
          }
        }
      }

      // Shortcut hint (#13)
      NText {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignRight
        text: noteCard.pluginApi?.tr("editor.hint") || "Ctrl+Enter save · Esc cancel"
        font.pointSize: (Style.fontSizeXS - 1) * Style.uiScaleRatio
        color: Qt.rgba(0, 0, 0, 0.3)
      }
    }
  }

  // Focus text area when entering edit mode
  onIsEditingChanged: {
    if (isEditing) {
      editTextArea.text = noteCard.editingContent;
      editTextArea.forceActiveFocus();
      editTextArea.cursorPosition = editTextArea.text.length;
    }
    confirmingDelete = false;
  }

  // Background double-click to edit
  MouseArea {
    anchors.fill: parent
    z: -1
    onDoubleClicked: noteCard.editClicked()
  }
}
