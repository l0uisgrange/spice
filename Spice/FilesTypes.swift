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
    static var readableContentTypes: [UTType] = [.spice]
    
    var text = ""
    var components: [CircuitComponent] = []
    
    init(text: String) {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
            let linesFile = text.components(separatedBy: "\n")
            for line in linesFile {
                let lineDataset = line.components(separatedBy: " ")
                if(lineDataset.contains("*") || lineDataset.count < 4) {
                    continue
                }
                let newComponent = CircuitComponent(
                    lineDataset[0],
                    color: Color(
                        red: Double(lineDataset[1])!,
                        green: Double(lineDataset[2])!,
                        blue: Double(lineDataset[3])!),
                    start: CGPoint(x: Int(lineDataset[4])!, y: Int(lineDataset[5])!),
                    end: CGPoint(x: Int(lineDataset[6])!, y: Int(lineDataset[7])!),
                    type: lineDataset[0].components(separatedBy: "").first ?? "W",
                    value: lineDataset.count > 8 ? Double(lineDataset[8]) ?? 0.0 : 0.0)
                print("\(newComponent.type) : \(newComponent.startingPoint)->\(newComponent.endingPoint)")
                components.append(newComponent)
            }
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}
