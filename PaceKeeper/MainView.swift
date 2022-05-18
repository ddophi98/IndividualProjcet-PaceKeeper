//
//  MainView.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/17.
//

import SwiftUI

enum NotiMethod{
    case Sound, Vibration
}

enum CurrentState{
    case BeforeProcess, Processing, AfterProcess
}

struct MainView: View {
    @State var selectedSpeedIdx: Int
    @State var selectedNotiMethod: NotiMethod
    @State var currentState: CurrentState
    @State var currentSpeed: Float
    @State var processedTime: Int
    @State var movedDistance: Float
    @State var consumedCalorie: Float
    var speeds = [Float]()
    
    init(){
        selectedSpeedIdx = 0
        selectedNotiMethod = NotiMethod.Sound
        currentState = CurrentState.BeforeProcess
        currentSpeed = 0.0
        processedTime = 0
        movedDistance = 0.0
        consumedCalorie = 0.0
        for speed in stride(from: 0, through: 20, by: 0.5) {
            speeds.append(Float(speed))
        }
    }
    
    var body: some View {
        VStack{
            // 제한 속도 선택 또는 보여주기
            Text("제한 속도")
            makeLimitSpeedView()
            // 알림 방식 선택하기
            Text("알림 방식")
            Picker("Notice Method", selection: $selectedNotiMethod) {
                Text("소리").tag(NotiMethod.Sound)
                Text("진동").tag(NotiMethod.Vibration)
            }
            .pickerStyle(SegmentedPickerStyle())
            // 실시간 정보 보여주기
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
                makeRealTimeInfoView(title: "현재 속도", content: "\(currentSpeed)")
                makeRealTimeInfoView(title: "시간", content: "\(processedTime)")
                makeRealTimeInfoView(title: "이동 거리", content: "\(movedDistance)")
                makeRealTimeInfoView(title: "칼로리", content: "\(consumedCalorie)")
            }
            // 측정 시작 또는 중지 또는 결과보기
            makeMainButtons()
        }
    }
    
    // 제한 속도 뷰를 상황에 따라 다르게 만들기
    func makeLimitSpeedView() -> some View {
        switch currentState {
        case .BeforeProcess, .AfterProcess:
            // 제한 속도 선택할 수 있게 하기
            return AnyView(
                Picker("Limit Speed", selection: $selectedSpeedIdx) {
                    ForEach(0..<speeds.count, id: \.self){ idx in
                        Text(String(speeds[idx]) + " km/h")
                    }
                }.pickerStyle(WheelPickerStyle())
            )
        case .Processing:
            // 선택된 제한 속도 보여주기
            return AnyView(
                Text(String(speeds[selectedSpeedIdx]))
            )
        }
    }
    
    // 실시간 정보 뷰 만들기
    func makeRealTimeInfoView(title: String, content: String) -> some View {
        return VStack{
            Text(title)
            Text(content)
        }
    }
    
    // 메인 버튼을 상황에 따라 다르게 만들기
    func makeMainButtons() -> some View {
        switch currentState {
        case .BeforeProcess:
            return AnyView(
                Button(action:{
                    currentState = .Processing
                }){
                    Text("측정 시작")
                }
            )
        case .Processing:
            return AnyView(
                Button(action:{
                    currentState = .AfterProcess
                }){
                    Text("종료")
                }
            )
        case .AfterProcess:
            return AnyView(
                HStack{
                    Button(action:{
                        currentState = .BeforeProcess
                    }){
                        Text("재시작")
                    }
                    Button(action:{
                        
                    }){
                        Text("결과 보기")
                    }
                }
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
