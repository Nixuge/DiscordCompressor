//
//  ViewModel.swift
//  DiscordCompressor
//
//  Created by Quenting on 09/02/2026.
//

import SwiftUI

enum AppState {
    case idle
    case options
    case compressing
}

struct CompressingOptions {
    var targetMB: Int
}

@MainActor
class MainViewModel: ObservableObject {
    static var instance = MainViewModel()
    
    @Published var state: AppState = .idle
    @Published var video: ChoosenVideo?
    var options: CompressingOptions?
    
    func reset() {
        state = .idle
        video = nil
        options = nil
    }
    
    func progressState() {
        switch state {
        case .idle:
            state = .options;
        case .options:
            state = .compressing;
        case .compressing:
            self.reset()
        }
    }
}
