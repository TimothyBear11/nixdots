import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

import "../utils/storage.js" as Storage

Item {
  id: root

  required property var pluginApi
  required property var notesModel // ListModel from Panel

  signal saveRequested(string noteId, string content, string saveColor)
  signal deleteRequested(string noteId)

  // Editing state
  property string newNoteColor: ""
  property int editingIndex: -1
  property string editingNoteId: ""
  property string editingContent: ""
  property bool creatingNew: false

  // Provide actual total content height (grid + spacing + top action row)
  property real listContentHeight: gridFlow.height + (36 * Style.uiScaleRatio) 

  function startEditing(index, noteId, content) {
    root.editingNoteId = noteId;
    root.editingContent = content;
    root.creatingNew = false;
    root.editingIndex = index;
  }

  function startCreating() {
    root.editingIndex = -2;
    root.editingNoteId = "";
    root.editingContent = "";
    root.newNoteColor = Storage.pickRandomColor();
    root.creatingNew = true;
    gridFlickable.contentY = 0;
  }

  function finishEditing(content, saveColor) {
    if (root.editingIndex === -1 && !root.creatingNew) return;

    // Empty content protection (#16)
    if (!content || content.trim().length === 0) {
      cancelEditing();
      return;
    }

    root.saveRequested(root.editingNoteId, content, saveColor || "");
    root.editingIndex = -1;
    root.editingNoteId = "";
    root.editingContent = "";
    root.creatingNew = false;
    root.newNoteColor = "";
  }

  function cancelEditing() {
    root.editingIndex = -1;
    root.editingNoteId = "";
    root.editingContent = "";
    root.creatingNew = false;
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginS

    // New note button row
    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginS

      Item { Layout.fillWidth: true }

      NIconButton {
        icon: "add"
        baseSize: 28 * Style.uiScaleRatio
        colorBg: Color.mPrimary
        colorFg: Color.mOnPrimary
        customRadius: 14 * Style.uiScaleRatio
        tooltipText: root.pluginApi?.tr("notes.new") || "New Note"

        onClicked: {
          root.startCreating();
        }
      }
    }

    // Sticky notes list
    Flickable {
      id: gridFlickable
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      contentWidth: width
      contentHeight: gridFlow.height
      boundsBehavior: Flickable.StopAtBounds
      flickableDirection: Flickable.VerticalFlick

      ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
      }

      Column {
        id: gridFlow
        width: gridFlickable.width
        spacing: Style.marginS

        // New note card (when creating)
        NewNoteCard {
          id: newNoteCard
          visible: root.creatingNew
          width: gridFlow.width
          noteColor: root.newNoteColor || "#FFF9C4"
          pluginApi: root.pluginApi

          onSaveClicked: function(content, color) {
            root.finishEditing(content, color);
          }

          onCancelClicked: {
            root.cancelEditing();
          }
        }

        // Existing notes
        Repeater {
          model: root.notesModel

          delegate: NoteCard {
            editingIndex: root.editingIndex
            editingContent: root.editingContent
            pluginApi: root.pluginApi
            width: gridFlow.width

            onSaveClicked: function(editedContent, editedColor) {
              root.finishEditing(editedContent, editedColor);
            }

            onEditClicked: {
              root.startEditing(index, noteId, content);
            }

            onDeleteClicked: {
              root.deleteRequested(noteId);
            }

            onCancelClicked: {
              root.cancelEditing();
            }
          }
        }
      }

      // Empty state
      EmptyState {
        anchors.centerIn: parent
        width: parent.width
        height: implicitHeight
        visible: root.notesModel.count === 0 && !root.creatingNew
        pluginApi: root.pluginApi
      }
    }
  }
}
