//
//  HapticManager.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/23.
//

import Foundation
import UIKit
import CoreHaptics

class HapticManager {
    static let instance = HapticManager()
    private var engine: CHHapticEngine?
    
    // 디바이스가 Haptic을 지원한다면 엔진 생성
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic Engine을 만들 때 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
    
    // 진동시키기
    func vibrate(_ state: ComparedState) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // 진동 패턴 생성하기
        switch state {
        case .Lower:
            for i in stride(from: 0, to: 1, by: 0.05) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1-i))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1-i))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
                events.append(event)
            }
        case .Higher:
            for i in stride(from: 0, to: 1, by: 0.05) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
                events.append(event)
            }
        }

        // 이벤트를 패턴으로 바꾸고 바로 재생시키기
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}


