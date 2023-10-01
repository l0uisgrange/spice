//
//  SearchView.swift
//  Spice
//
//  Created by Louis Grange on 01.10.2023.
//

import SwiftUI

struct SearchView: View {
    @Binding var isPresented: Bool
    @State var searchText: String = ""
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            VStack {
                TextField("SEARCH_COMPONENT", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .controlSize(.extraLarge)
                    .tint(.accentColor)
                ContentUnavailableView("NO_RESULT", systemImage: "magnifyingglass", description: Text("NO_RESULT_DESCRIPTION"))
                    .padding(.vertical, 30)
            }.padding(20)
            Divider()
            HStack {
                Link(destination: URL(string: "https://github.com/l0uisgrange/spice/wiki")!) {
                    Text("NEED_HELP?")
                }.buttonStyle(.link)
                .tint(.accentColor)
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Text("CANCEL")
                }.buttonStyle(.bordered)
                .controlSize(.extraLarge)
                Button {
                    isPresented.toggle()
                } label: {
                    Text("ADD")
                }.buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
            }.padding(15)
        }.frame(width: 500)
        .background(.windowBackground)
    }
}

extension NSTextField {
        open override var focusRingType: NSFocusRingType {
                get { .none }
                set { }
        }
}
