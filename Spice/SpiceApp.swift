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
    @State var editionMode: String = ""
    var body: some Scene {
        DocumentGroup(newDocument: SpiceDocument(components: [], wires: [])) { file in
            ContentView(document: file.$document, zoom: $zoom, addComponent: $searchComponent, editionMode: $editionMode)
                .frame(minWidth: 700, idealWidth: 900, minHeight: 500, idealHeight: 700)
                .sheet(isPresented: $searchComponent) {
                    SearchView(isPresented: $searchComponent, editionMode: $editionMode)
                }
                .sheet(isPresented: $isPresented) {
                    OnBoardingView(isPresented: $isPresented)
                }
                .onAppear {
                    if !onBoarded {
                        isPresented.toggle()
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
                        Text(String(describing: option))
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
                    searchComponent.toggle()
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
        }
        Window("SETTINGS", id: "settings") {
            SettingsView()
                .frame(width: 500, height: 300)
        }.defaultPosition(.center)
    }
}

enum SymbolStyle: String, CaseIterable {
    case ANSI_IEEE
    case IEC
}
