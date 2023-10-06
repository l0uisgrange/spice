//
//  OnBoardingView.swift
//  Spice
//
//  Created by Louis Grange on 23.09.2023.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @AppStorage("gridStyle") private var gridStyle = 1
    @AppStorage("onBoarded") private var onBoarded = false
    @Binding var isPresented: Bool
    let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    @State var text: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("ONBOARDING_TITLE")
                    .font(.system(size: 30))
                    .padding(.bottom, 5)
                Text("ONBOARDING_MESSAGE")
                    .font(.title3)
                    .foregroundStyle(.gray)
            }.padding(20)
            VStack(alignment: .leading, spacing: 4) {
                Label("ONBOARDING_DRAW_CIRCUITS", image: "pencil.ruler")
                Label("ONBOARDING_SIMULATE", image: "activity")
                Label("ONBOARDING_EXPORT", image: "file.up")
            }.padding(.horizontal, 20)
            .padding(.vertical, 15)
            Form {
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
            }.scrollContentBackground(.hidden)
            .formStyle(.grouped)
            .padding(0)
            .scrollDisabled(true)
            Divider()
            HStack {
                Text("VERSION \(appVersion) (\(appBuild))")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()
                Link(destination: URL(string: "https://github.com/l0uisgrange/spice/wiki")!) {
                    Text("HELP_BEGIN")
                }.buttonStyle(.bordered)
                .controlSize(.extraLarge)
                Button {
                    onBoarded.toggle()
                    isPresented.toggle()
                } label: {
                    Text("ONBOARDING_BUTTON")
                }.buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
            }.padding(15)
        }.frame(width: 500)
        .background(Color("CanvasBackground"))
    }
}
