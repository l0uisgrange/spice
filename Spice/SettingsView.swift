//
//  SettingsView.swift
//  Spice
//
//  Created by Louis Grange on 22.09.2023.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("GENERAL_SETTINGS", destination: GeneralSettingsView())
            }
        } detail: {
            GeneralSettingsView()
        }.toolbar {
            Button {
                
            } label: {
                Label("fwef", systemImage: "line.diagonal")
            }
        }
    }
}
