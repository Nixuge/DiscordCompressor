//
//  URLExtension.swift
//  DiscordCompressor
//
//  Created by Quenting on 09/02/2026.
//

import SwiftUI

// Source - https://stackoverflow.com/a/48566887
// Posted by gheclipse, modified by community. See post 'Timeline' for change history
// Retrieved 2026-02-09, License - CC BY-SA 4.0

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
    
    var exists: Bool {
        return FileManager.default.fileExists(atPath: path);
    }
}
