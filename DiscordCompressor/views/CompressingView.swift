//
//  CompressingView.swift
//  DiscordCompressor
//
//  Created by Quenting on 30/12/2025.
//

import SwiftUI

struct CompressingView: View {
    @StateObject private var vm = CompressionViewModel()
    
    var video = MainViewModel.instance.video;
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Thumbnail
            if let image = video!.thumbnail {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 300, height: 200)
                    .overlay(Text("No Thumbnail"))
            }
            
            Spacer()
            
            // Progress Section
            VStack(alignment: .leading, spacing: 8) {
                Text("First pass")
                    .font(.headline)
                ProgressBar(progress: vm.progressPass1, color: .blue)
                
                Text("Second pass")
                    .font(.headline)
                ProgressBar(progress: vm.progressPass2, color: .green)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            if fileExists(f) {
                Button(action: backHome) {
                    Text("Done !")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .transition(.scale)
                }
            } else if vm.isCompressing {
                Text("Compressing...")
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .frame(minWidth: 400, minHeight: 500)
        .onAppear {
            // Start compression when view appears
            vm.compress(video: video!)
        }
    }
    
    func backHome() {
        MainViewModel.instance.progressState()
    }
}

// Reusable Progress Component
struct ProgressBar: View {
    var progress: Double // 0.0 to 1.0
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background Track
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundStyle(Color.gray)
                
                // Filling Bar
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: 10)
                    .foregroundStyle(color)
                    .animation(.linear, value: progress)
            }
        }
        .frame(height: 10)
    }
}
