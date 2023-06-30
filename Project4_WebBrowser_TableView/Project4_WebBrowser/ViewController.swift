//
//  ViewController.swift
//  Project4_WebBrowser
//
//  Created by Maxim on 17.04.2023.
//

import UIKit
import WebKit

class ViewController: UITableViewController {
    var webSites = ["hackingwithswift.com", "vk.com", "spotify.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose the website"
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = webSites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "Web") as? WebViewController {
            viewController.selectedWebSite =  webSites[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

