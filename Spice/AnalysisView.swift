//
//  AnalysisView.swift
//  Spice
//
//  Created by Louis Grange on 21.12.2023.
//

import SwiftUI
import Charts

struct AnalysisView: View {
    struct BatteryData {
        let date: Date
        let level: Double
        static let data: [BatteryData] = [
            BatteryData(date: Date(timeIntervalSince1970: 189318391), level: 0.8),
            BatteryData(date: Date(timeIntervalSince1970: 189318491), level: 0.3),
            BatteryData(date: Date(timeIntervalSince1970: 189318591), level: 0.8),
            BatteryData(date: Date(timeIntervalSince1970: 189318691), level: 0.3),
            BatteryData(date: Date(timeIntervalSince1970: 189318791), level: 0.6),
            BatteryData(date: Date(timeIntervalSince1970: 189318891), level: 0.2),
            BatteryData(date: Date(timeIntervalSince1970: 189318991), level: 0.78),
            BatteryData(date: Date(timeIntervalSince1970: 189319091), level: 0.8),
            BatteryData(date: Date(timeIntervalSince1970: 189319191), level: 0.2)
        ]
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            Chart(BatteryData.data, id: \.date) {
                LineMark(
                    x: .value("", $0.date),
                    y: .value("", $0.level)
                ).lineStyle(StrokeStyle(lineWidth: 1))
            }.chartYScale(domain: [0, 1])
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 10))
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 9))
            }
            .padding(20)
        }.background(Color("CanvasBackground"))
        .scrollContentBackground(.hidden)
    }
}
