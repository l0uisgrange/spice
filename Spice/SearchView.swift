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
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @State var typeSelected: ComponentType.ID?
    @Binding var editionMode: String
    enum FocusField: Hashable {
        case field
    }
    let components = [
        ComponentType("RESISTOR", type: "R"),
        ComponentType("INDUCTOR", type: "L"),
        ComponentType("CAPACITOR", type: "C"),
        ComponentType("DIODE", type: "D"),
        ComponentType("VSOURCE", type: "V"),
        ComponentType("ISOURCE", type: "I"),
        ComponentType("FUSE", type: "F"),
        ComponentType("ACVSOURCE", type: "A")
    ]
    @FocusState var isFocusOn: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("SEARCH_COMPONENT", text: $searchText)
                .focused($isFocusOn)
                .font(.title2)
                .textFieldStyle(.plain)
                .controlSize(.extraLarge)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .foregroundStyle(.black)
                .background(Color("CanvasBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .onSubmit {
                    editionMode = filteredComponents.first?.type ?? ""
                    isPresented.toggle()
                }
                .padding(.vertical, 6)
                .onAppear {
                    isFocusOn = true
                }
            Divider().padding(.bottom, 6)
            if filteredComponents.count == 0 {
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                        Image("search.x")
                        Text("NO_RESULT")
                    }
                    Spacer()
                }.padding(.vertical, 10)
            }
            ForEach(filteredComponents) { c in
                Button {
                    editionMode = c.type
                } label: {
                    HStack(alignment: .center, spacing: 15) {
                        Canvas { context, size in
                            let comp = Component("", position: .zero, orientation: .trailing, type: c.type, value: 0.0)
                            context.translateBy(x: 21, y: 15)
                            context.scaleBy(x: 0.7, y: 0.7)
                            comp.draw(context: context, zoom: 0.7, style: symbolsStyle, cursor: .zero, color: .white)
                        }.frame(width: 42, height: 30)
                        Text(c.name)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }.padding(.horizontal, 9)
                    .padding(.vertical, 0)
                }.buttonStyle(SearchViewItem())
            }
        }.frame(width: 220)
        .padding([.horizontal, .bottom], 6)
        .background(Color("AccentDark"))
        .foregroundStyle(Color("CanvasBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 9))
    }
    
    var filteredComponents: [ComponentType] {
        components.sorted { $0.name < $1.name }.filter {
            if searchText.count > 0 {
                $0.name.lowercased().contains(searchText.lowercased())
            } else { true }
        }
    }
}

struct ComponentType: Identifiable {
    init(_ name: String, type: String) {
        self.name = NSLocalizedString(name, comment: "")
        self.type = type
    }
    var id: UUID = UUID()
    var name: String = ""
    var type: String = ""
}
