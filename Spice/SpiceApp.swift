//
//  SpiceApp.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData

@main
struct SpiceApp: App {
    @State private var fileImporter: Bool = false
    @State private var configuration: Bool = true
    @State private var showingAlert: Bool = false
    @State var lines: [Line] = []
    var body: some Scene {
        WindowGroup {
            ContentView(lines: $lines)
                .frame(minWidth: 500, idealWidth: 600, minHeight: 400, idealHeight: 550)
                .fileImporter(isPresented: $fileImporter, allowedContentTypes: [.text], allowsMultipleSelection: false) { result in
                    switch result {
                    case .success(let file):
                        interpretFile(file)
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
                .sheet(isPresented: $configuration) {
                    VStack(alignment: .center) {
                        Text("ONBOARDING_TITLE")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                         Text("ONBOARDING_MESSAGE")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        Button {
                            self.configuration.toggle();
                        } label: {
                            Text("ONBOARDING_BUTTON")
                        }.buttonStyle(.borderedProminent)
                        .controlSize(.extraLarge)
                        .padding(.top, 30)
                    }.padding(40)
                }
        }.commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Button("Save") {
                    print("Saved!")
                }.keyboardShortcut("S")
                Button("Open") {
                    fileImporter.toggle()
                }.keyboardShortcut("O")
            }
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
                case "0":
                    var points: [Point] = []
                    for i in 1..<lineDataset.count-1 {
                        if i%2 != 0 {
                            points.append(Point(x: Int(lineDataset[i]) ?? 0, y: Int(lineDataset[i+1]) ?? 0))
                        }
                    }
                    let newLine = Line(points: points)
                    lines.append(newLine)
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
