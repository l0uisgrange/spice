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
                if(lineDataset.contains("*") || lineDataset.count < 8) {
                    continue
                }
                let newComponent = CircuitComponent(
                    lineDataset[0],
                    color: Color(
                        red: Double(lineDataset[1])!,
                        green: Double(lineDataset[2])!,
                        blue: Double(lineDataset[3])!),
                    start: CGPoint(x: Int(Double(lineDataset[4])!), y: Int(Double(lineDataset[5])!)),
                    end: CGPoint(x: Int(Double(lineDataset[6])!), y: Int(Double(lineDataset[7])!)),
                    type: lineDataset[0].components(separatedBy: "").first ?? "W",
                    value: lineDataset.count > 8 ? Double(lineDataset[8]) ?? 0.0 : 0.0)
                print("\(newComponent.type) : \(newComponent.startingPoint)->\(newComponent.endingPoint)")
                components.append(newComponent)
            }
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var fileContent: String = "* Data statements\n"
        for c in components {
            let colorComponents = c.color.resolve(in: EnvironmentValues())
            let thisLine: String = "\(c.name) \(colorComponents.red) \(colorComponents.green) \(colorComponents.blue) \(c.startingPoint.x) \(c.startingPoint.y) \(c.endingPoint.x) \(c.endingPoint.y) \(c.value)\n"
            fileContent += thisLine
        }
        return FileWrapper(regularFileWithContents: Data(fileContent.utf8))
    }
}
