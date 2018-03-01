//
//  InterfaceController.swift
//  Pi-WeatherWatch Extension
//
//  Created by Hendrik on 09/10/2016.
//  Copyright © 2016 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var humidityLabel: WKInterfaceLabel!
    @IBOutlet var pressureLabel: WKInterfaceLabel!
    @IBOutlet var timestampLabel: WKInterfaceLabel!
    
    var timer:Timer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print(#function)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print(#function)
        refresh()
        timer = Timer.scheduledTimer(timeInterval: AppSettings.sharedInstance.refreshDataInterval,
                                     target: self,
                                     selector: #selector(refresh),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print(#function)
        timer?.invalidate()
    }
    
    @objc func refresh() {
        
        APIController().liveDataForSensorType(.all) { (sensorData, timestamp, error) in
            
            if error == nil && sensorData != nil && timestamp != nil {
                if let temperature = sensorData?[.temperature] {
                    self.temperatureLabel.setText("\(temperature) °C")
                }
                if let humidity = sensorData?[.humidity] {
                    self.humidityLabel.setText("\(humidity) %")
                }
                if let pressure = sensorData?[.pressure] {
                    self.pressureLabel.setText("\(pressure) hPa")
                }
                self.timestampLabel.setText("\(timestamp!)")
            } else {
                self.timestampLabel.setText("Fehler beim Abrufen der Messwerte")
            }
        }
    }

}
