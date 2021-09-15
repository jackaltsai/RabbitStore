//
//  ProductCell.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/4.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
