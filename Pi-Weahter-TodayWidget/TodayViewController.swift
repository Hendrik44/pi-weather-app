//
//  TodayViewController.swift
//  Pi-Weahter-TodayWidget
//
//  Created by Hendrik on 25/03/2017.
//  Copyright © 2017 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.preferredContentSize = CGSize(width:self.view.frame.size.width, height:210)
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
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
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func refresh() {
        
        APIController().liveDataForSensorType(.all) { (sensorData, timestamp, error) in
            
            if error == nil && sensorData != nil && timestamp != nil {
                if let temperature = sensorData?[.temperature] {
                    self.temperatureLabel.text = "\(temperature) °C"
                }
                if let humidity = sensorData?[.humidity] {
                    self.humidityLabel.text = "\(humidity) %"
                }
                if let pressure = sensorData?[.pressure] {
                    self.pressureLabel.text = "\(pressure) hPa"
                }
                self.timestampLabel.text             = "Werte vom: \(timestamp!)"
                self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 200)
            } else {
                self.timestampLabel.text = "Fehler beim Abrufen der Messwerte"
            }
        }
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(activeDisplayMode: NCWidgetDisplayMode,
                                          withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 200)
        } else if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        }
    }
}
