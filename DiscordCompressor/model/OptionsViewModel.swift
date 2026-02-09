//
//  OptionsViewModel.swift
//  DiscordCompressor
//
//  Created by Quenting on 09/02/2026.
//

import SwiftUI
import Combine

@MainActor
class OptionsViewModel: ObservableObject {
    @Published var fileAlreadyExists: Bool = false;
    
    @Published var isSizePopover = false
    @Published var target: Int = 8 {
        didSet {
            updateFileAlreadyExists()
        }
    }
    
    var video = MainViewModel.instance.video;
    
    var canCompress: Bool {
        return !self.fileAlreadyExists
    }
    
    func updateFileAlreadyExists() {
        self.fileAlreadyExists = getPathWithMBURL(video: video!, mb: target).exists
    }
    
    init() {
        updateFileAlreadyExists()
    }
}
