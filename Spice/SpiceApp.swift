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
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    @State private var fileImporter: Bool = false
    @State private var configuration: Bool = true
    @State private var showingAlert: Bool = false
    @State var lines: [Line] = []
    @State var hover: Bool = false
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
                        HStack(spacing: 20) {
                            AppearanceView(styleId: 0, styleName: "EU_STYLE")
                            AppearanceView(styleId: 1, styleName: "US_STYLE")
                        }.padding(.top, 20)
                        Button {
                            self.configuration.toggle();
                        } label: {
                            Text("ONBOARDING_BUTTON")
                        }.buttonStyle(.borderedProminent)
                        .controlSize(.extraLarge)
                        .padding(.top, 30)
                    }.padding(40)
                }
                .onHover { isHovered in
                    self.hover = isHovered
                    DispatchQueue.main.async {
                        if(self.hover) {
                            NSCursor.openHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                }
        }.commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Button("MENU_SAVE") {
                    print("Saved!")
                }.keyboardShortcut("S")
                Button("MENU_OPEN") {
                    fileImporter.toggle()
                }.keyboardShortcut("O")
            }
            CommandGroup(replacing: .appInfo) {
                Button("MENU_ABOUT") {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                                string: "OPEN_SOURCE_NOTICE",
                                attributes: [
                                    NSAttributedString.Key.font: NSFont.boldSystemFont(
                                        ofSize: NSFont.smallSystemFontSize)
                                ]
                            ),
                            NSApplication.AboutPanelOptionKey(
                                rawValue: "Copyright"
                            ): "MADE_BY"
                        ]
                    )
                }
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

struct AppearanceView: View {
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    var styleId: Int
    var styleName: String
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Canvas { context, size in
                    context.translateBy(x: 75, y: 50)
                    if styleId == 1 {
                        context.stroke(
                            Path() { path in
                                path.move(to: CGPoint(x: -75, y: 0))
                                path.addLine(to: CGPoint(x: -30, y: 0))
                                path.addLine(to: CGPoint(x: -25, y: 13))
                                path.addLine(to: CGPoint(x: -15, y: -13))
                                path.addLine(to: CGPoint(x: -5, y: 13))
                                path.addLine(to: CGPoint(x: 5, y: -13))
                                path.addLine(to: CGPoint(x: 15, y: 13))
                                path.addLine(to: CGPoint(x: 25, y: -13))
                                path.addLine(to: CGPoint(x: 30, y: 0))
                                path.addLine(to: CGPoint(x: 75, y: 0))
                            },
                            with: .color(.primary),
                            lineWidth: 1.35)
                    } else {
                        context.stroke(
                            Path() { path in
                                path.move(to: CGPoint(x: -75, y: 0))
                                path.addLine(to: CGPoint(x: -30, y: 0))
                                path.addLine(to: CGPoint(x: -30, y: 13))
                                path.addLine(to: CGPoint(x: 30, y: 13))
                                path.addLine(to: CGPoint(x: 30, y: -13))
                                path.addLine(to: CGPoint(x: -30, y: -13))
                                path.addLine(to: CGPoint(x: -30, y: 0))
                                path.move(to: CGPoint(x: 30, y: 0))
                                path.addLine(to: CGPoint(x: 75, y: 0))
                            },
                            with: .color(.primary),
                            lineWidth: 1.35)
                    }
                }.frame(width: 150, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(symbolsStyle == styleId ? .blue : .secondary.opacity(0.5), lineWidth: symbolsStyle == styleId ? 2 : 0.5)
                )
            }.padding(.top, 5)
        }.onTapGesture {
            symbolsStyle = styleId
        }
    }
}
