//
//  AddNewVC.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 27/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import UIKit

//this delegate method will control passing data back from AddNewVC to MuseumsTableVC
//so array of museums will be updated with new data
protocol NewDataTableDelegate {
    func newDataSaved(_ museum: Museum)
}

class AddNewVC: UIViewController {

    @IBOutlet weak var museumNameTxt: UITextField!
    @IBOutlet weak var museumAddressTxt: UITextField!
    var id: Int32?
    var delegate: NewDataTableDelegate? = nil
    
    @IBAction func SaveNewMuseum(_ sender: Any) {
        
        if (museumNameTxt.text?.isEmpty)! || (museumAddressTxt.text?.isEmpty)!{
            museumNameTxt.text = "Not set"
            museumAddressTxt.text = "Not set"
        } else {
            id! += 1
            let museum = Museum(id: id!, name: museumNameTxt.text!, address: museumAddressTxt.text!)
            DatabaseManager.shared.insert(museum)
            delegate?.newDataSaved(museum)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
