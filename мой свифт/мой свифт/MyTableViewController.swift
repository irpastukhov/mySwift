//
//  MyTableViewController.swift
//  мой свифт
//
//  Created by Ivan Pastukhov on 03.10.2022.
//

import UIKit

class MyTableViewController: UITableViewController {

    public var allData2 = [DataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = UIColor(red: 211 / 255, green: 195 / 255, blue: 183 / 255, alpha: 1)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return allData2.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allData2[section].time.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell

        cell.hoursInfoLabel.text = allData2[indexPath.section].hours[indexPath.row]
        cell.timeInfoLabel.text = allData2[indexPath.section].time[indexPath.row]
        
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let hoursSum = allData2[section].hoursSum
        
        var endingOfHours = "hours"
        if hoursSum == 1 {
            endingOfHours = "hour"
        }
        
        var dataHours: String
        if hoursSum == Float(round(hoursSum)) {
            let hours2 = Int(round(hoursSum))
            dataHours = "\(hours2) \(endingOfHours)"
        } else {
            dataHours = "\(hoursSum) \(endingOfHours)"
        }
        
        return ("\(allData2[section].date)   —   \(dataHours)")
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 17)
        header.textLabel?.textColor = UIColor.black
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
