//
//  GeneralSettingsView.swift
//  Spice
//
//  Created by Louis Grange on 22.09.2023.
//

import SwiftUI

struct GeneralSettingsView: View {
    @State private var deviceName: String = "false"
    @State private var isWifiEnabled: Bool = false
    @AppStorage("symbolsStyle") private var symbolsStyle = 2
    var body: some View {
        Form {
            Picker("COMPONENTS_APPEARANCE", selection: $symbolsStyle) {
                ForEach(0..<2) { option in
                    Text(option == 0 ? "US_STYLE" : "EU_STYLE")
                }
            }
        }.formStyle(.grouped)
    }
}
