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
    @State private var fileSelector: Bool = false
    @State private var isPresented: Bool = false
    @State private var showingAlert: Bool = false
    @State var openedFile: [URL] = []
    @State var hover: Bool = false
    var body: some Scene {
        WindowGroup {
            ContentView(file: $openedFile, fileSelector: $fileSelector)
                .frame(minWidth: 500, idealWidth: 600, minHeight: 400, idealHeight: 550)
                .fileImporter(isPresented: $fileSelector, allowedContentTypes: [UTType(exportedAs: "com.louisgrange.spice", conformingTo: .text)], allowsMultipleSelection: false) { result in
                    switch result {
                    case .success(let file):
                        openedFile = file
                    case .failure(let error):
                        print(error.localizedDescription)
                        showingAlert.toggle()
                    }
                }
                .alert("FILE_ERROR_TITLE", isPresented: $showingAlert) {
                    Button("FILE_ERROR_BUTTON", role: .cancel) { }
                } message: {
                    Text("FILE_ERROR_MESSAGE")
                }
                .sheet(isPresented: $isPresented) {
                    OnBoardingView(isPresented: $isPresented)
                }
                .onAppear {
                    if symbolsStyle == 0 {
                        isPresented.toggle()
                    }
                }
        }.commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Divider()
                Button("MENU_SAVE") {
                    print("Saved!")
                }.keyboardShortcut("S")
                Button("MENU_OPEN") {
                    fileSelector.toggle()
                }.keyboardShortcut("O")
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
                switch lineDataset[0] {
                case "W":
                    var points: [CGPoint] = []
                    for i in 4..<lineDataset.count-1 {
                        if i%2 == 0 {
                            let newPoint = CGPoint(x: Double(lineDataset[i]) ?? 0, y: Double(lineDataset[i+1]) ?? 0)
                            points.append(newPoint)
                            print(newPoint)
                        }
                    }
                default:
                    print("Nope")
                }
            }
        } catch let error {
            showingAlert.toggle()
            print(error)
        }
    }
}
