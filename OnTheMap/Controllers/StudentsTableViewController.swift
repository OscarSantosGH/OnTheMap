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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        students = appDelegate.students
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewData), name: NSNotification.Name(rawValue: "ReloadData"), object: nil)
    }
    
    @objc func reloadTableViewData(){
        tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any) {
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        OTMClient.logout { [weak self] (success, error) in
            guard let self = self else {return}
            loadingView.removeFromSuperview()
            if success{
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
        let objectId = OTMClient.Auth.postedLocationId
        
        for student in students{
            if student.objectId == objectId{
                overwriteLocation()
                return
            }
        }
        performSegue(withIdentifier: "toAddLocation", sender: self)
    }
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension StudentsTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // In Swift 5.1 you can omit the keyword "return" when the function is a single expression
        students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        cell.textLabel?.text = student.firstName
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    
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
