//
//  ContentView.swift
//  MetronomeApp
//
//  Created by sebastien lato on 2025-11-05.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var bpm: Double = 120
    @State private var isPlaying = false
    @State private var beatPulse = false
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    Spacer()
                        .frame(height: 40)

                    ZStack {
                        Circle()
                            .fill(isPlaying ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .scaleEffect(beatPulse ? 1.15 : 1.0)
                            .animation(.spring(response: 0.15, dampingFraction: 0.5), value: beatPulse)

                        Image(systemName: "metronome.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 12) {
                        Text("\(Int(bpm))")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)

                        Text("BPM")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 20) {
                        Slider(value: $bpm, in: 40...240, step: 1) {
                            Text("Tempo")
                        } minimumValueLabel: {
                            Image(systemName: "tortoise.fill")
                                .foregroundStyle(.secondary)
                        } maximumValueLabel: {
                            Image(systemName: "hare.fill")
                                .foregroundStyle(.secondary)
                        }
                        .disabled(isPlaying)

                        HStack(spacing: 20) {
                            Button {
                                if bpm > 40 {
                                    bpm -= 5
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                            }
                            .disabled(isPlaying)

                            Button {
                                isPlaying.toggle()
                                if isPlaying {
                                    startMetronome()
                                } else {
                                    stopMetronome()
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isPlaying ? Color.red : Color.blue)
                                        .frame(width: 140, height: 60)

                                    HStack(spacing: 8) {
                                        Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                        Text(isPlaying ? "Stop" : "Start")
                                    }
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                }
                            }
                            .sensoryFeedback(.impact(weight: .medium), trigger: isPlaying)

                            Button {
                                if bpm < 240 {
                                    bpm += 5
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                            }
                            .disabled(isPlaying)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Metronome")
        }
        .onAppear {
            setupAudio()
        }
    }

    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session")
        }

        let sampleRate = 44100.0
        let duration = 0.05
        let frequency = 1200.0

        let frameCount = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: frameCount)

        for i in 0..<frameCount {
            let value = sin(2.0 * .pi * frequency * Double(i) / sampleRate)
            let envelope = 1.0 - (Double(i) / Double(frameCount))
            samples[i] = Float(value * envelope * 0.8)
        }

        let audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: sampleRate,
            channels: 1,
            interleaved: false
        )!
        let audioBuffer = AVAudioPCMBuffer(
            pcmFormat: audioFormat,
            frameCapacity: AVAudioFrameCount(frameCount)
        )!
        audioBuffer.frameLength = AVAudioFrameCount(frameCount)

        let channelData = audioBuffer.floatChannelData![0]
        for i in 0..<frameCount {
            channelData[i] = samples[i]
        }

        let audioFile = try? AVAudioFile(
            forWriting: FileManager.default.temporaryDirectory.appendingPathComponent("click.caf"),
            settings: audioFormat.settings,
            commonFormat: .pcmFormatFloat32,
            interleaved: false
        )
        try? audioFile?.write(from: audioBuffer)

        if let url = audioFile?.url {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        }
    }

    private func startMetronome() {
        playClick()
        beatPulse = true

        let interval = 60.0 / bpm
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            playClick()
            beatPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                beatPulse = false
            }
        }
    }

    private func stopMetronome() {
        timer?.invalidate()
        timer = nil
        beatPulse = false
    }

    private func playClick() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
}

#Preview {
    ContentView()
}
