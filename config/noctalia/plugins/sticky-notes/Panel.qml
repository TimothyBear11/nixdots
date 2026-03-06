import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

import "utils/storage.js" as Storage
import "components" as Components

// Panel Component — Main sticky-note interface
Item {
  id: root

  // Plugin API (injected by PluginPanelSlot)
  property var pluginApi: null

  // SmartPanel geometry
  readonly property var geometryPlaceholder: panelContainer
  property real contentPreferredWidth: 420 * Style.uiScaleRatio
  
  // Calculate dynamic height based on NoteList content, bounded by available screen height.
  property real contentPreferredHeight: {
      var padding = Style.marginM * 2; // Assuming ~24px total vertical padding in panel Container
      var target = (noteList.listContentHeight || 200) + padding;
      var maxH = Screen.desktopAvailableHeight ? (Screen.desktopAvailableHeight - 100 * Style.uiScaleRatio) : (1000 * Style.uiScaleRatio);
      var minH = 200 * Style.uiScaleRatio;
      return Math.max(minH, Math.min(target, maxH));
  }
  
  readonly property bool allowAttach: true

  anchors.fill: parent

  // ── Notes Model (ListModel for proper Repeater updates) ──
  ListModel { id: notesModel }

  Component.onCompleted: {
    loadNotes();
  }

  onVisibleChanged: {
    if (visible) loadNotes();
  }

  onPluginApiChanged: {
    if (pluginApi) loadNotes();
  }

  // ── Timestamp auto-refresh timer (#1) ──
  Timer {
    id: timestampRefreshTimer
    interval: 60000 // 1 minute
    running: root.visible
    repeat: true
    onTriggered: refreshTimestamps()
  }

  function refreshTimestamps() {
    for (var i = 0; i < notesModel.count; i++) {
      var item = notesModel.get(i);
      var newStr = Storage.formatDate(new Date(item.modified), root.pluginApi);
      if (item.modifiedStr !== newStr) {
        notesModel.setProperty(i, "modifiedStr", newStr);
      }
    }
  }

  // ── Functions ──────────────────────────────────────────

  function loadNotes() {
    notesModel.clear();
    if (!root.pluginApi) return;

    var stored = root.pluginApi.pluginSettings.notes;
    if (!stored || stored.length === 0) return;

    try {
      var notes = JSON.parse(stored);
      var needsPersist = false;
      for (var i = 0; i < notes.length; i++) {
        notes[i].modifiedStr = Storage.formatDate(new Date(notes[i].modified), root.pluginApi);
        // Migrate: assign color to old notes that don't have one
        if (!notes[i].color || notes[i].color === "") {
          notes[i].color = Storage.pickRandomColor();
          needsPersist = true;
        }
        
        notes[i].noteColor = notes[i].color;
        notesModel.append(notes[i]);
      }
      // Persist migrated colors so they stay consistent
      if (needsPersist) persistNotes();
    } catch (e) {
      Logger.e("MdNote", "Failed to parse notes: " + e);
    }
  }

  function saveNote(noteId, content, saveColor) {
    var now = Date.now();
    var isNew = (!noteId || noteId.length === 0);

    if (isNew) {
      noteId = Storage.generateNoteId();
    }

    var finalColor = saveColor;
    var foundIndex = -1;
    for (var i = 0; i < notesModel.count; i++) {
      if (notesModel.get(i).noteId === noteId) {
        finalColor = notesModel.get(i).noteColor || finalColor;
        foundIndex = i;
        break;
      }
    }

    var note = {
      noteId: noteId,
      content: content,
      modified: now,
      modifiedStr: Storage.formatDate(new Date(now), root.pluginApi),
      noteColor: finalColor || Storage.pickRandomColor(),
      color: finalColor || Storage.pickRandomColor()
    };

    if (foundIndex >= 0) {
      notesModel.set(foundIndex, note);
    } else {
      notesModel.insert(0, note);
    }

    persistNotes();
    Logger.i("MdNote", "Note saved: " + noteId);
  }

  function deleteNote(noteId) {
    for (var i = 0; i < notesModel.count; i++) {
      if (notesModel.get(i).noteId === noteId) {
        notesModel.remove(i);
        break;
      }
    }
    persistNotes();
    Logger.i("MdNote", "Note deleted: " + noteId);
  }

  function persistNotes() {
    if (!root.pluginApi) return;
    var notes = [];
    for (var i = 0; i < notesModel.count; i++) {
      var item = notesModel.get(i);
      notes.push({
        noteId: item.noteId,
        content: item.content,
        modified: item.modified,
        color: item.noteColor
      });
    }
    root.pluginApi.pluginSettings.notes = JSON.stringify(notes);
    root.pluginApi.saveSettings();
  }

  // ── UI ─────────────────────────────────────────────────

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    Components.NoteList {
      id: noteList
      anchors.fill: parent
      anchors.margins: Style.marginM
      pluginApi: root.pluginApi
      notesModel: notesModel

      onSaveRequested: function(noteId, content, saveColor) {
        root.saveNote(noteId, content, saveColor);
      }

      onDeleteRequested: function(noteId) {
        root.deleteNote(noteId);
      }
    }
  }
}
