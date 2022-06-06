//
//  ChartView.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/31.
//

import SwiftUI
import Charts

struct ChartView : UIViewRepresentable {
    var xVals : [String]
    var yVals : [ChartDataEntry]

    func makeUIView(context: Context) -> LineChartView {
        let chart = LineChartView()
        return createChart(chart: chart)
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {
        uiView.data = addData()
    }
    
    // 차트 설정 및 생성
    func createChart(chart: LineChartView) -> LineChartView{
        chart.chartDescription?.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = true
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = true
        chart.drawBordersEnabled = false
        chart.legend.form = .none
        if yVals.count < 7{
            chart.xAxis.labelCount = yVals.count
        }else{
            chart.xAxis.labelCount = 7
        }
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        chart.xAxis.granularity = 1
        chart.xAxis.valueFormatter = CustomChartFormatter(times: xVals)
        chart.data = addData()
        return chart
    }
    
    // 데이터 추가하기
    func addData() -> LineChartData{
        let data = LineChartData(dataSets: [
            generateLineChartDataSet(dataSetEntries: yVals, color: UIColor(Color(hex: "0277B6")), fillColor: UIColor(Color(hex: "90E0EF"))),
        ])
        data.setDrawValues(false)
        return data
    }
    
    // 차트의 데이터 특징 설정하고 만들기
    func generateLineChartDataSet(dataSetEntries: [ChartDataEntry], color: UIColor, fillColor: UIColor) -> LineChartDataSet{
        let dataSet = LineChartDataSet(entries: dataSetEntries, label: "")
        dataSet.colors = [color]
        dataSet.mode = .cubicBezier
        dataSet.circleRadius = 5
        dataSet.circleHoleColor = UIColor(Color(#colorLiteral(red: 0.003921568627, green: 0.231372549, blue: 0.431372549, alpha: 1)))
        dataSet.fill = Fill.fillWithColor(fillColor)
        dataSet.drawFilledEnabled = true
        dataSet.setCircleColor(UIColor.clear)
        dataSet.lineWidth = 2
        dataSet.valueTextColor = color
        dataSet.valueFont = UIFont(name: "Avenir", size: 12)!
        return dataSet
    }
    
    // 차트의 x값을 string값으로 변환
    class CustomChartFormatter: NSObject, IAxisValueFormatter {
        var times: [String]
        
        init(times: [String]) {
            self.times = times
        }
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            if Int(value-1) <= -1 || Int(value) > times.count {
                return ""
            } else {
                return times[Int(value-1)]
            }
        }
    }
}
