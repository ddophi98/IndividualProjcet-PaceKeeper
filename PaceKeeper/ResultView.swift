//
//  ResultView.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/17.
//

import SwiftUI

struct ResultView: View {
    let selectedSpeed: Float
    let averageSpeed: Float
    let totalTime: Int
    let totalDistance: Float
    let totalCalorie: Float
    
    init (selectedSpeed: Float, totalTime: Int, totalDistance: Float, totalCalorie: Float){
        self.selectedSpeed = selectedSpeed
        self.averageSpeed = 0
        self.totalTime = totalTime
        self.totalDistance = totalDistance
        self.totalCalorie = totalCalorie
    }
    
    var body: some View {
        VStack{
            // 수치 정보 보여주기
            makeTotalInfoView("제한 속도", String(selectedSpeed) + " km/h")
            Divider().padding(.horizontal)
            makeTotalInfoView("평균 속도", String(averageSpeed) + " km/h")
            Divider().padding(.horizontal)
            makeTotalInfoView("총 이동시간", String(totalTime))
            Divider().padding(.horizontal)
            makeTotalInfoView("총 이동거리", String(totalDistance) + " km")
            Divider().padding(.horizontal)
            makeTotalInfoView("총 칼로리", String(totalCalorie) + " kcal")
            Divider().padding(.horizontal)
            // 시간에 따른 속도 그래프 보여주기
            
            // 지도에 이동경로 보여주기
        }
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
        }.padding(.horizontal)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(selectedSpeed: 6.5, totalTime: 3, totalDistance: 4, totalCalorie: 234.2)
    }
}
