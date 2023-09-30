//
//  OnBoardingView.swift
//  Spice
//
//  Created by Louis Grange on 23.09.2023.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    @AppStorage("gridStyle") private var gridStyle = 1
    @AppStorage("onBoarded") private var onBoarded = false
    @Binding var isPresented: Bool
    let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    @State var text: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("AppIconRep")
                .resizable()
                .frame(width: 60, height: 60)
            Text("ONBOARDING_TITLE")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("ONBOARDING_MESSAGE")
            Form {
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
            }.formStyle(.grouped)
            .scrollDisabled(true)
            HStack {
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
            }
            Text("VERSION \(appVersion) (\(appBuild))")
                .font(.caption)
                .foregroundStyle(.gray)
        }.frame(width: 400)
        .padding(40)
        .background(.background)
    }
}
