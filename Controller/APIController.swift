//
//  NetworkController.swift
//  Pi-Weather
//
//  Created by Hendrik on 22.09.16.
//  Copyright © 2016 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

class APIController: AppSettings, URLSessionDelegate {
    
    func liveDataForSensorType(_ type:Sensor.Types,
                               completion: @escaping (_ data:[Sensor.Types:String]?,_ timestamp:String?, _ error:Error?) -> Void) {
        
        _ = self.HTTPGetJSON("\(API.defaultAPIUrl)\(Sensor.urlsLive[type]!)") { (data, response, error) in
            if error == nil && (response as? HTTPURLResponse)?.statusCode == 200 && data != nil {
                var sensorData:[Sensor.Types:String] = [:]
                var timestamp:String?
                if let temp = data?["temperature"] as? String {
                    sensorData[.temperature] = temp
                }
                if let humidity = data?["humidity"] as? String {
                    sensorData[.humidity] = humidity
                }
                if let pressure = data?["pressure"] as? String {
                    sensorData[.pressure] = pressure
                }
                if let time = data?["time"] as? String {
                    timestamp = time
                }
                completion(sensorData, timestamp, nil)
            } else {
                completion(nil, nil, (error != nil ? error : nil))
            }
        }
    }
    
    /*
     HTTP-GET Wrapper for JSON
     */
    func HTTPGetJSON(_ url: String,
                     headers:[String:String]? = nil,
                     callback: @escaping (AnyObject?, URLResponse? ,Error?) -> Void) -> URLSession {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15)
        if headers != nil {
            for (headerfield, headervalue) in headers! {
                request.setValue(headervalue, forHTTPHeaderField: headerfield)
            }
        }
        return HTTPsendJSONRequest(request, callback: callback)
    }
    
    /*
     HTTP-GET Request with JSON
     */
    func HTTPsendJSONRequest(_ request: URLRequest,
                             callback: @escaping (AnyObject?, URLResponse? ,Error?) -> Void) -> URLSession {
        print("Start HTTPsendJSONRequest \(request.url!)")
        let session = Foundation.URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request,completionHandler :
        { data, response, error in
                
                session.finishTasksAndInvalidate()
                
                let statuscode = (response as? HTTPURLResponse)?.statusCode
                
                if error != nil {
                    callback(nil, response ,error)
                } else if statuscode != 200 {
                    if data != nil {
                        do {
                            let jsonResults = try JSONSerialization.jsonObject(with: data!, options: [])
                            
                            callback(jsonResults as AnyObject?,
                                     response,NSError(domain:HTTPURLResponse.localizedString(forStatusCode: statuscode!),
                                                      code:statuscode!, userInfo:nil))
                            // success ...
                        } catch let error {
                            callback(nil, response, error)
                        }
                    }
                    
                } else if data != nil {
                    do {
                        let jsonResults = try JSONSerialization.jsonObject(with: data!, options: [])
                        
                        callback(jsonResults as AnyObject?, response,nil)
                        // success ...
                    } catch let error {
                        callback(nil, response, error)
                        
                    }
                }
        })
        
        task.resume()
        return session
    }
}
