# MetronomeApp

MetronomeApp is a lightweight SwiftUI metronome for iOS. It blends a clean tempo dial with haptic-synced playback so musicians can practice with visual, audible, and tactile feedback. The project targets iOS 17+ and showcases Apple's latest SwiftUI and sensory feedback APIs.

## Requirements
- Xcode 15 or later
- iOS 17 simulator or device

## Getting Started
1. Install Xcode 15+ from the Mac App Store or Apple Developer site.
2. Clone or download this repository into `~/XcodeProjects/MetronomeApp`.
3. Launch the workspace with:
   ```bash
   xed MetronomeApp.xcodeproj
   ```
4. Select an iPhone simulator (e.g., iPhone 15) and press `Cmd+R` to build and run.

## Project Structure
- `MetronomeApp/MetronomeAppApp.swift` — `@main` entry point that wires `ContentView` into the window scene.
- `MetronomeApp/ContentView.swift` — SwiftUI view handling metronome UI, tempo slider, and audio scheduling helpers.
- `MetronomeApp/Assets.xcassets` — App icons, colors, and any future audio glyphs.
- `docs/AGENTS.md` — Contributor guidelines covering code style, testing, and PR expectations.

## Development & Testing
- Build locally with:
  ```bash
  xcodebuild -scheme MetronomeApp -configuration Debug build
  ```
- Run tests once a test target exists:
  ```bash
  xcodebuild -scheme MetronomeApp -destination 'platform=iOS Simulator,name=iPhone 15' test
  ```
- Use the in-app tempo slider or the ± buttons to adjust BPM between 40 and 240 while playback is paused.

## Audio Notes
The click track is synthesized in memory using AVFoundation. The app writes a short CAF file to the temporary directory, caches it via `AVAudioPlayer`, and replays it on each beat. If you customize the sound, replace the buffer generation in `setupAudio()` or import assets into `Assets.xcassets`.

## Contributing
Before opening a pull request, read `docs/AGENTS.md` for coding standards, testing expectations, and review checklists. Keep commits focused and use imperative subject lines (e.g., `Add haptic feedback toggle`) to match the repository history.
