//
//  OptionsView.swift
//  DiscordCompressor
//
//  Created by Quenting on 09/02/2026.
//

import SwiftUI

struct OptionsView: View {
    @StateObject private var vm = OptionsViewModel()
    
    @State private var isPresentingConfirm: Bool = false

    
    var body: some View {
        ZStack {
            VStack {
                // TODO: popup that says to use a bit less than normal
                Text("Options")
                    .font(.title)
//                    .padding()
                
                
                HStack {
                    Text("Target size: ")
                    
                    Spacer()
                    TextField("Number Two", value: $vm.target, formatter: NumberFormatter())
                        .frame(width: 100)
                    
                    Stepper(value: $vm.target, in: 5...200) {
                        EmptyView()
                    }
                    
                    Button(action: {vm.isSizePopover.toggle()}) {
                        Label("", systemImage: "info.circle")
                    }.popover(isPresented: $vm.isSizePopover) {
                        Text("Note that this is passed straight to ffmpeg.\n\nUsually the resulting files are a bit bigger,\nso if you REALLY need something under eg 10MB,\nyou might want to use a value a bit lower like 8MB.").padding()
                    }
                }
                
                if (vm.fileAlreadyExists) {
                    VStack {
                        Spacer()
                        Text("Output file already exists")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .transition(.scale)
                        
                        
                        Button(action: {isPresentingConfirm = true}) {
                            Text("Delete existing file")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.red) // Unsure looks meh
                                .transition(.scale)
                        }
                        .confirmationDialog("Are you sure you want to delete this file?", isPresented: $isPresentingConfirm) {
                            Button("Yes I am", role: .destructive) {
                                deleteFile(filePath: getPathWithMB(video: vm.video!, mb: vm.target))
                                vm.updateFileAlreadyExists()
                            }
                        }
                        Spacer()
                        
                    }
                }
                
                
                Spacer()
                
                Button(action: ok) {
                    Text("Compress to ~\(vm.target)MB!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .transition(.scale)
                }.disabled(!vm.canCompress)
            }.padding(5)
            
            Button(action: back) {
                Text("Back")
                    .font(.title2)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }.padding(20)
    }
    
    func ok() {
        MainViewModel.instance.options = CompressingOptions(targetMB: vm.target)
        MainViewModel.instance.progressState()
    }
    func back() {
        MainViewModel.instance.state = .idle
    }
}
