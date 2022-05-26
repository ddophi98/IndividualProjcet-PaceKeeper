//
//  SoundManager.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/24.
//

import Foundation
import SwiftUI
import AVKit
 
class SoundManager {
    static let instance = SoundManager()
    private var player: AVAudioPlayer?
    
    func playSound(_ state: ComparedState) {
        let soundName: String
        switch state {
        case .Lower:
            soundName = "LowerSound"
        case .Higher:
            soundName = "HigherSound"
        }
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
             print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }

}
