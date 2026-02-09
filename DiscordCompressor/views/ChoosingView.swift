//
//  ChoosingView.swift
//  DiscordCompressor
//
//  Created by Quenting on 30/12/2025.
//

import SwiftUI

struct ChoosingView: View {
    @State private var dragOver = false
    @State private var latestVideo: ChoosenVideo? = nil;
    
    @State private var errorMessage: String? = nil;
    @State private var choosenVideo: ChoosenVideo? = nil;
    
    var video = MainViewModel.instance.video;
    
    var body: some View {
        ZStack {
            VStack {
                if (latestVideo != nil) {
                    VStack {
                        latestVideo!.thumbnail?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 200)
                        
                        Text(latestVideo!.path.lastPathComponent)
                        
                        Button(action: compressLatest) {
                            Text("Use latest recording")
                        }
                        
 
                    }.frame(width: 300, height: 250)
                }
                
                Spacer()
                Text("OR")
                Spacer()
                
                ZStack {
                    if (choosenVideo != nil) {
                        VStack {
                            choosenVideo!.thumbnail?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 200)
                            
                            Text(latestVideo!.path.lastPathComponent)
                            
                            Button(action: compressCurrent) {
                                Text("Use this video")
                            }
                            
     
                        }.frame(width: 300, height: 250)
                    } else {
                        Text(errorMessage == nil ? "drag and drop a video here" : errorMessage!)
                    }
                    
                    if (dragOver) {
                        RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                            .foregroundStyle(.black)
                    }
                }.frame(width: 300, height: 250)
                    .onDrop(of: [.fileURL], isTargeted: $dragOver) { providers -> Bool in
                        // TODO: Allow videos from drag n drop directly
                        providers.forEach { provider in
                            _ = provider.loadObject(ofClass: URL.self) { url, error in
                                if let url = url {
                                    choosenVideo = nil;
                                    if (!isVideo(url: url)) {
                                        errorMessage = "Not a video file !";
                                    } else {
                                        choosenVideo = getObject(path: url);
                                    }
                                }
                            }
                        }
                        return true
                    }
                

            }
            .padding()
            
        }
//        .frame(width: 300, height: 600, alignment: .center)
        
        .onAppear {
            self.latestVideo = getLatestVideo();
        }
    }
    
    func compressCurrent() {
        MainViewModel.instance.video = choosenVideo!;
        MainViewModel.instance.progressState()
    }
    func compressLatest() {
        MainViewModel.instance.video = latestVideo!;
        MainViewModel.instance.progressState()
    }
}
