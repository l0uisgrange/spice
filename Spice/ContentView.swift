//
//  ContentView.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
    @Environment(\.undoManager) var undoManager
    @AppStorage("checkUpdate") private var checkUpdate = true
    @Binding var document: SpiceDocument
    @Binding var zoom: Double
    @Binding var addComponent: Bool
    @State private var origin: CGPoint = CGPoint.zero
    let dotSize: CGFloat = 1.0
    @State var updateAvailable: Bool = false
    @State var orientationMode: Direction = .trailing
    @Binding var editionMode: String
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    CanvasView(geometry: geometry, origin: $origin, zoom: $zoom, components: $document.components, wires: $document.wires, editionMode: $editionMode, orientationMode: $orientationMode)
                        .task {
                            if checkUpdate {
                                updateAvailable = await checkForUpdate()
                            }
                        }
                    HStack(alignment: .top) {
                        VStack {
                            Button {
                                editionMode = ""
                            } label: {
                                Image("cursor")
                            }.padding(3)
                            .background(editionMode == "" ? .white.opacity(0.2) : .white.opacity(0))
                            .buttonStyle(.plain)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            Button {
                                editionMode = "."
                            } label: {
                                Image("cursor.select")
                            }.padding(3)
                            .background(editionMode == "." ? .white.opacity(0.2) : .white.opacity(0))
                            .buttonStyle(.plain)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            Button {
                                editionMode = "W"
                            } label: {
                                Image("line")
                            }.padding(3)
                            .background(editionMode == "W" ? .white.opacity(0.2) : .white.opacity(0))
                            .buttonStyle(.plain)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            Divider().frame(width: 25).padding(.vertical, 2)
                            Button {
                                addComponent.toggle()
                            } label: {
                                Image("blocks")
                            }.padding(3)
                            .buttonStyle(.plain)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                        }.padding(6)
                        .background(Color("AccentDark"))
                        .foregroundStyle(Color("CanvasBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                        Spacer()
                        if updateAvailable {
                            Link(destination: URL(string: "https://github.com/l0uisgrange/spice/releases/latest")!) {
                                Label("UPDATE_AVAILABLE", systemImage: "arrow.down.circle.fill")
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .background(.black.opacity(0.8))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }.padding(20)
                }
            }
        }.toolbar {
            ToolbarItemGroup(placement: .principal) {
                Button {
                    switch orientationMode {
                    case .bottom:
                        orientationMode = .trailing
                    case .top:
                        orientationMode = .leading
                    case .leading:
                        orientationMode = .bottom
                    default:
                        orientationMode = .top
                    }
                } label: {
                    Label("ROTATE", image: "rotate.backwards")
                }
            }
            ToolbarItemGroup(placement: .status) {
                Button {
                    if(zoom >= 1) {
                        zoom -= 0.5
                    }
                } label: {
                    Label("ZOOM_OUT", image: "zoom.out")
                }.help("ZOOM_OUT")
                Button {
                    if(zoom <= 2.5) {
                        zoom += 0.5
                    }
                } label: {
                    Label("ZOOM_IN", image: "zoom.in")
                }.help("ZOOM_IN")
                Button {
                    origin = CGPoint.zero
                    zoom = 1.5
                } label: {
                    Label("FOCUS", image: "focus")
                }.help("FOCUS")
                Spacer()
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    
                } label: {
                    Label("SHARE", image: "share")
                }.help("SHARE")
                Button {
                    
                } label: {
                    Label("RUN", image: "lightning")
                }.help("RUN")
                .disabled(true)
            }
        }.toolbarRole(.editor)
        .toolbarBackground(Color("ToolbarBackground"))
    }
}

func checkForUpdate() async -> Bool {
    let url = URL(string: "https://api.github.com/repos/l0uisgrange/spice/releases/latest")!
    let current = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let resp = try? JSONDecoder().decode(Release.self, from: data) {
            if resp.tag_name != "v\(String(describing: current))" && resp.tag_name.count > 0 {
                return true
            }
        }
    } catch {
        print("Invalid data")
    }
    return false
}

struct Release: Decodable {
  let tag_name: String
}
