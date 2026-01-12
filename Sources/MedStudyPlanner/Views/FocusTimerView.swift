import SwiftUI

struct FocusTimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var goalInput = ""
    @State private var distractionPad = ""
    @State private var timerMinutes = 25
    @State private var timerSeconds = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Pre-flight Goal Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Study Goal")
                        .font(.headline)
                    TextField("What will you study?", text: $goalInput)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isRunning)
                    if goalInput.isEmpty {
                        Text("⚠️ Set a goal to start the timer")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(12)
                
                // Timer Display
                VStack(spacing: 16) {
                    Text(String(format: "%02d:%02d", timerMinutes, timerSeconds))
                        .font(.system(size: 72, weight: .bold, design: .monospaced))
                    
                    // Timer Controls
                    HStack(spacing: 20) {
                        if !isRunning {
                            Button {
                                startTimer()
                            } label: {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Start")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(goalInput.isEmpty ? Color.gray : Color.green)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            }
                            .disabled(goalInput.isEmpty)
                        } else {
                            Button {
                                pauseTimer()
                            } label: {
                                HStack {
                                    Image(systemName: "pause.fill")
                                    Text("Pause")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            }
                        }
                        
                        Button {
                            resetTimer()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Reset")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
                
                // Distraction Pad
                VStack(alignment: .leading, spacing: 8) {
                    Text("Distraction Pad")
                        .font(.headline)
                    TextEditor(text: $distractionPad)
                        .frame(height: 120)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    Text("Dump random thoughts here to stay focused")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Focus Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        timer?.invalidate()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        guard !goalInput.isEmpty else { return }
        
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timerSeconds > 0 {
                timerSeconds -= 1
            } else if timerMinutes > 0 {
                timerMinutes -= 1
                timerSeconds = 59
            } else {
                // Timer completed
                pauseTimer()
                // Could add notification/sound here
            }
        }
    }
    
    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func resetTimer() {
        pauseTimer()
        timerMinutes = 25
        timerSeconds = 0
    }
}
