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
    @Binding var editionMode: String
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    CanvasView(geometry: geometry, origin: $origin, zoom: $zoom, components: $document.components, editionMode: $editionMode)
                        .task {
                            if checkUpdate {
                                updateAvailable = await checkForUpdate()
                            }
                        }
                    HStack {
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
                Picker("", selection: $editionMode) {
                    Label("ERASE", systemImage: "hand.point.up").tag("")
                    Label("WIRE", systemImage: "line.diagonal").tag("W")
                }.pickerStyle(SegmentedPickerStyle())
                Button {
                    addComponent.toggle()
                } label: {
                    Label("", systemImage: "plus")
                }
                Spacer().frame(width: 20)
            }
            ToolbarItemGroup(placement: .status) {
                Button {
                    if(zoom >= 1) {
                        zoom -= 0.5
                    }
                } label: {
                    Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                }.help("ZOOM_OUT")
                Button {
                    if(zoom <= 2.5) {
                        zoom += 0.5
                    }
                } label: {
                    Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                }.help("ZOOM_IN")
                Button {
                    origin = CGPoint.zero
                    zoom = 1.5
                } label: {
                    Label("FOCUS", systemImage: "viewfinder")
                }.help("FOCUS")
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                Button {
                    
                } label: {
                    Label("RUN", systemImage: "play.circle.fill")
                }.help("RUN")
                .disabled(true)
            }
        }
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
