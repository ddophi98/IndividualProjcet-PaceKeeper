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
    @Published var location: CLLocationCoordinate2D?
    private var timer = Timer()
    private let locationManager = CLLocationManager()
    //위도와 경도
    var latitude: Double?
    var longitude: Double?
    
    // 데이터 초기화하기
    func initData(){
        self.data = Data()
    }
    
    // 프로세스 시작하기
    func startProcess(){
        // 초단위로 반복되는 작업
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
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
            print("내 위치: \(latitude), \(longitude)")
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
    
    //위도 경도 가져오기
    func updateLocation(){
        latitude = locationManager.location?.coordinate.latitude
        longitude = locationManager.location?.coordinate.longitude
    }
}


