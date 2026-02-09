//
//  ContentView.swift
//  DiscordCompressor
//
//  Created by Quenting on 30/12/2025.
//


import SwiftUI

struct ContentView: View {
    @ObservedObject var mainViewModel = MainViewModel.instance;
    
    var body: some View {
        if (mainViewModel.state == .idle) {
            ChoosingView()
        } else if (mainViewModel.state == .options) {
           OptionsView()
        } else if (mainViewModel.state == .compressing) {
            CompressingView()
        }
    }
}
