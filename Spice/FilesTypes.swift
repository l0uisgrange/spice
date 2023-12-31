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
    static var writableContentTypes: [UTType] = [.spice, .pdf]
    
    var text: String = ""
    var components: [Component] = []
    var wires: [Wire] = []
    
    init(components: [Component], wires: [Wire]) {
        self.components = components
        self.wires = wires
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let text = String(decoding: data, as: UTF8.self)
            self.text = text
            let fileLines = text.components(separatedBy: "\n")
            for line in fileLines {
                let lineDataset = line.components(separatedBy: " ")
                guard line.count >= 1 else { continue }
                switch lineDataset.first {
                case "*":
                    continue
                case "W":
                    guard lineDataset.count == 5 
                    else {
                        throw CocoaError(.fileReadCorruptFile)
                    }
                    let start = CGPoint(x: Double(lineDataset[1])!, y: Double(lineDataset[2])!)
                    let end = CGPoint(x: Double(lineDataset[3])!, y: Double(lineDataset[4])!)
                    wires.append(Wire(start, end))
                default:
                    guard lineDataset.count >= 5
                    else {
                        throw CocoaError(.fileReadCorruptFile)
                    }
                    let newComponent = Component(
                        lineDataset[0],
                        position: CGPoint(x: Double(lineDataset[1])!, y: Double(lineDataset[2])!),
                        orientation: orientationDecoder(lineDataset[3]),
                        type: lineDataset[0].components(separatedBy: "").first ?? "-",
                        value: Double(lineDataset[4]) ?? 0.0)
                    components.append(newComponent)
                }
            }
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var fileContent: String = ""
        if configuration.contentType == .pdf {
            fileContent += "* Wires\n"
            for w in wires {
                fileContent += "W \(w.start.x) \(w.start.y) \(w.end.x) \(w.end.y)\n"
            }
            fileContent += "* Components\n"
            for c in components {
                let thisLine: String = "\(c.type) \(c.position.x) \(c.position.y) \(orientationEncoder(c.orientation)) \(c.value)\n"
                fileContent += thisLine
            }
            return FileWrapper(regularFileWithContents: Data(fileContent.utf8))
        } else if configuration.contentType == .spice {
            fileContent += "* Wires\n"
            for w in wires {
                fileContent += "W \(w.start.x) \(w.start.y) \(w.end.x) \(w.end.y)\n"
            }
            fileContent += "* Components\n"
            for c in components {
                let thisLine: String = "\(c.name) \(c.position.x) \(c.position.y) \(orientationEncoder(c.orientation)) \(c.value)\n"
                fileContent += thisLine
            }
            return FileWrapper(regularFileWithContents: Data(fileContent.utf8))
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
