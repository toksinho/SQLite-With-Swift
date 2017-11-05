//
//  EditMuseumVC.swift
//  SQLiteSwiftApp
//
//  Created by Ivica Tokic on 27/10/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import UIKit

//this delegate method will control passing data back from EditMuseumVC to MuseumsTableVC
//so array of museums will be updated with edited data

protocol EditDataTableDelegate {
    func editedDataSaved(_ museum: Museum)
}

class EditMuseumVC: UIViewController {

    @IBOutlet weak var museumNameTxt: UITextField!
    @IBOutlet weak var museumAddressTxt: UITextField!
    var id: Int32?
    var name: String!
    var address: String!
    
    var delegate: EditDataTableDelegate? = nil
    
    @IBAction func saveEditedMuseum(_ sender: Any) {

        if (museumNameTxt.text?.isEmpty)! || (museumAddressTxt.text?.isEmpty)!{
            museumNameTxt.text = "Not set"
            museumAddressTxt.text = "Not set"
        } else {
            let museum = Museum(id: id!, name: museumNameTxt.text!, address: museumAddressTxt.text!)
            DatabaseManager.shared.update(museum)
            delegate?.editedDataSaved(museum)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        museumNameTxt.text = name
        museumAddressTxt.text = address
    }
    
}
