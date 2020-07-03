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
    
    var students = [StudentInformation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        students = appDelegate.students
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        guard let url = URL(string: student.mediaURL) else {return}
        
        if UIApplication.shared.canOpenURL(url){
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        }else{
            //TODO: - Handle error
        }
        
        
    }
    
    
}
