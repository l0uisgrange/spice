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
    @AppStorage("onBoarded") private var onBoarded = false
    @State private var isPresented: Bool = false
    @State var zoom: Double = 1.5
    @State var editionMode: EditionMode = .cursor
    var body: some Scene {
        DocumentGroup(newDocument: SpiceDocument(components: [])) { file in
            ContentView(document: file.$document, zoom: $zoom, editionMode: $editionMode)
                .frame(minWidth: 500, idealWidth: 600, minHeight: 400, idealHeight: 550)
                .sheet(isPresented: $isPresented) {
                    OnBoardingView(isPresented: $isPresented)
                }
                .onAppear {
                    if !onBoarded {
                        isPresented.toggle()
                    }
                }
        }
        .commands {
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
                .presentedWindowToolbarStyle(.unified)
        }.windowToolbarStyle(.unified)
    }
}

enum EditionMode {
    case cursor, wire, edit
}
