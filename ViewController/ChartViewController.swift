//
//  ChartViewController.swift
//  Pi-Weather
//
//  Created by Hendrik on 02/11/15.
//  Copyright © 2015 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit
import Charts
import FontAwesome
#if os(iOS)
    import KVNProgressKit
#endif

class ChartViewController: UIViewController {
    
    let segments = ["temperature", "humidity", "pressure"]
    let legendTexts = ["Temperatur in °C", "Feuchtigkeit in %", "Luftdruck in hPa"]
    
    @IBOutlet weak var historyChoose: UISegmentedControl!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var btnSettings: UIButton!
    
    var urlSession:URLSession?
    
    #if os(iOS)
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .default
        }
    #endif
    
    override func viewDidLoad()
    {
        #if os(iOS)
            btnSettings.setImage(UIImage.fontAwesomeIcon(name: .cog,
                                                         style: .solid,
                                                         textColor: UIColor(hex: 0xFFFFFF),
                                                         size: CGSize(width: btnSettings.bounds.width,
                                                                      height: btnSettings.bounds.height)),
                                 for: .normal)
            
            KVNProgress.show(withStatus: "Lade Daten...")
        #endif
        
        self.changeSegment(self.historyChoose)
        
        #if os(tvOS)
            chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 28)
            chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 28)
            chartView.legend.font = UIFont.systemFont(ofSize: 28)
        #endif
    }
    
    /// parse api-data to chart-data
    ///
    /// - Parameter results: [AnyObject] api-data
    func parseChartData(_ results: [[String:NSNumber]]) {
        if results.first == nil {
            return
        }
        
        /// current selected sensortype
        let sensorType = segments[historyChoose.selectedSegmentIndex]
        
        /// timesarray for x-axis
        var times: [NSNumber] = []
        
        /// sensor-values array
        var sensorData: [AnyObject] = []
        
        /// set initial values for y- and x-axis scale
        var Ymax = results[0][sensorType]?.doubleValue == nil ? 0 : results[0][sensorType]!.doubleValue
        var Ymin = results[0][sensorType]?.doubleValue == nil ? 0 : results[0][sensorType]!.doubleValue
        
        var datapointCounter:Int = results.count/AppSettings.sharedInstance.datapointsInChart
        var dataEntries: [ChartDataEntry] = []
        var i = 0
        
        for data in results {
            if results.count > AppSettings.sharedInstance.datapointsInChart {
                //print(datapointCounter)
                if datapointCounter <= 0 {
                    generateChartData(sensorType, times: &times, sensorData: &sensorData, ymax: &Ymax, ymin: &Ymin, data: data, count: &i, dataEntries: &dataEntries)
                    datapointCounter = results.count/AppSettings.sharedInstance.datapointsInChart
                }
                
                datapointCounter -= 1
            } else {
                generateChartData(sensorType, times: &times, sensorData: &sensorData, ymax: &Ymax, ymin: &Ymin, data: data, count: &i, dataEntries: &dataEntries)
            }
            
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: legendTexts[historyChoose.selectedSegmentIndex])
        chartDataSet.drawFilledEnabled = true
        chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
        DispatchQueue.main.async(execute: {
//            let offset = Ymax - Ymin
//            if offset != 0 {
//                self.chartView.leftAxis.axisMinimum = Ymin - offset
//                self.chartView.leftAxis.axisMaximum = Ymax + offset
//            } else {
//                self.chartView.leftAxis.axisMinimum = Ymin - 1
//                self.chartView.leftAxis.axisMaximum = Ymax + 1
//            }
            //            self.chartView.leftAxis.startAtZeroEnabled = false
            self.chartView.rightAxis.enabled = false
            self.chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, _) -> String in
                let date = Date(timeIntervalSince1970: TimeInterval(value))
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "dd.MM HH:mm "
                dayTimePeriodFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
                return dayTimePeriodFormatter.string(from: date)
            })
            self.chartView.data = LineChartData(dataSet: chartDataSet)
            #if os(tvOS)
                self.chartView.data?.calcMinMax()
                self.chartView.data?.setDrawValues(false)
            #endif
            #if os(iOS)
                KVNProgress.dismiss()
            #endif
        })
        
    }
    
    /// action change segement and trigger loading chart for selected segment
    ///
    /// - Parameter sender: AnyObject sender-object (UISegmentedControl)
    @IBAction func changeSegment(_ sender: AnyObject) {
        #if os(iOS)
            let configuration = KVNProgressConfiguration.default()
            configuration?.doesShowStop = true
            configuration?.tapBlock = {
                    hud in
                    KVNProgress.dismiss()
                    self.urlSession?.invalidateAndCancel()
            }
            KVNProgress.setConfiguration(configuration)
            KVNProgress.show(withStatus: "Lade Daten...")
        #endif
        let url = "\(API.defaultAPIUrl)/history/sensor/\(segments[historyChoose.selectedSegmentIndex])"
        self.urlSession = APIController().HTTPGetJSON(url) { (data, response, error) in
            if error == nil &&
                (response as? HTTPURLResponse)?.statusCode == 200 &&
                data != nil {
                if let rawData = data?["data"] as? [[String:NSNumber]] {
                    self.parseChartData(rawData)
                }
            } else {
                #if os(iOS)
                    KVNProgress.showError(withStatus: "Fehler beim Abrufen der Daten")
                #endif
            }
        }
    }
    
    func generateChartData( _ sensorType:String,
                            times:inout [NSNumber],
                            sensorData:inout [AnyObject],
                            ymax:inout Double,
                            ymin:inout Double,
                            data: [String:NSNumber],
                            count:inout Int,
                            dataEntries:inout [ChartDataEntry]) {
        times.append(data["time"]!)
        sensorData.append(data[sensorType]!)
        
        let dataEntry = ChartDataEntry(x: (data["time"]!).doubleValue, y: data[sensorType] as! Double)
        count += 1
        dataEntries.append(dataEntry)
        if (data[sensorType]!.doubleValue) > ymax {
            ymax = data[sensorType]!.doubleValue
        }
        if (data[sensorType]!.doubleValue) < ymin {
            ymin = data[sensorType]!.doubleValue
        }
    }
    
    func downscale(_ data : [AnyObject], neededEntries : Int) -> [AnyObject] {
        var data = data
        //zuviel Elemente
        var newArray:[AnyObject]!
        if data.count > neededEntries {
            //let diff = data.count - neededEntries
            if data.count % AppSettings.sharedInstance.datapointsInChart != 0 {
                let number = findNext(data.count)
                data = upsclae(data, neededEntries: number)
            }
            var counter = AppSettings.sharedInstance.datapointsInChart
            let scale = data.count / AppSettings.sharedInstance.datapointsInChart
            for elem in data {
                if counter == scale {
                    newArray.append(elem as AnyObject)
                    counter = 0
                } else {
                    counter += 1
                }
            }
            return newArray
        }
        return []
    }
    
    func upsclae(_ data : [AnyObject], neededEntries : Int) -> [AnyObject] {
        
        return []
    }
    
    func findNext(_ count : Int) -> Int {
        for index in 0 ..< count {
            if (count + index) % AppSettings.sharedInstance.datapointsInChart == 0 {
                return (count + index)
            }
        }
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toSettingChartViewC") {
//            let controller = segue.destination as! chartSettingViewController
//            controller.CVController = self
        }
    }
}
