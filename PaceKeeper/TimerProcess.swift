//
//  TimerProcess.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/25.
//

import SwiftUI
import CoreLocation

class TimerProcess: UIViewController, ObservableObject, CLLocationManagerDelegate {
    @Published var data: Data = Data()
    private let locationManager = CLLocationManager()
    private var timer = Timer()
    private var latitude: Double?
    private var longitude: Double?
    private let updatingTime = 1.0
    private var speedInitCount = 3
    private var timerCountFromResume = 0
    
    // 데이터 초기화하기
    func initData(){
        self.data = Data()
    }
    
    // 프로세스 시작하기
    func startProcess(selectedSpeed: Float, selectedNotiMethod: NotiMethod){
        // 일정시간 단위로 반복되는 작업
        timer = Timer.scheduledTimer(withTimeInterval: updatingTime, repeats: true){ timer in
            self.timerCountFromResume += 1
            // 시간(초) 증가시키기
            self.data.processedTime += 1
            // 칼로리 계산하기
            self.data.consumedCalorie = self.calculateCalorie()
            // 현재 좌표 업데이트 하기
            self.updateLocation()
            guard let latitude = self.latitude,
                  let longitude = self.longitude
            else{
                print("위치 정보 못받아옴")
                return
            }
            // 위치 추가하기
            let currentCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.data.coordinates.append(currentCoordinate)
            if self.timerCountFromResume >= 2{
                // 움직인 거리 및 속도 업데이트하기
                let lastCoordinate = self.data.coordinates[self.data.coordinates.endIndex-2]
                self.updateValue(currentCoordinate: currentCoordinate, lastCoordinate: lastCoordinate)
                // 속도 변화에 따라 알림 보내기
                self.notifyBySpeed(lastSpeed: self.data.speeds[self.data.speeds.endIndex-2], currentSpeed: self.data.currentSpeed, limitSpeed: selectedSpeed, notiMethod: selectedNotiMethod)
            }
        }
    }
    
    // 프로세스 멈추기
    func stopProcess(){
        timer.invalidate()
        timerCountFromResume = 0
    }
    
    // LocationManger 초기 설정하기
    func setLocationManager(){
        super.viewDidLoad()
        //locationManager 델리게이트 생성
        locationManager.delegate = self
        //포그라운드 상태에서 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위치업데이트
        locationManager.startUpdatingLocation()
    }
    
    // 위도 경도 업데이트하기
    func updateLocation(){
        latitude = locationManager.location?.coordinate.latitude
        longitude = locationManager.location?.coordinate.longitude
    }
    
    // 두 좌표간의 거리 계산하기
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
            let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
            let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
            return from.distance(from: to)
    }
    
    // 움직인 거리 및 속도 업데이트하기
    func updateValue(currentCoordinate: CLLocationCoordinate2D, lastCoordinate: CLLocationCoordinate2D){
        if lastCoordinate.latitude != currentCoordinate.latitude || lastCoordinate.longitude != currentCoordinate.longitude{
            speedInitCount = 3
            let currentMovedDistance = Float(self.getDistance(from: lastCoordinate, to: currentCoordinate))/1000
            self.data.movedDistance += currentMovedDistance
            self.data.currentSpeed = currentMovedDistance / (Float(self.updatingTime) / 3600)
        }else{
            speedInitCount -= 1
            if speedInitCount == 0{
                self.data.currentSpeed = 0
            }else{
                self.data.currentSpeed /= 2
            }
        }
        self.data.speeds.append(self.data.currentSpeed)
    }
    
    // 속도에 따라 알림 주기
    func notifyBySpeed(lastSpeed: Float, currentSpeed: Float, limitSpeed: Float, notiMethod: NotiMethod){
        // 현재속도가 재한속도를 넘어갔을때
        if lastSpeed < limitSpeed && limitSpeed < currentSpeed {
            notify(type: notiMethod, state: .Higher)
            print("higher notify")
        }
        // 현재속도가 제한속도보다 떨어졌을때
        else if currentSpeed < limitSpeed && limitSpeed < lastSpeed {
            notify(type: notiMethod, state: .Lower)
            print("lower notify")
        }
    }
    
    // 알림음 또는 진동 들려주기
    func notify(type: NotiMethod, state: ComparedState){
        switch type {
        case .Sound:
            switch state {
            case .Lower:
                SoundManager.instance.playSound(.Lower)
            case .Higher:
                SoundManager.instance.playSound(.Higher)
            }
        case .Vibration:
            switch state {
            case .Lower:
                HapticManager.instance.vibrate(.Lower)
            case .Higher:
                HapticManager.instance.vibrate(.Higher)
            }
        }
    }
    
    // 칼로리 계산하기
    func calculateCalorie() -> Float {
        // 조깅 기준
        let metPerMinute: Float = 7.0
        let met: Float = 3.5 * Float(UserDefaults.standard.integer(forKey: "weight")) / 60
        let kcal: Float = metPerMinute * met * Float(self.data.processedTime) * 5 / 1000
        return kcal
    }
}


