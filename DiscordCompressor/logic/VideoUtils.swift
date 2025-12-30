//
//  Utils.swift
//  DiscordCompressor
//
//  Created by Quenting on 30/12/2025.
//

import Foundation
import AVFoundation

func getLatestVideo() -> URL? {
    let directoryURL = URL(fileURLWithPath: "/Users/nixuge/Documents/Records/")
    do {
        let records = try FileManager.default.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: []
        )

        let videoExtensions = ["mp4", "mov", "m4v"]
        let videoFiles = records.filter { url in
            videoExtensions.contains(url.pathExtension.lowercased())
        }
        
        let sortedFiles = videoFiles.sorted { a, b -> Bool in
            do {
                let aDate = try a.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate ?? Date.distantPast
                let bDate = try b.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate ?? Date.distantPast
                
                let aContainsMB = (a.lastPathComponent).contains(/-\d+MB/);
                let bContainsMB = (b.lastPathComponent).contains(/-\d+MB/);
                //print("Contains: \(a.lastPathComponent) \(aContainsMB), \(b.lastPathComponent) \(bContainsMB)")
                if ((aContainsMB || bContainsMB) && !(aContainsMB && bContainsMB)) {
                    return aContainsMB ? true : false;
                }
                
                return aDate > bDate
            } catch {
                return false
            }
        }

        
        return sortedFiles.first
    } catch {
        print("Error reading directory: \(error)")
        return nil
    }
}

// Source - https://stackoverflow.com/a
// Posted by David Seek, modified by community. See post 'Timeline' for change history
// Retrieved 2025-12-30, License - CC BY-SA 4.0

import SwiftUI

func generateThumbnail(path: URL) -> Image? {
    do {
        let asset = AVURLAsset(url: path, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        // TODO: uses smth not deprecated.
        let suiImage = Image(cgImage, scale: 1.0, label: Text(verbatim: "cc"));
        
        return suiImage;
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
}
