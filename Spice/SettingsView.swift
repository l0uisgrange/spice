//
//  SettingsView.swift
//  Spice
//
//  Created by Louis Grange on 22.09.2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var deviceName: String = "false"
    @State private var updateAvailable: Bool = false
    @State private var checkedUpdate: Bool = false
    @AppStorage("checkUpdate") private var checkUpdate = true
    @AppStorage("symbolsStyle") private var symbolsStyle = 2
    @AppStorage("gridStyle") private var gridStyle = 1
    let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("VERSION")
                    Spacer()
                    Text("\(appVersion) (\(appBuild))")
                }
                Toggle(isOn: $checkUpdate, label: {
                    Text("CHECK_UPDATE_AUTOMATICALLY")
                })
                VStack(alignment: .leading) {
                    if updateAvailable {
                        Text("UPDATE_AVAILABLE")
                    } else {
                        Text("NO_UPDATE_AVAILABLE")
                    }
                    HStack {
                        Button {
                            Task {
                                updateAvailable = await checkForUpdate()
                            }
                            checkedUpdate = true
                        } label: {
                            Text("CHECK_UPDATE")
                        }.buttonStyle(.bordered)
                        .controlSize(.large)
                        .disabled(checkedUpdate)
                        if updateAvailable {
                            Link(destination: URL(string: "https://github.com/l0uisgrange/spice/releases/latest")!) {
                                Text("INSTALL_UPDATE")
                            }.buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                    }.padding(.top, 10)
                }
            }
            Section {
                Picker("COMPONENTS_APPEARANCE", selection: $symbolsStyle) {
                    ForEach(1..<3) { option in
                        Text(option == 1 ? "US_STYLE" : "EU_STYLE")
                            .tag(option)
                    }
                }
                Picker("GRID_APPEARANCE", selection: $gridStyle) {
                    Text("NONE")
                        .tag(0)
                    Text("DOTS")
                        .tag(1)
                    Text("GRID")
                        .tag(2)
                }
            }
        }.formStyle(.grouped)
        .navigationTitle("SETTINGS")
        .toolbar {
            ToolbarItem {
                Link(destination: URL(string: "https://github.com/l0uisgrange/spice")!) {
                    Label("GitHub", image: "GitHub")
                }.buttonStyle(.borderedProminent)
            }
        }
    }
}
