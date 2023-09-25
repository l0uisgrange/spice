//
//  FilesTypes.swift
//  Spice
//
//  Created by Louis Grange on 25.09.2023.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let spice = UTType(exportedAs: "com.louisgrange.spice")
}

struct SpiceDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.spice]
    }
    
    var text = ""
    
    init(text: String) {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            text = ""
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}
