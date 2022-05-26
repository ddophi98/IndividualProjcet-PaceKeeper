//
//  TimerProcess.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/25.
//

import Foundation
import SwiftUI
import Combine

class TimerProcess: ObservableObject {
    @Published var data: Data = Data()
    var timer = Timer()
    
    // 데이터 초기화하기
    func initData(){
        self.data = Data()
    }
    
    // 프로세스 시작하기
    func startProcess(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
            self.data.processedTime += 1
        }
    }
    
    // 프로세스 멈추기
    func stopProcess(){
        timer.invalidate()
    }
}


