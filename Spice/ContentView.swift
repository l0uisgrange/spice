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
    @State var selectedComponents: [Component] = []
    @State var orientationMode: Direction = .trailing
    @State var componentInfo: Bool = true
    @Binding var editionMode: String
    @Binding var exporting: Bool
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    CanvasView(geometry: geometry, origin: $origin, zoom: $zoom, components: $document.components, wires: $document.wires, editionMode: $editionMode, orientationMode: $orientationMode, selectedComponents: $selectedComponents)
                        .task {
                            if checkUpdate {
                                updateAvailable = await checkForUpdate()
                            }
                        }
                    HStack(alignment: .top) {
                        SideBarView(editionMode: $editionMode, addComponent: $addComponent)
                        if addComponent {
                            SearchView(isPresented: $addComponent, editionMode: $editionMode)
                                .transition(.scale(0.000001, anchor: .leading))
                        }
                        Spacer()
                    }.padding(20)
                }
            }
            .contextMenu {
                Button(action: {}) {
                    Text("Edit")
                }
                Button(role: .destructive, action: {}) {
                    Text("Delete")
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
                    exporting.toggle()
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
