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
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @AppStorage("gridStyle") private var gridStyle = 1
    @AppStorage("onBoarded") private var onBoarded = false
    @Environment(\.openWindow) var openWindow
    @State private var isPresented: Bool = false
    @State private var searchComponent: Bool = false
    @State var zoom: Double = 1.5
    @State var exporting: Bool = false
    @State var editionMode: String = ""
    @State private var document = SpiceDocument(components: [], wires: [])
    var body: some Scene {
        DocumentGroup(newDocument: SpiceDocument(components: [], wires: [])) { file in
            ContentView(document: file.$document, zoom: $zoom, addComponent: $searchComponent, editionMode: $editionMode, exporting: $exporting)
                .frame(minWidth: 700, idealWidth: 900, minHeight: 500, idealHeight: 700)
                .sheet(isPresented: $isPresented) {
                    OnBoardingView(isPresented: $isPresented)
                }
                .onAppear {
                    if !onBoarded {
                        isPresented.toggle()
                    }
                }
                .fileExporter(
                    isPresented: $exporting,
                    document: document,
                    contentType: .pdf
                ) { result in
                    switch result {
                    case .success(let file):
                        print(file)
                        print("Hello world")
                    case .failure(let error):
                        print(error)
                    }
                }
        }.defaultPosition(.center)
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
                    ForEach(SymbolStyle.allCases, id: \.self) { option in
                        Text(LocalizedStringKey(option.rawValue))
                    }
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
            CommandGroup(after: CommandGroupPlacement.textEditing) {
                Button {
                    withAnimation(.snappy(duration: 0.2)) {
                        searchComponent.toggle()
                    }
                } label: {
                    Text("ADD_COMPONENT")
                }.keyboardShortcut(".")
                Button {
                    
                } label: {
                    Text("RUN_SIMULATION")
                }.keyboardShortcut("R")
                    .disabled(true)
            }
            CommandGroup(after: CommandGroupPlacement.appSettings) {
                Button {
                    openWindow(id: "settings")
                } label: {
                    Text("SETTINGS")
                }.keyboardShortcut(",")
            }
            CommandGroup(after: CommandGroupPlacement.importExport) {
                Button {
                    self.exporting.toggle()
                } label: {
                    Text("EXPORT_PDF")
                }
            }
        }
        Window("SETTINGS", id: "settings") {
            SettingsView()
        }.defaultPosition(.center)
    }
}

enum SymbolStyle: String, CaseIterable {
    case ANSI_IEEE
    case IEC
}
