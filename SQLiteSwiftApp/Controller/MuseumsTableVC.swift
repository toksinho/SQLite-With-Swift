//
//  MuseumsTableVCTableViewController.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 26/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import UIKit

class MuseumsTableVC: UITableViewController {
    
    var museums: [Museum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initially database doesn't exist so it is empty - false, this is only for
        //first time starting the app
        UserDefaults.standard.register(defaults: ["DatabaseState" : false])
        //if true then database is initially filled with data from ZagrebMuseums.plist
        if DatabaseState.instance.getDatabaseState() {
            museums = DatabaseManager.shared.getMuseumsFromDatabase()
        } else {
            fillDatabaseWithMuseums()
            museums = DatabaseManager.shared.getMuseumsFromDatabase()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if museums.count > 0 {
          self.tableView.reloadData()
        }

    }
    
    //get data from ZagrebMuseums.plist and insert them to database
    func fillDatabaseWithMuseums() {
        let museumsPlist = Bundle.main.path(forResource: Constants.pListName, ofType: "plist")
        let arrayOfMuseums = NSArray(contentsOfFile: museumsPlist!) as! Array<Array<String>>
        DatabaseManager.shared.createDatabase()
        var id = 1
        for data in arrayOfMuseums {
            let museum = Museum(id: Int32(id), name: data[0], address: data[1])
            DatabaseManager.shared.insert(museum)
            id += 1
        }
        DatabaseState.instance.setDatabaseState(databaseState: true)
    }

    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return museums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let name = museums[indexPath.row].name
        let address = museums[indexPath.row].address
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = address
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.showEditSegue, sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.showAddNewSegue
        {
            if let destination = segue.destination as? AddNewVC {
                let rowOfArray = museums.count
                destination.id = Int32(rowOfArray)
                destination.delegate = self
                
            }
        }
        if segue.identifier == Constants.showEditSegue
        {
            if let destination = segue.destination as? EditMuseumVC {
                if let indexPath = sender as? IndexPath {
                    destination.id = museums[indexPath.row].id
                    destination.name = museums[indexPath.row].name
                    destination.address = museums[indexPath.row].address
                    destination.delegate = self
                }
            }
        }
    }
}

extension MuseumsTableVC: NewDataTableDelegate, EditDataTableDelegate {
    
    func newDataSaved(_ museum: Museum) {
        museums.append(museum)
    }
    
    func editedDataSaved(_ museum: Museum) {
        let row = Int(museum.id - 1)
        museums[row].name = museum.name
        museums[row].address = museum.address
    }
}

