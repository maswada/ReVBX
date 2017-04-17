//
//  ContentTableViewController.swift
//  ReVBX
//
//  Created by 和田 昌紘 on 2017/04/13.
//  Copyright © 2017年 mediba inc. All rights reserved.
//

import UIKit

class ContentTableViewController: UITableViewController, ContentTableHeaderViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 280.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: 200.0))
//        header.backgroundColor = UIColor.black
        let header = ContentTableHeaderView(frame: CGRect.zero, delegate: self)
        return header
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kVoiceCell", for: indexPath)

        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func willShowCannotUseAlert() {
        let alert = UIAlertController(title: nil, message: "このデバイスでは本機能の利用はできません", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func willShowAccessPermissionAlert() {
        let alert = UIAlertController(title: nil, message: "このアプリではカメラ機能を使用します。アクセスを許可してください。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "設定", style: .default, handler: {action in
            if let url = URL(string: "App-Prefs:root=Privacy") {
                UIApplication.shared.openURL(url);
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func willPushCameraViewController() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
}
