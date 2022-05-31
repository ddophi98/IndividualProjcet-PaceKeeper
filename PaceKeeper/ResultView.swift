//
//  ResultView.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/17.
//

import SwiftUI
import MapKit
import Charts

struct ResultView: View {
    private let timerProcess: TimerProcess
    
    init (_ timerProcess: TimerProcess){
        self.timerProcess = timerProcess
    }
    
    var body: some View {
        ScrollView{
            VStack{
                // 수치 정보 보여주기
                Group{
                    makeTotalInfoView("제한 속도", String(format: "%.1f", timerProcess.data.selectedSpeed) + " km/h")
                    Divider()
                    makeTotalInfoView("평균 속도", String(format: "%.1f", 111) + " km/h")
                    Divider()
                    makeTotalInfoView("총 이동시간", String(timerProcess.data.processedTime) + " s")
                    Divider()
                    makeTotalInfoView("총 이동거리", String(format: "%.2f", timerProcess.data.movedDistance) + " km")
                    Divider()
                    makeTotalInfoView("총 칼로리", String(format: "%.1f", timerProcess.data.consumedCalorie) + " kcal")
                    Divider()
                }
                // 시간에 따른 속도 그래프 보여주기
                makeChartView()
                // 지도에 이동경로 보여주기
                makeMapView()
                Spacer()
            }
        }.padding(.horizontal)
        
    }
    
    // 수치로 나타낼 수 있는 정보에 대한 뷰 만들기
    func makeTotalInfoView(_ title: String, _ content: String) -> some View {
        return HStack{
            Text(title)
                .foregroundColor(Color(hex: "03045E"))
                .font(.system(size: 20, weight: Font.Weight.bold))
            Spacer()
            Text(content)
                .foregroundColor(Color(hex: "0277B6"))
                .font(.system(size: 20, weight: Font.Weight.bold))
        }
    }
    
    // MapView 띄우기
    func makeMapView() -> some View{
        // 맵에서 중심이 될 좌표
        let mapCenter = timerProcess.data.coordinates[0]
        // 지도의 범위
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        // 보여줄 화면
        let mapRegion = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        return MapView(region: mapRegion, lineCoordinates: timerProcess.data.coordinates).frame(height: 200)
    }
    
    // ChartView 띄우기
    func makeChartView() -> some View{
        // 차트의 x값
        let xVals = ["a", "b", "c", "d", "e", "f", "g"]
        // 차트의 y값
        let yVals = [
            ChartDataEntry(x: 1, y: 1),
            ChartDataEntry(x: 2, y: 3),
            ChartDataEntry(x: 3, y: 2),
            ChartDataEntry(x: 4, y: 7),
            ChartDataEntry(x: 5, y: 5),
            ChartDataEntry(x: 6, y: 4),
            ChartDataEntry(x: 7, y: 6)
        ]
        // 보여줄 화면
        return ChartView(xVals: xVals, yVals: yVals).frame(height: 200)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(TimerProcess())
    }
}
