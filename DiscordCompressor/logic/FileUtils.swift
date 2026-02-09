//
//  FileUtils.swift
//  DiscordCompressor
//
//  Created by Quenting on 09/02/2026.
//

import SwiftUI

func getPathWithMB(video: ChoosenVideo, mb: Int) -> String {
    let basePath = video.path.deletingPathExtension().path

    //let fileExt = video.path.pathExtension
    //let newFilePath = "\(basePath)-\(mb)MB.\(fileExt)"
    
    let newFilePath = "\(basePath)-\(mb)MB.mp4"
    
    return newFilePath;
}

func getPathWithMBURL(video: ChoosenVideo, mb: Int) -> URL {
    return URL(string: getPathWithMB(video: video, mb: mb))!
}

func deleteFile(filePath: String) {
    do {
        try FileManager.default.removeItem(atPath: filePath)
        debugPrint("deleteFile : \(filePath).")
    } catch {
        debugPrint("deleteFile : \(error)")
    }
}

func getFileSize(filePath: String) -> UInt64 {
    // Source - https://stackoverflow.com/a/28268658
    // Posted by Duyen-Hoa, modified by community. See post 'Timeline' for change history
    // Retrieved 2026-02-09, License - CC BY-SA 3.0

    var fileSize : UInt64 = 0;

    do {
        //return [FileAttributeKey : Any]
        let attr = try FileManager.default.attributesOfItem(atPath: filePath)
        fileSize = attr[FileAttributeKey.size] as! UInt64

        //if you convert to NSDictionary, you can get file size old way as well.
        let dict = attr as NSDictionary
        fileSize = dict.fileSize()
    } catch {
        print("Error: \(error)")
    }
    
    return fileSize
}

