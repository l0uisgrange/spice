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
    
    var components: [CircuitComponent] = []
    
    init(components: [CircuitComponent]) {
        self.components = components
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let text = String(decoding: data, as: UTF8.self)
            let linesFile = text.components(separatedBy: "\n")
            for line in linesFile {
                let lineDataset = line.components(separatedBy: " ")
                if(lineDataset.contains("*") || lineDataset.count < 5) {
                    continue
                }
                let newComponent = CircuitComponent(
                    lineDataset[0],
                    position: CGPoint(x: Int(Double(lineDataset[1])!), y: Int(Double(lineDataset[2])!)),
                    orientation: orientationDecoder(lineDataset[3]),
                    type: lineDataset[0].components(separatedBy: "").first ?? "W",
                    value: lineDataset.count > 4 ? Double(lineDataset[4]) ?? 0.0 : 0.0)
                components.append(newComponent)
            }
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var fileContent: String = "* Data statements\n"
        for c in components {
            let thisLine: String = "\(c.name) \(c.position.x) \(c.position.y) \(orientationEncoder(c.orientation)) \(c.value)\n"
            fileContent += thisLine
        }
        return FileWrapper(regularFileWithContents: Data(fileContent.utf8))
    }
}

func orientationDecoder(_ orientation: String) -> Direction {
    switch orientation {
    case "L":
        return .leading
    case "T":
        return .top
    case "B":
        return .bottom
    default:
        return .trailing
    }
}

func orientationEncoder(_ orientation: Direction) -> String {
    switch orientation {
    case .leading:
        return "L"
    case .top:
        return "T"
    case .bottom:
        return "B"
    default:
        return "X"
    }
}
