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
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @AppStorage("gridStyle") private var gridStyle = 1
    let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            Form {
                Section {
                    LabeledContent("VERSION") {
                        HStack {
                            Text("\(appVersion) (\(appBuild))")
                            if Int(appVersion.components(separatedBy: ".").first ?? "0") == 0 {
                                Text("alpha")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 7)
                                    .overlay(
                                        Capsule()
                                            .stroke(.orange, lineWidth: 0.9)
                                    )
                            }
                        }
                    }
                    Toggle(isOn: $checkUpdate, label: {
                        Text("CHECK_UPDATE_AUTOMATICALLY")
                    }).tint(Color("AccentColor"))
                } footer: {
                    Text("UPDATE_FOOTER")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Section {
                    Picker("COMPONENTS_APPEARANCE", selection: $symbolsStyle) {
                        ForEach(SymbolStyle.allCases, id: \.self) { option in
                            Text(LocalizedStringKey(option.rawValue))
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
            .background(Color("CanvasBackground"))
            .scrollContentBackground(.hidden)
            .navigationTitle("SETTINGS")
            .toolbar {
                ToolbarItem {
                    Link(destination: URL(string: "https://github.com/l0uisgrange/spice")!) {
                        Label("GitHub", image: "github")
                    }.buttonStyle(.borderedProminent)
                }
            }.toolbarRole(.automatic)
                .toolbarBackground(Color("ToolbarBackground"))
        }
    }
}
