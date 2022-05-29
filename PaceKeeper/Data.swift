//
//  Data.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/25.
//

import Foundation
import CoreLocation

struct Data{
    var currentSpeed: Float
    var processedTime: Int
    var movedDistance: Float
    var consumedCalorie: Float
    var coordinates = [CLLocationCoordinate2D]()
    
    init(currentSpeed: Float = 0.0, processedTime: Int = 0, movedDistance: Float = 0.0, consumedCalorie: Float = 0.0){
        self.currentSpeed = currentSpeed
        self.processedTime = processedTime
        self.movedDistance = movedDistance
        self.consumedCalorie = consumedCalorie
    }
}
