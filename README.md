# MetronomeApp

<p align="center">
  <img src="MetronomeApp/Assets.xcassets/AppIcon.appiconset/AppIcon.png" width="120" alt="Metronome icon">
</p>

A lightweight SwiftUI metronome for iOS that pairs a minimal UI with visual pulses, tactile feedback, and a synthesized click. MetronomeApp targets iOS 17+ and demonstrates modern SwiftUI, animation, and AVFoundation techniques.

## Features
- Tempo control from 40–240 BPM via slider or ± step buttons.
- Pulse animation and haptic feedback synchronized with each beat.
- Low-latency click synthesized on launch to avoid file shipping.
- Simple, single-screen layout designed for one-handed use.

## Requirements
- macOS with Xcode 15 or newer.
- iOS 17 simulator or device (built with the iOS 17 SDK).

## Quick Start
1. Clone or download the project into `~/XcodeProjects/MetronomeApp`.
2. Open the project:  
   ```bash
   xed MetronomeApp.xcodeproj
   ```
3. Select an iPhone simulator (e.g., iPhone 15/17 Pro) or a connected device.
4. Press `Cmd+R` to build and run. Tap **Start** to hear the click; use the slider/± buttons to adjust BPM while paused.

## Screenshots
<table>
  <tr>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro - 2025-11-12 at 13.59.24.png" width="320" alt="Metronome idle screenshot">
    </td>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro - 2025-11-12 at 13.59.31.png" width="320" alt="Metronome playing screenshot">
    </td>
  </tr>
  <tr>
    <td align="center">Idle state with tempo controls</td>
    <td align="center">Active playback highlighting the pulse</td>
  </tr>
</table>

## Project Structure
- `MetronomeApp/MetronomeAppApp.swift` – `@main` entry point wiring `ContentView` into the window scene.
- `MetronomeApp/ContentView.swift` – SwiftUI layout plus playback, timer, and audio logic.
- `MetronomeApp/Assets.xcassets` – App icon and space for future design assets.
- `screenshots/` – Simulated device captures used in this README.

## How It Works
- **Audio:** `setupAudio()` synthesizes a short click waveform, writes it to a CAF file in the temporary directory, and keeps an `AVAudioPlayer` ready for reuse. Each beat rewinds the player to avoid latency.
- **Timing:** `startMetronome()` schedules a repeating `Timer` at `60 / BPM` seconds. The timer triggers the click, toggles the pulse animation, and schedules a quick decay reset.
- **UI:** SwiftUI state drives the live BPM readout, disables controls while running, and animates the large circle using `.spring` for a subtle bounce.

## Development Notes
- Build from the CLI if needed:
  ```bash
  xcodebuild -scheme MetronomeApp -configuration Debug build
  ```
- Once unit/UI tests exist, run them with:
  ```bash
  xcodebuild -scheme MetronomeApp -destination 'platform=iOS Simulator,name=iPhone 15' test
  ```
- Customize the click sound by editing `setupAudio()` or by adding audio assets to `Assets.xcassets` and swapping the playback source.
