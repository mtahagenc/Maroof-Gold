//
//  MultipliersTableViewCell.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 21.08.2021.
//

import UIKit

class MultipliersTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var alis: UITextField!
    @IBOutlet weak var satis: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        alis.delegate = self
        satis.delegate = self
        // Initialization code
        
        
        //You can specify your own selector to be send in "myAction"
        alis.addDoneButtonToKeyboard(action:  #selector(self.alis.resignFirstResponder))
        satis.addDoneButtonToKeyboard(action:  #selector(self.satis.resignFirstResponder))
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //In the decimal pad there is "," instead of "." but we cannot use "," in double so we change the it with "." everytime it typed.
        if string == "," {
            textField.text = textField.text! + "."
            return false
        }
        return true     // Could also filter on numbers only
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
