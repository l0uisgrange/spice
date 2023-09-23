//
//  SettingsView.swift
//  Spice
//
//  Created by Louis Grange on 22.09.2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var deviceName: String = "false"
    @State private var isWifiEnabled: Bool = false
    @AppStorage("symbolsStyle") private var symbolsStyle = 2
    @AppStorage("gridStyle") private var gridStyle = 1
    var body: some View {
        Form {
            Picker("COMPONENTS_APPEARANCE", selection: $symbolsStyle) {
                ForEach(0..<2) { option in
                    Text(option == 0 ? "US_STYLE" : "EU_STYLE")
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
        }.formStyle(.grouped)
    }
}
