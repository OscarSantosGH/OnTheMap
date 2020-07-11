//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/28/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import SafariServices

class StudentsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    var students = [StudentInformation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // get all the students from the appDelegate.students
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        students = appDelegate.students
        // Set an observer that helps to reload the mapView annotations from another viewController
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewData), name: NSNotification.Name(rawValue: "ReloadData"), object: nil)
    }
    
    @objc func reloadTableViewData(){
        tableView.reloadData()
    }
    
    // try to logout from the session
    @IBAction func logout(_ sender: Any) {
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        OTMClient.logout { [weak self] (success, error) in
            guard let self = self else {return}
            loadingView.removeFromSuperview()
            if success{
                // goto the LoginViewController
                self.performSegue(withIdentifier: "unwindToLoginViewController", sender: self)
            }else{
                self.presentOTMAlert(title: "Something went wrong", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        reloadTableViewData()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        // get the id of the last location that the user post
        let objectId = OTMClient.Auth.postedLocationId
        // check for the user post in the students array
        for student in students{
            // if the user post is found the overwriteLocation function will be called
            if student.objectId == objectId{
                overwriteLocation()
                // the function will exit after overwriteLocation get called
                return
            }
        }
        // if the user doesn't has a location in the map the AddLocationViewController will show up.
        performSegue(withIdentifier: "toAddLocation", sender: self)
    }
    // If the user had a pin in the map an UIAlertController will appear asking if the user want to overwrite his location.
    func overwriteLocation(){
        let alertViewController = UIAlertController(title: "You Have Posted a Student Location", message: "Would You Like To Overwrite Your Current Location?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertViewController.dismiss(animated: true)
        }
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (action) in
            self.performSegue(withIdentifier: "toAddLocation", sender: self)
        }
        alertViewController.addAction(overwriteAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true)
    }
    // remove all the observers when the view is remove from memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension StudentsTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // In Swift 5.1 you can omit the keyword "return" when the function is a single expression
        students.count
    }
    // configure all the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        cell.textLabel?.text = student.firstName
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    // handle touches in cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        guard let url = URL(string: student.mediaURL) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url){
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        }
        
    }
    
    
}
