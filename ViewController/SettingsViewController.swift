//
//  SettingsViewController.swift
//  Pi-Weather
//
//  Created by Hendrik on 31/03/2017.
//  Copyright © 2017 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit
import FontAwesome
#if os(iOS)
    import KVNProgressKit
#endif

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    #if os(iOS)
        static let iconColor = UIColor.black
    #elseif os(tvOS)
        static let iconColor = UIColor.white
    #endif
    #if os(iOS)
        static let iconSize = CGSize(width: 30, height: 30)
    #elseif os(tvOS)
        static let iconSize = CGSize(width: 50, height: 50)
    #endif
    
    var rows = [
        [
            ["Neustarten",
             SettingsViewController.getFontAwesomeIconForCell(.rotateRight)],
            ["Herunterfahren",
             SettingsViewController.getFontAwesomeIconForCell(.powerOff)]
        ],
        [
            ["Lizenzen",
             SettingsViewController.getFontAwesomeIconForCell(.infoCircle)]
        ]
    ]
    
    var sectionTitles = [
        "Allgemein",
        "Über Pi-Weahter"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = rows[indexPath.section][indexPath.row][0] as? String
        cell.imageView?.image = rows[indexPath.section][indexPath.row][1] as? UIImage
        
        cell.detailTextLabel?.font = UIFont.fontAwesome(ofSize: 25)
        cell.detailTextLabel?.text = String.fontAwesomeIcon(name: .angleRight)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: "Hinweis",
                                                        message: "Sind Sie sicher, dass Sie Ihre Wetterstation neustarten möchten?",
                                                        preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Neustarten", style: .destructive) { (_) in
                    _ = APIController().HTTPGetJSON("\(API.defaultAPIUrl)/control/reboot") { (_, _, _) in
                        
                    }
                    #if os(iOS)
                        let conf = KVNProgressConfiguration.default()
                        conf?.minimumErrorDisplayTime = 5.0
                        KVNProgress.setConfiguration(conf)
                        KVNProgress.showSuccess(withStatus: "Wetterstation wird neugestartet und ist gleich wieder erreichbar!")
                    #endif
                }
                alertController.addAction(deleteAction)
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            case 1:
                let alertController = UIAlertController(title: "Hinweis",
                                                        message: "Sind Sie sicher, dass Sie Ihre Wetterstation herunterfahren möchten?",
                                                        preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Herunterfahren", style: .destructive) { (_) in
                    self.present(alertController, animated: true, completion: nil)
                    _ = APIController().HTTPGetJSON("\(API.defaultAPIUrl)/control/shutdown") { (_, _, _) in
                        
                    }
                    #if os(iOS)
                        let conf = KVNProgressConfiguration.default()
                        conf?.minimumErrorDisplayTime = 5.0
                        KVNProgress.setConfiguration(conf)
                        KVNProgress.showSuccess(withStatus: "Wetterstation wird heruntergefahren." +
                            "Nachdem die gründe LED mehrmals blinkt, können Sie den Netzstecker ziehen!")
                    #endif
                }
                alertController.addAction(deleteAction)
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            default:
                return
            }
        case 1:
            let licenseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LicenseViewController")
            self.present(licenseVC, animated: true, completion: nil)
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    class func getFontAwesomeIconForCell(_ icon:FontAwesome) -> UIImage {
        return UIImage.fontAwesomeIcon(name: icon, textColor: self.iconColor, size: self.iconSize)
    }
}
