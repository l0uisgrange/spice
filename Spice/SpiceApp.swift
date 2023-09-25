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
    @State var editionMode: EditionMode = .cursor
    var body: some Scene {
        DocumentGroup(newDocument: SpiceDocument(text: "* Data statements")) { file in
            ContentView(document: file.$document, zoom: $zoom, editionMode: $editionMode)
                .frame(minWidth: 500, idealWidth: 600, minHeight: 400, idealHeight: 550)
                .sheet(isPresented: $isPresented) {
                    OnBoardingView(isPresented: $isPresented)
                }
                .onAppear {
                    if symbolsStyle == 0 {
                        isPresented.toggle()
                    }
                }
                .navigationSubtitle("LAST SAVE \(lastDate(url: file.fileURL!).timeAgoDisplay())")
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
}

func lastDate(url: URL) -> Date {
    do {
        let attr = try FileManager.default.attributesOfItem(atPath: url.path)
        return attr[FileAttributeKey.modificationDate] as! Date
    } catch {
        return Date.distantPast
    }
}

enum EditionMode {
    case cursor, wire, edit
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
