//
//  SpiceApp.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import QuickLook

@main
struct SpiceApp: App {
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @AppStorage("gridStyle") private var gridStyle = 1
    @AppStorage("onBoarded") private var onBoarded = false
    @Environment(\.openWindow) var openWindow
    @State private var isPresented: Bool = false
    @State private var searchComponent: Bool = false
    @State var cG: CanvasConfig = CanvasConfig()
    @State var exporting: Bool = true
    @State var editionMode: String = ""
    @State private var document = SpiceDocument(components: [], wires: [])
    var body: some Scene {
        DocumentGroup(newDocument: SpiceDocument(components: [], wires: [])) { configuration in
            ContentView(document: configuration.$document, cG: $cG, addComponent: $searchComponent, editionMode: $editionMode, exporting: $exporting)
                .frame(minWidth: 700, idealWidth: 900, minHeight: 500, idealHeight: 700)
                .sheet(isPresented: $isPresented) {
                    OnBoardingView(isPresented: $isPresented)
                }
                .toolbarBackground(Color("ToolbarBackground"), for: .windowToolbar)
                .onAppear {
                    if !onBoarded {
                        isPresented.toggle()
                    }
                    NSWindow.allowsAutomaticWindowTabbing = false
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
                    cG.zoom += 0.5
                }.keyboardShortcut("1", modifiers: [.command, .shift])
                Button("ZOOM_OUT") {
                    cG.zoom -= 0.5
                }.keyboardShortcut("-", modifiers: [.command])
                Button("FOCUS") {
                    cG.zoom = 1.5
                    cG.temporizedZoom = 0.0
                    cG.position = CGPoint.zero
                }.keyboardShortcut(" ", modifiers: [])
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
                    cG.running.toggle()
                } label: {
                    Text(cG.running ? "STOP_SIMULATION" : "RUN_SIMULATION")
                }.keyboardShortcut("R")
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
                    self.exporting = true
                } label: {
                    Text("EXPORT_PDF")
                }
            }
            CommandGroup(replacing: .help) {
                Group {
                    Link("GITHUB_PAGE", destination: URL(
                        string: "https://github.com/l0uisgrange/spice")!)
                    Link("HELP_BEGIN", destination: URL(
                        string: "https://github.com/l0uisgrange/spice/wiki")!)
                }
                Divider()
                Group {
                    Link("REPORT_BUG", destination: URL(
                        string: "https://github.com/l0uisgrange/spice/issues/new/choose")!)
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
