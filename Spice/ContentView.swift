//
//  ContentView.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Charts
import SwiftData
import TipKit

struct ContentView: View {
    @Environment(\.undoManager) var undoManager
    @AppStorage("checkUpdate") private var checkUpdate = true
    @Binding var document: SpiceDocument
    @Binding var cG: CanvasConfig
    @Binding var addComponent: Bool
    @Environment(\.openWindow) var openWindow
    let dotSize: CGFloat = 1.0
    @State var updateAvailable: Bool = false
    @State var selectedComponents: [Component] = []
    @State var orientationMode: Direction = .trailing
    @State var componentInfo: Bool = true
    @Binding var editionMode: String
    @Binding var exporting: Bool
    var favoriteLandmarkTip = RunSimulationTip()
    let example = Image("play")
    @State var showBottom: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                VStack {
                    Spacer()
                    Button {
                        showBottom.toggle()
                    } label: {
                        Image(showBottom ? "sidebar.bottom.close" : "sidebar.bottom.open")
                    }.buttonStyle(MenuButton(funcName: "GRAPH", alignment: .trailing))
                }.padding(10)
                .background(Color("CanvasBackground"))
                .zIndex(10.0)
                Divider()
                VSplitView {
                    GeometryReader { geometry in
                        ZStack(alignment: .topTrailing) {
                            CanvasView(geometry: geometry, cG: $cG, components: $document.components, wires: $document.wires, editionMode: $editionMode, orientationMode: $orientationMode, selectedComponents: $selectedComponents)
                                .gesture(
                                    MagnifyGesture()
                                        .onEnded { gesture in
                                            cG.zoom += cG.temporizedZoom
                                            cG.temporizedZoom = 0.0
                                        }
                                        .onChanged { gesture in
                                            let newZoom = gesture.magnification - 1.0
                                            if cG.zoom + newZoom > 0.70 && cG.zoom + newZoom < 2.5 {
                                                cG.temporizedZoom = newZoom
                                            }
                                        }
                                )
                            HStack(alignment: .top) {
                                SideBarView(editionMode: $editionMode, addComponent: $addComponent)
                                if addComponent {
                                    SearchView(isPresented: $addComponent, editionMode: $editionMode)
                                        .transition(.scale)
                                }
                                Spacer()
                            }.padding(20)
                        }.background(Color("ToolbarBackground"))
                    }.contextMenu {
                        VStack {
                            Button(action: {}) {
                                Text("Edit")
                            }
                            Button(role: .destructive, action: {}) {
                                Text("Delete")
                            }
                        }.background(Color("CanvasBackground"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if showBottom {
                        AnalysisView()
                    }
                }
            }
        }.task {
            if checkUpdate {
                updateAvailable = await checkForUpdate()
            }
        }
        .toolbar {
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
                }.buttonStyle(MenuButton(funcName: "ROTATE"))
            }
            ToolbarItemGroup(placement: .status) {
                Button {
                    if(cG.magnifying >= 1) {
                        cG.zoom -= 0.5
                    }
                } label: {
                    Label("ZOOM_OUT", image: "zoom.out")
                }.buttonStyle(MenuButton(funcName: "ZOOM_OUT", command: "⌘-"))
                .keyboardShortcut("-")
                Text("\(Int((cG.magnifying-0.5)*100))%")
                    .frame(width: 45)
                Button {
                    if(cG.magnifying <= 2.5) {
                        cG.zoom += 0.5
                    }
                } label: {
                    Label("ZOOM_IN", image: "zoom.in")
                }.buttonStyle(MenuButton(funcName: "ZOOM_IN", command: "⌘+"))
                .keyboardShortcut("1", modifiers: [.shift, .command])
                Button {
                    cG.position = CGPoint.zero
                    cG.zoom = 1.5
                    cG.temporizedZoom = 0.0
                } label: {
                    Label("FOCUS", image: "focus")
                }.buttonStyle(MenuButton(funcName: "FOCUS", command: "SPACE"))
                .keyboardShortcut(" ", modifiers: [])
                Spacer()
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    cG.running.toggle()
                } label: {
                    Label("RUN", image: cG.running ? "pause" : "play")
                }.popoverTip(favoriteLandmarkTip)
                .foregroundStyle(cG.running ? Color("DarkerRed") : Color("StartColor"))
                .buttonStyle(MenuButton(funcName: cG.running ? "STOP" : "RUN", command: "⌘R"))
                Spacer()
                ShareLink(item: example, preview: SharePreview("", image: example)) {
                    Label("SHARE", image: "share")
                }.buttonStyle(MenuButton(funcName: "SHARE"))
                Button {
                    openWindow(id: "settings")
                } label: {
                    Label("SETTINGS", image: "gear")
                }.popoverTip(favoriteLandmarkTip)
                .buttonStyle(MenuButton(funcName: "SETTINGS", command: "⌘,", alignment: .bottomTrailing))
            }
        }.toolbarRole(.editor)
        .toolbarBackground(Color("ToolbarBackground"))
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
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

/*
struct TappableView: NSViewRepresentable {
    
    func updateNSView(_ nsView: NSView, context: Context) {}
    
    var tapCallback: (NSClickGestureRecognizer) -> Void

    typealias UIViewType = NSView

    func makeCoordinator() -> TappableView.Coordinator {
        Coordinator(tapCallback: self.tapCallback)
    }

    func makeNSView(context: NSViewRepresentableContext<TappableView>) -> NSView {
        let view = NSView()
        let doubleTapGestureRecognizer = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:)))
        doubleTapGestureRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        return view
    }

    class Coordinator {
        var tapCallback: (NSClickGestureRecognizer) -> Void

        init(tapCallback: @escaping (NSClickGestureRecognizer) -> Void) {
            self.tapCallback = tapCallback
        }

        @objc func handleTap(sender: NSClickGestureRecognizer) {
            self.tapCallback(sender)
        }
    }
}*/
