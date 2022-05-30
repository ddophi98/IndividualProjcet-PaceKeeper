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
    
    // 데이터 초기화하기
    func initData(){
        self.data = Data()
    }
    
    // 프로세스 시작하기
    func startProcess(){
        // 일정시간 단위로 반복되는 작업
        timer = Timer.scheduledTimer(withTimeInterval: updatingTime, repeats: true){ timer in
            // 시간 증가시키기
            self.data.processedTime += 1
            // 현재 위치 업데이트 하기
            self.updateLocation()
            guard let latitude = self.latitude,
                  let longitude = self.longitude
            else{
                print("위치 정보 못받아옴")
                return
            }
            
            // 좌표 추가하기
            if self.data.coordinates.count == 0{
                self.data.coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }else{
                let lastCoordinate = self.data.coordinates[self.data.coordinates.endIndex-1]
                // 움직인 거리 및 속도 업데이트하기
                if lastCoordinate.latitude != latitude || lastCoordinate.longitude != longitude{
                    let currentCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let currentMovedDistance = Float(self.getDistance(from: lastCoordinate, to: currentCoordinate))/1000
                    self.data.coordinates.append(currentCoordinate)
                    self.data.movedDistance += currentMovedDistance
                    self.data.currentSpeed = currentMovedDistance / (Float(self.updatingTime) / 3600)
                }else{
                    self.data.currentSpeed = 0.0
                }
            }
        }
    }
    
    // 프로세스 멈추기
    func stopProcess(){
        timer.invalidate()
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
}


