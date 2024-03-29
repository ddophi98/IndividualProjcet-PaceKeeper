//
//  MainView.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/17.
//

import SwiftUI
import PopupView

enum CurrentState{
    case BeforeStart, Processing, Stop, End
}

struct MainView: View {
    @State var selectedSpeedIdx: Int
    @State var selectedNotiMethod: NotiMethod
    @State var currentState: CurrentState
    @State var showHelpPopup: Bool
    @State var isLinkActive: Bool
    @ObservedObject var timerProcess: TimerProcess
    var speedList = [Float]()
    
    init(){
        selectedSpeedIdx = 0
        selectedNotiMethod = .Sound
        currentState = CurrentState.BeforeStart
        timerProcess = TimerProcess()
        showHelpPopup = false
        isLinkActive = false
        for speed in stride(from: 0, through: 20, by: 0.5) {
            speedList.append(Float(speed))
        }
        HapticManager.instance.prepareHaptics()
        timerProcess.setLocationManager()
    }
    
    var body: some View {
        
        ZStack{
            VStack(spacing: 40){
                // 제한 속도 선택 또는 보여주기
                VStack{
                    Text("제한 속도")
                        .font(.system(size: 30, weight: Font.Weight.bold))
                        .foregroundColor(Color(hex: "03045E"))
                    makeLimitSpeedView()
                }
                // 알림 방식 선택하기
                VStack{
                    Text("알림 방식")
                        .font(.system(size: 30, weight: Font.Weight.bold))
                        .foregroundColor(Color(hex: "03045E"))
                    Picker("Notice Method", selection: $selectedNotiMethod) {
                        Text("소리").tag(NotiMethod.Sound)
                        Text("진동").tag(NotiMethod.Vibration)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 240)
                }
                // 실시간 정보 보여주기
                LazyVGrid(columns: [GridItem(.flexible(maximum: 140)), GridItem(.flexible(maximum: 140))]){
                    makeRealTimeInfoView(title: "현재 속도", content: String(format: "%.1f", timerProcess.data.currentSpeed) + " km/h")
                    makeRealTimeInfoView(title: "경과 시간", content: changeTimeExpression(sec: timerProcess.data.processedTime))
                    makeRealTimeInfoView(title: "이동 거리", content: String(format: "%.2f", timerProcess.data.movedDistance) + " km")
                    makeRealTimeInfoView(title: "칼로리", content: String(format: "%.1f", timerProcess.data.consumedCalorie) + " kcal")
                }.padding(20)
                // 측정 시작 또는 중지 또는 결과보기
                makeMainButtons()
                Spacer()
            }
            .disabled(showHelpPopup ? true : false)
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(showHelpPopup ? 0.3 : 0)
        }
        .toolbar{
            if currentState != .Processing {
                // 앱의 간단한 설명 팝업 창으로 보여주기
                Button(action:{
                    withAnimation{
                        showHelpPopup = true
                    }
                }){
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(Color(hex: "03045E"))
                        .font(.system(size: 20))
                }
            }
        }
        .popup(isPresented: $showHelpPopup, closeOnTap: false){
            // 팝업 창
            VStack(spacing: 30){
                VStack{
                    Text("현재 속도가 제한 속도보다 높아지면 해당 알림으로 알려줍니다.")
                    makeNotifyExampleView(state: .Higher)
                }
                .padding([.horizontal, .top])
                VStack{
                    Text("현재 속도가 제한 속도보다 낮아지면 해당 알림으로 알려줍니다.")
                    makeNotifyExampleView(state: .Lower)
                }
                .padding(.horizontal)
                Button(action:{
                    withAnimation{
                        showHelpPopup = false
                    }
                }){
                    Text("확인")
                        .font(.system(size: 20, weight: Font.Weight.bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(Rectangle().frame(height: 0.2, alignment: .top).foregroundColor(Color.gray), alignment: .top)
                        .foregroundColor(Color.blue)
                }
                
            }
            .frame(width: 300, height: 350, alignment: .bottom)
            .background(Color.white)
            .cornerRadius(30.0)
        }
        .onAppear {
            print("몸무게: \(UserDefaults.standard.integer(forKey: "weight"))")
        }
        
    }
    
    // 제한 속도 뷰를 상황에 따라 다르게 만들기
    func makeLimitSpeedView() -> some View {
        switch currentState {
        case .BeforeStart, .End:
            // 제한 속도 선택할 수 있게 하기
            return AnyView(
                HStack{
                    Text("km/h").opacity(0)
                    Picker("Limit Speed", selection: $selectedSpeedIdx) {
                        ForEach(0..<speedList.count, id: \.self){ idx in
                            Text(String(speedList[idx]))
                                .font(.system(size: 22, weight: Font.Weight.bold))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    .clipped()
                    .frame(width: 80)
                    Text("km/h")
                        .font(.system(size: 15, weight: Font.Weight.bold))
                }.frame(height: 180)
            )
        case .Processing, .Stop:
            // 선택된 제한 속도 보여주기
            return AnyView(
                HStack{
                    Text(String(speedList[selectedSpeedIdx]))
                        .font(.system(size: 45, weight: Font.Weight.bold))
                    Text("km/h")
                        .font(.system(size: 20, weight: Font.Weight.bold))
                }
                    .foregroundColor(Color(hex: "03045E"))
                    .overlay{
                        Circle()
                            .stroke(lineWidth: 10)
                            .foregroundColor(Color(hex: "0277B6"))
                            .frame(width: 180, height: 180)
                    }
                    .frame(height: 180)
            )
        }
    }
    
    // 실시간 정보 뷰 만들기
    func makeRealTimeInfoView(title: String, content: String) -> some View {
        return VStack(){
            Text(title)
                .font(.system(size: 25, weight: Font.Weight.bold))
                .foregroundColor(Color(hex: "03045E"))
            Text(content)
                .font(.system(size: 25, weight: Font.Weight.bold))
                .foregroundColor(Color(hex: "0277B6"))
        }
    }
    
    // 메인 버튼을 상황에 따라 다르게 만들기
    func makeMainButtons() -> some View {
        switch currentState {
        case .BeforeStart:
            // 측정 시작하기
            return AnyView(
                Button(action:{
                    timerProcess.initData()
                    timerProcess.startProcess(selectedSpeed: speedList[selectedSpeedIdx], selectedNotiMethod: selectedNotiMethod)
                    currentState = .Processing
                }){
                    Text("측정 시작")
                        .font(.system(size: 25, weight: Font.Weight.bold))
                        .frame(width: 120)
                        .padding()
                        .background(Color(hex: "C9F0F8"))
                        .foregroundColor(Color(hex: "03045E"))
                        .cornerRadius(20)
                }
            )
        case .Processing:
            // 측정 종료 또는 일시 정지하기
            return AnyView(
                HStack(spacing:25){
                    Button(action:{
                        timerProcess.stopProcess()
                        currentState = .Stop
                    }){
                        Text("일시 정지")
                            .font(.system(size: 25, weight: Font.Weight.bold))
                            .frame(width: 120)
                            .padding()
                            .background(Color(hex: "EEEEEF"))
                            .foregroundColor(Color(hex: "000000"))
                            .cornerRadius(20)
                    }
                    Button(action:{
                        timerProcess.stopProcess()
                        currentState = .End
                    }){
                        Text("종료")
                            .font(.system(size: 25, weight: Font.Weight.bold))
                            .frame(width: 120)
                            .padding()
                            .background(Color(hex: "FF5C5C"))
                            .foregroundColor(Color(hex: "FFFFFF"))
                            .cornerRadius(20)
                    }
                }
            )
        case .Stop:
            // 측정 종료 또는 계속하기
            return AnyView(
                HStack(spacing:25){
                    Button(action:{
                        timerProcess.startProcess(selectedSpeed: speedList[selectedSpeedIdx], selectedNotiMethod: selectedNotiMethod)
                        currentState = .Processing
                    }){
                        Text("계속")
                            .font(.system(size: 25, weight: Font.Weight.bold))
                            .frame(width: 120)
                            .padding()
                            .background(Color(hex: "C9F0F8"))
                            .foregroundColor(Color(hex: "03045E"))
                            .cornerRadius(20)
                    }
                    Button(action:{
                        currentState = .End
                    }){
                        Text("종료")
                            .font(.system(size: 25, weight: Font.Weight.bold))
                            .frame(width: 120)
                            .padding()
                            .background(Color(hex: "FF5C5C"))
                            .foregroundColor(Color(hex: "FFFFFF"))
                            .cornerRadius(20)
                    }
                }
            )
        case .End:
            // 재시작하거나 결과 보기
            return AnyView(
                HStack(spacing:25){
                    Button(action:{
                        timerProcess.initData()
                        timerProcess.startProcess(selectedSpeed: speedList[selectedSpeedIdx], selectedNotiMethod: selectedNotiMethod)
                        currentState = .Processing
                    }){
                        Text("재시작")
                            .font(.system(size: 25, weight: Font.Weight.bold))
                            .frame(width: 120)
                            .padding()
                            .background(Color(hex: "C9F0F8"))
                            .foregroundColor(Color(hex: "03045E"))
                            .cornerRadius(20)
                    }
                    NavigationLink(destination: ResultView(timerProcess: timerProcess, selectedSpeed: speedList[selectedSpeedIdx]), isActive: $isLinkActive){
                        Button(action:{
                            self.timerProcess.data.speeds.remove(at: 0)
                            isLinkActive = true
                        }){
                            Text("결과 보기")
                                .font(.system(size: 25, weight: Font.Weight.bold))
                                .frame(width: 120)
                                .padding()
                                .background(Color(hex: "03045E"))
                                .foregroundColor(Color(hex: "FFFFFF"))
                                .cornerRadius(20)
                        }
                    }
                }
            )
        }
    }
    // 알림 타입의 예시를 들을 수 있게 해주는 뷰 만들기
    func makeNotifyExampleView(state: ComparedState) -> some View {
        return HStack(spacing: 20){
            Button(action:{
                switch state {
                case .Lower:
                    timerProcess.notify(type: .Sound, state: .Lower)
                case .Higher:
                    timerProcess.notify(type: .Sound, state: .Higher)
                }
            }){
                Text("소리")
                    .font(.system(size: 17, weight: Font.Weight.bold))
                    .frame(width: 60, height: 10)
                    .padding()
                    .background(Color(hex: "C9F0F8"))
                    .foregroundColor(Color(hex: "000000"))
                    .cornerRadius(20)
            }
            Text("또는")
                .font(.system(size: 17, weight: Font.Weight.bold))
            Button(action:{
                switch state {
                case .Lower:
                    timerProcess.notify(type: .Vibration, state: .Lower)
                case .Higher:
                    timerProcess.notify(type: .Vibration, state: .Higher)
                }
            }){
                Text("진동")
                    .font(.system(size: 17, weight: Font.Weight.bold))
                    .frame(width: 60, height: 10)
                    .padding()
                    .background(Color(hex: "0277B6"))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .cornerRadius(20)
            }
        }
    }
    
    // 시간 표현 형식 바꾸기
    func changeTimeExpression(sec: Int) -> String{
        if sec >= 60 {
            let min = sec / 60
            let remainedSec = sec % 60
            return "\(min) m \(remainedSec) s"
        } else {
            return "\(sec)" + " s"
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

