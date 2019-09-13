//
//  ImageGalleryTableViewController.swift
//  ImageGallery-Assignment4
//
//  Created by Shakaib Akhtar on 12/09/2019.
//  Copyright © 2019 iParagons. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {

    var galleriesInUse = [String]()
    var galleriesRecentlyDeleted = [String]()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 { return "" }
        else { return "Recently Deleted" }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return galleriesInUse.count }
        else { return galleriesRecentlyDeleted.count }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "GalleriesInUse", for: indexPath)
            cell.textLabel?.text = galleriesInUse[indexPath.row]
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "GalleriesInUse", for: indexPath)
            cell.textLabel?.text = galleriesRecentlyDeleted[indexPath.row]
        }
        return cell
    }

    @IBAction func AddNewGalleryClicked(_ sender: UIBarButtonItem) {
        galleriesInUse += ["Gallery".madeUnique(withRespectTo: galleriesInUse)]
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                let temp = galleriesInUse[indexPath.row]
                galleriesRecentlyDeleted.append(temp)
                galleriesInUse.remove(at: indexPath.row)
                tableView.reloadData()
            }
            else {
                
                galleriesRecentlyDeleted.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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

}
