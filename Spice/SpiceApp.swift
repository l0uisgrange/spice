//
//  SpiceApp.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct SpiceApp: App {
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    @AppStorage("gridStyle") private var gridStyle = 1
    @State private var isPresented: Bool = false
    @State var zoom: Double = 1.5
    @State var openedFile: [URL] = []
    @State var editionMode: EditionMode = .cursor
    @State var components: [CircuitComponent] = []
    var body: some Scene {
        DocumentGroup(newDocument: SpiceDocument(text: "* Data statements")) { configuration in
            ContentView(file: $openedFile, zoom: $zoom, editionMode: $editionMode, components: $components)
                .frame(minWidth: 500, idealWidth: 600, minHeight: 400, idealHeight: 550)
                .sheet(isPresented: $isPresented) {
                    OnBoardingView(isPresented: $isPresented)
                }
                .onAppear {
                    if symbolsStyle == 0 {
                        isPresented.toggle()
                    }
                }
        }.commands {
            CommandGroup(after: CommandGroupPlacement.toolbar) {
                Divider()
                Picker("BACKGROUND", selection: $gridStyle) {
                    Text("NONE")
                        .tag(0)
                    Text("DOTS")
                        .tag(1)
                    Text("GRID")
                        .tag(2)
                }
                Picker("COMPONENTS", selection: $symbolsStyle) {
                    Text("EU_STYLE")
                        .tag(1)
                    Text("US_STYLE")
                        .tag(2)
                }
                Divider()
                Button("ZOOM_IN") {
                    zoom += 0.5
                }
                Button("ZOOM_OUT") {
                    zoom -= 0.5
                }
                Divider()
            }
        }
        Settings {
            SettingsView()
        }
    }
    
    func interpretFile(_ file: [URL]) {
        do {
            // Get data from the file
            let file = try FileHandle(forReadingFrom: file[0])
            let data = file.readDataToEndOfFile()
            file.closeFile()
            // Get the lines from the data
            let string = String(decoding: data, as: UTF8.self)
            let linesFile = string.components(separatedBy: "\n")
            // Get the shapes from the lines
            for line in linesFile {
                let lineDataset = line.components(separatedBy: " ")
                if(lineDataset[0].contains("*")) {
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
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

enum EditionMode {
    case cursor, wire, edit
}
