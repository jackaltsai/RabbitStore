//
//  NewProductTableViewCell.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/8.
//

import UIKit

class NewProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var closure: ((String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(editingChange(_:)), for: .editingChanged)
        
    }

    @objc func editingChange(_ sender: UITextField) {
        closure?(sender.text)
    }
    
    @objc func endingTapped() {
        textField.resignFirstResponder()
    }
    
}
