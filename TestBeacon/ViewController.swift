//
//  ViewController.swift
//  TestBeacon
//
//  Created by shinketya on 2019/10/04.
//  Copyright © 2019 shinketya. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var trackLocationManager : CLLocationManager!
    var beaconRegion : CLBeaconRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ロケーションマネージャを作成する
        trackLocationManager = CLLocationManager();
        
        // デリゲートを自身に設定
        trackLocationManager.delegate = self;
        
        // BeaconのUUIDを設定
        let uuid:UUID? = UUID(uuidString: "4f215aa1-3904-47d5-ad5a-3b6aa89542ae")
        
        //Beacon領域を作成
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "net.noumenon-th")
        
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status == CLAuthorizationStatus.notDetermined) {
            trackLocationManager.requestWhenInUseAuthorization()
        }
    }
    
    //位置認証のステータスが変更された時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //観測を開始させる
        trackLocationManager.startMonitoring(for: self.beaconRegion)
    }
    
    //観測の開始に成功すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        //観測開始に成功したら、領域内にいるかどうかの判定をおこなう。→（didDetermineState）へ
        print("観測を開始")
        trackLocationManager.requestState(for: self.beaconRegion)
    }
    
    //領域内にいるかどうかを判定する
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {
        
        switch (state) {
        case .inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            trackLocationManager.startRangingBeacons(in: beaconRegion)
            print("ずっと中にいる")
            // →(didRangeBeacons)で測定をはじめる
            break
            
        case .outside:
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            print("外から来た")
            break
            
        case .unknown:
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            print("どっから来た？")
            break
            
        }
    }
    
    //領域に入った時
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // →(didRangeBeacons)で測定をはじめる
        self.trackLocationManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    //領域から出た時
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //測定を停止する
        self.trackLocationManager.stopRangingBeacons(in: self.beaconRegion)
    }
    
    //領域内にいるので測定をする
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        /*
         beaconから取得できるデータ
         proximityUUID   :   regionの識別子
         major           :   識別子１
         minor           :   識別子２
         proximity       :   相対距離
         accuracy        :   精度
         rssi            :   電波強度
         */
    }


}


