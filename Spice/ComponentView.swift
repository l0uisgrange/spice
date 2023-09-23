//
//  ComponentView.swift
//  Spice
//
//  Created by Louis Grange on 22.09.2023.
//

import SwiftUI

struct ComponentView: View {
    @State var name: String
    @State var imageName: String
    let dotSize: CGFloat = 1.0
    var body: some View {
        HStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color("CanvasBackground"))
                .stroke(.primary.opacity(0.2), lineWidth: 1)
                .frame(width: 50, height: 30)
            Text("Component")
        }
    }
}
