//
//  FirstViewController.swift
//  Pi-WeatherTv
//
//  Created by Hendrik on 22.09.16.
//  Copyright © 2016 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit
import FontAwesome

@IBDesignable
class LiveDataViewController: UIViewController {

    @IBOutlet weak var temperatureView: CircleView!
    @IBOutlet weak var humidityView: CircleView!
    @IBOutlet weak var pressureView: CircleView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var timer:Timer?
    
    #if os(iOS)
        let tabBarIconSize:CGFloat = 30
    #elseif os(tvOS)
        let tabBarIconSize:CGFloat = 60
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tabImages = [
            [UIImage.fontAwesomeIcon(name: .thermometerHalf,
                                    textColor: UIColor.gray,
                                    size: CGSize(width: tabBarIconSize,
                                                 height: tabBarIconSize)).withRenderingMode(.alwaysOriginal),
            UIImage.fontAwesomeIcon(name: .thermometerHalf,
                                    textColor: UIColor(hex: 0x2781B4),
                                    size: CGSize(width: tabBarIconSize,
                                                 height: tabBarIconSize)).withRenderingMode(.alwaysOriginal)],
            [UIImage.fontAwesomeIcon(name: .lineChart,
                                    textColor: UIColor.gray,
                                    size: CGSize(width: tabBarIconSize,
                                                 height: tabBarIconSize)).withRenderingMode(.alwaysOriginal),
            UIImage.fontAwesomeIcon(name: .lineChart,
                                    textColor: UIColor(hex: 0x2781B4),
                                    size: CGSize(width: tabBarIconSize,
                                                 height: tabBarIconSize)).withRenderingMode(.alwaysOriginal)],
            [UIImage.fontAwesomeIcon(name: .cog,
                                    textColor: UIColor.gray,
                                    size: CGSize(width: tabBarIconSize,
                                                 height: tabBarIconSize)).withRenderingMode(.alwaysOriginal),
            UIImage.fontAwesomeIcon(name: .cog,
                                    textColor: UIColor(hex: 0x2781B4),
                                    size: CGSize(width: tabBarIconSize,
                                                 height: tabBarIconSize)).withRenderingMode(.alwaysOriginal)]
            ]
            var count = 0
            for tabItem in self.tabBarController!.tabBar.items! {
                tabItem.image           = tabImages[count][0]
                tabItem.selectedImage   = tabImages[count][1]
                count += 1
            }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext,
                                 with coordinator: UIFocusAnimationCoordinator) {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        refresh()
        timer = Timer.scheduledTimer(timeInterval: AppSettings.sharedInstance.refreshDataInterval,
                                     target: self,
                                     selector: #selector(refresh),
                                     userInfo: nil,
                                     repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        
        APIController().liveDataForSensorType(.all) { (sensorData, timestamp, error) in
            
            if error == nil && sensorData != nil && timestamp != nil {
                if let temperature = sensorData?[.temperature] {
                    self.temperatureView.textLabel.text = "\(temperature) °C"
                }
                if let humidity = sensorData?[.humidity] {
                    self.humidityView.textLabel.text = "\(humidity) %"
                }
                if let pressure = sensorData?[.pressure] {
                    self.pressureView.textLabel.text = "\(pressure) hPa"
                }
                self.timestampLabel.text = "\(timestamp!)"
            } else {
                self.timestampLabel.text = "Fehler beim Abrufen der Messwerte"
            }
        }
    }
}
