//
//  LicenseViewController.swift
//  Pi-Weather
//
//  Created by Hendrik on 20.12.15.
//  Copyright © 2015 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "credits-licenses",
                                                        ofType: "html",
                                                        inDirectory: "licenses")!)
        do {
            let text2 = try String(contentsOf: url, encoding: String.Encoding.utf8)
            textView.attributedText = text2.html2AttributedString
        } catch {/* error handling here */}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeViewController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
