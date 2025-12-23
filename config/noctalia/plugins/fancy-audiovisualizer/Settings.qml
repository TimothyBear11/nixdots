import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  spacing: Style.marginM

  // Local state for editing
  property real valueSensitivity: pluginApi?.pluginSettings?.sensitivity ?? 1.5
  property bool valueShowRings: pluginApi?.pluginSettings?.showRings ?? true
  property bool valueShowBars: pluginApi?.pluginSettings?.showBars ?? true
  property real valueRotationSpeed: pluginApi?.pluginSettings?.rotationSpeed ?? 0.5
  property real valueBarWidth: pluginApi?.pluginSettings?.barWidth ?? 0.6
  property real valueRingOpacity: pluginApi?.pluginSettings?.ringOpacity ?? 0.8
  property real valueBloomIntensity: pluginApi?.pluginSettings?.bloomIntensity ?? 0.5

  NHeader {
    label: pluginApi?.tr("settings.title") ?? "Visualizer Settings"
    description: pluginApi?.tr("settings.description") ?? "Configure the audio visualizer appearance"
  }

  // Show Rings toggle
  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.showRings") ?? "Show Rings"
    description: pluginApi?.tr("settings.showRings-description") ?? "Display reactive rings in the center"
    checked: root.valueShowRings
    onToggled: checked => root.valueShowRings = checked
  }

  // Show Bars toggle
  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.showBars") ?? "Show Bars"
    description: pluginApi?.tr("settings.showBars-description") ?? "Display circular audio bars"
    checked: root.valueShowBars
    onToggled: checked => root.valueShowBars = checked
  }

  // Sensitivity slider
  NValueSlider {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.sensitivity") ?? "Sensitivity"
    value: root.valueSensitivity
    from: 0.5
    to: 3.0
    stepSize: 0.1
    onMoved: value => root.valueSensitivity = value
  }

  // Rotation speed slider
  NValueSlider {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.rotationSpeed") ?? "Rotation Speed"
    value: root.valueRotationSpeed
    from: 0.0
    to: 2.0
    stepSize: 0.1
    onMoved: value => root.valueRotationSpeed = value
  }

  // Bar width slider
  NValueSlider {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.barWidth") ?? "Bar Width"
    value: root.valueBarWidth
    from: 0.2
    to: 1.0
    stepSize: 0.1
    onMoved: value => root.valueBarWidth = value
  }

  // Ring opacity slider
  NValueSlider {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.ringOpacity") ?? "Ring Opacity"
    value: root.valueRingOpacity
    from: 0.0
    to: 1.0
    stepSize: 0.1
    onMoved: value => root.valueRingOpacity = value
  }

  // Bloom intensity slider
  NValueSlider {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.bloomIntensity") ?? "Bloom Intensity"
    value: root.valueBloomIntensity
    from: 0.0
    to: 1.0
    stepSize: 0.05
    onMoved: value => root.valueBloomIntensity = value
  }

  // Called when user clicks Apply/Save
  function saveSettings() {
    if (!pluginApi)
      return;

    pluginApi.pluginSettings.sensitivity = root.valueSensitivity;
    pluginApi.pluginSettings.showRings = root.valueShowRings;
    pluginApi.pluginSettings.showBars = root.valueShowBars;
    pluginApi.pluginSettings.rotationSpeed = root.valueRotationSpeed;
    pluginApi.pluginSettings.barWidth = root.valueBarWidth;
    pluginApi.pluginSettings.ringOpacity = root.valueRingOpacity;
    pluginApi.pluginSettings.bloomIntensity = root.valueBloomIntensity;

    pluginApi.saveSettings();
  }
}
