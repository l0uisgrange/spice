//
//  ContentView.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("checkUpdate") private var checkUpdate = true
    @Binding var document: SpiceDocument
    @Binding var zoom: Double
    @State private var origin: CGPoint = CGPoint.zero
    let dotSize: CGFloat = 1.0
    @State var updateAvailable: Bool = false
    @Binding var editionMode: EditionMode
    @State var selectedColor = Color.black
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    CanvasView(geometry: geometry, selectedColor: $selectedColor, origin: $origin, zoom: $zoom, components: $document.components, editionMode: $editionMode)
                        .task {
                            if checkUpdate {
                                updateAvailable = await checkForUpdate()
                            }
                        }
                    if updateAvailable {
                        HStack(alignment: .top) {
                            Spacer()
                            Link(destination: URL(string: "https://github.com/l0uisgrange/spice/releases/latest")!) {
                                Label("UPDATE_AVAILABLE", systemImage: "arrow.down.circle.fill")
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .background(.black.opacity(0.8))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }.buttonStyle(PlainButtonStyle())
                        }.padding(20)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Spacer()
            }
            ToolbarItemGroup(placement: .principal) {
                Button {
                    
                } label: {
                    Label("CANCEL", systemImage: "arrow.uturn.backward")
                }
                .help("CANCEL")
                .disabled(true)
                Button {
                    
                } label: {
                    Label("UNDO", systemImage: "arrow.uturn.forward")
                }.help("UNDO")
                .disabled(true)
                HStack {
                    Divider().frame(height: 20)
                }
                Button {
                    editionMode = .cursor
                } label: {
                    Label("ERASE", systemImage: "cursorarrow")
                }.help("ERASE")
                Button {
                    editionMode = .wire
                } label: {
                    Label("WIRE", systemImage: "line.diagonal")
                }.help("WIRE")
                Spacer().frame(width: 20)
            }
            ToolbarItemGroup(placement: .status) {
                Button {
                    if(zoom >= 1) {
                        withAnimation(.bouncy) {
                            zoom -= 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                }.help("ZOOM_OUT")
                Button {
                    if(zoom <= 2.5) {
                        withAnimation(.bouncy) {
                            zoom += 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                }.help("ZOOM_IN")
                Button {
                    withAnimation(.bouncy) {
                        origin = CGPoint.zero
                        zoom = 1.5
                    }
                } label: {
                    Label("FOCUS", systemImage: "viewfinder")
                }.help("FOCUS")
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    
                } label: {
                    Label("RUN", systemImage: "play.circle")
                }.help("RUN")
                .disabled(true)
            }
        }.toolbarBackground(Color("CanvasBackground"))
    }
}

func checkForUpdate() async -> Bool {
    let url = URL(string: "https://api.github.com/repos/l0uisgrange/spice/releases/latest")!
    let current = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let resp = try? JSONDecoder().decode(Release.self, from: data) {
            if resp.tag_name != current && resp.tag_name.count > 0 {
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
