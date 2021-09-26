//
//  PricesTableViewCell.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 25.06.2021.
//

import UIKit

class PricesTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //We set the PricesTableViewCell as the delegate of textfields because we want to use keyboard's buttons
//        alis.delegate = self
//        satis.delegate = self
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //We dissmiss the keyboard by using thes function
//        textField.resignFirstResponder()
//        return true
//    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var alis: UILabel!
    @IBOutlet weak var satis: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
