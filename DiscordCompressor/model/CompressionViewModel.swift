//
//  CompressionViewModel.swift
//  DiscordCompressor
//
//  Created by Quenting on 09/02/2026.
//


//
//  CompressionViewModel.swift
//  DiscordCompressor
//
//  Created by Quenting on 30/12/2025.
//

import SwiftUI
import Combine

@MainActor // Ensures all property updates happen on the UI thread
class CompressionViewModel: ObservableObject {
    var targetMB = MainViewModel.instance.options!.targetMB;
    @Published var progressPass1: Double = 0.0
    @Published var progressPass2: Double = 0.0
    @Published var isCompressing: Bool = false
    @Published var isFinished: Bool = false
    
    func compress(video: ChoosenVideo) {
        self.isCompressing = true
        self.isFinished = false
        self.progressPass1 = 0
        self.progressPass2 = 0
        
        // Run on a background thread to prevent UI freezing
        Task.detached {
            let process = Process()
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe // Capture errors too
            
            // Environment Setup
            var env = ProcessInfo.processInfo.environment

            env["PATH"] = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:\(env["PATH"] ?? "")"
            process.environment = env
            
            // Command Setup
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")

            let filePath = video.path.path(percentEncoded: false)
            let scriptPath = "./compress"
            
            let launchArgs = "\(scriptPath) \"\(filePath)\" \"\(await self.targetMB)\""
            debugPrint("Launch args: \(launchArgs)")
            process.currentDirectoryPath = "/Users/nixuge/Documents/Records"
            process.arguments = ["-c", launchArgs]
            
            // Handle Data Reading
            let outputHandle = pipe.fileHandleForReading
            
            // Regex to find "PROGRESS:1:50"
            // Captures: Group 1 (Pass Num), Group 2 (Percentage)
            let progressRegex = try! NSRegularExpression(pattern: "PROGRESS:([1-2]):([0-9]+)")
            
            outputHandle.readabilityHandler = { fileHandle in
                let data = fileHandle.availableData
                guard !data.isEmpty, let output = String(data: data, encoding: .utf8) else { return }
                
                // Update UI on Main Actor
                Task { @MainActor in
                    print("\(output)")
                    
                    output.enumerateLines { line, _ in
                        if let match = progressRegex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)) {
                            let passRange = Range(match.range(at: 1), in: line)!
                            let percentRange = Range(match.range(at: 2), in: line)!
                            
                            let passNumber = Int(line[passRange]) ?? 1
                            let percent = Double(line[percentRange]) ?? 0
                            
                            withAnimation {
                                if passNumber == 1 {
                                    self.progressPass1 = percent / 100.0
                                } else {
                                    // If pass 2 starts, ensure pass 1 is visually full
                                    self.progressPass1 = 1.0
                                    self.progressPass2 = percent / 100.0
                                }
                            }
                        }
                    }
                }
            }
            
            do {
                try process.run()
                process.waitUntilExit()
                
                // cleanup
                outputHandle.readabilityHandler = nil
                
                Task { @MainActor in
                    self.isCompressing = false
                    self.isFinished = true
                    // Ensure bars are full at the end
                    self.progressPass1 = 1.0
                    self.progressPass2 = 1.0
                }
            } catch {
                print("Failed to run script: \(error)")
                Task { @MainActor in
                    self.isCompressing = false
                }
            }
        }
    }
}
