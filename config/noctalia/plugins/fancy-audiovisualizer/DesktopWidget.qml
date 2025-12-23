import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Services.Media

DraggableDesktopWidget {
  id: root

  property var pluginApi: null

  implicitWidth: 300
  implicitHeight: 300

  showBackground: false

  // Settings from plugin
  readonly property real sensitivity: pluginApi?.pluginSettings?.sensitivity ?? pluginApi?.manifest?.metadata?.defaultSettings?.sensitivity
  readonly property bool showRings: pluginApi?.pluginSettings?.showRings ?? pluginApi?.manifest?.metadata?.defaultSettings?.showRings
  readonly property bool showBars: pluginApi?.pluginSettings?.showBars ?? pluginApi?.manifest?.metadata?.defaultSettings?.showBars
  readonly property real rotationSpeed: pluginApi?.pluginSettings?.rotationSpeed ?? pluginApi?.manifest?.metadata?.defaultSettings?.rotationSpeed
  readonly property real barWidth: pluginApi?.pluginSettings?.barWidth ?? pluginApi?.manifest?.metadata?.defaultSettings?.barWidth
  readonly property real ringOpacity: pluginApi?.pluginSettings?.ringOpacity ?? pluginApi?.manifest?.metadata?.defaultSettings?.ringOpacity
  readonly property real bloomIntensity: pluginApi.pluginSettings?.bloomIntensity ?? pluginApi?.manifest?.metadata?.defaultSettings?.bloomIntensity

  // Animation time for shader (0 to 3600, 1 hour cycle)
  property real shaderTime: 0
  NumberAnimation on shaderTime {
    loops: Animation.Infinite
    from: 0
    to: 3600
    duration: 3600000
    running: !CavaService.isIdle
  }

  // Hidden canvas that encodes audio data as a 32x1 texture
  Canvas {
    id: audioCanvas
    width: 32
    height: 1
    visible: false

    onPaint: {
      var ctx = getContext("2d");
      var values = CavaService.values;
      if (!values || values.length === 0) {
        ctx.fillStyle = "black";
        ctx.fillRect(0, 0, 32, 1);
        return;
      }
      for (var i = 0; i < 32; i++) {
        var v = values[i] || 0;
        // Encode amplitude in grayscale (R=G=B=amplitude)
        var c = Math.floor(v * 255);
        ctx.fillStyle = "rgb(" + c + "," + c + "," + c + ")";
        ctx.fillRect(i, 0, 1, 1);
      }
    }
  }

  // Trigger canvas repaint when audio data changes
  Connections {
    target: CavaService
    function onValuesChanged() {
      if (!CavaService.isIdle) {
        audioCanvas.requestPaint();
      }
    }
  }

  // Unique instance ID for CavaService registration
  // This prevents the old widget's destruction from unregistering the new widget
  readonly property string cavaInstanceId: "plugin:fancy-audiovisualizer:" + Date.now() + Math.random()

  // Register with CavaService when pluginApi becomes available
  onPluginApiChanged: {
    if (pluginApi) {
      CavaService.registerComponent(cavaInstanceId);
      audioCanvas.requestPaint();
    }
  }

  Component.onDestruction: {
    CavaService.unregisterComponent(cavaInstanceId);
  }

  // Audio texture source (outside ShaderEffect to avoid 'source' property warning)
  ShaderEffectSource {
    id: audioTextureSource
    sourceItem: audioCanvas
    live: true
    hideSource: true
  }

  // The shader effect visualization
  ShaderEffect {
    id: visualizer
    anchors.fill: parent
    visible: pluginApi !== null

    // Audio texture - named 'source' to match ShaderEffectSource's property and avoid warning
    property var source: audioTextureSource

    // Uniforms passed to shader
    property real time: root.shaderTime
    property real itemWidth: visualizer.width
    property real itemHeight: visualizer.height
    property color primaryColor: Color.mPrimary
    property color accentColor: Color.mSecondary
    property real sensitivity: root.sensitivity
    property real rotationSpeed: root.rotationSpeed
    property real showRings: root.showRings ? 1.0 : 0.0
    property real showBars: root.showBars ? 1.0 : 0.0
    property real barWidth: root.barWidth
    property real ringOpacity: root.ringOpacity
    property real cornerRadius: Style.radiusL
    property real bloomIntensity: root.bloomIntensity

    fragmentShader: pluginApi ? Qt.resolvedUrl(pluginApi.pluginDir + "/shaders/visualizer.frag.qsb") : ""
  }

  // Fallback when shader not loaded
  Rectangle {
    anchors.fill: parent
    color: Color.mSurface
    radius: Style.radiusL
    visible: !visualizer.visible || visualizer.fragmentShader === ""

    Text {
      anchors.centerIn: parent
      text: "Loading..."
      color: Color.mOnSurface
    }
  }
}
