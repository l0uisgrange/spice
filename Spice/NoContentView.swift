//
//  NoContentView.swift
//  Spice
//
//  Created by Louis Grange on 23.09.2023.
//

import SwiftUI

struct NoContentView: View {
    @Binding var fileSelector: Bool
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 10) {
                Image(systemName: "folder")
                    .font(.system(size: 30))
                    .imageScale(.large)
                    .foregroundStyle(.gray.opacity(0.4))
                Text("NO_FILE_SELECTED")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .fontWeight(.medium)
                Text("NO_FILE_SELECTED_MESSAGE")
                    .foregroundStyle(.secondary)
                Button {
                    fileSelector.toggle()
                } label: {
                    Text("SELECT_FILE")
                }.buttonStyle(.bordered)
                .controlSize(.extraLarge)
                .padding(.top, 20)
            }
            Spacer()
        }
    }
}
