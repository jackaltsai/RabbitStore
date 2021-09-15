//
//  DetailVC.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/3.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbIsbn: UILabel!
    @IBOutlet weak var lbSellingPrice: UILabel!
    @IBOutlet weak var lbPurchasePrice: UILabel!
    @IBOutlet weak var lbWholesalePrice: UILabel!
    @IBOutlet weak var lbProfit: UILabel!
    @IBOutlet weak var lbPlatformPrice: UILabel!
    @IBOutlet weak var lbJapanPrice: UILabel!
    @IBOutlet weak var lbShelfNumber: UILabel!
    @IBOutlet weak var lbSpecificetion: UILabel!
    @IBOutlet weak var lbInventory: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbBrandNo: UILabel!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    @IBOutlet weak var lbNote: UILabel!
    
    var product: Product.List.Record!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.title = product.fields.name
        lbProductName.text = product.fields.name
        lbCategory.text = product.fields.category
        lbIsbn.text = "\(product.fields.isbn ?? 0)"
        lbSellingPrice.text = "\(product.fields.selling_price ?? 0)"
        lbPurchasePrice.text = "\(product.fields.purchase_price ?? 0)"
        lbWholesalePrice.text = "\(product.fields.wholesale_price ?? 0)"
        lbProfit.text = "\(product.fields.profit ?? 0)"
        lbPlatformPrice.text = "\(product.fields.platform_price ?? 0)"
        lbJapanPrice.text = "\(product.fields.japan_price ?? 0)"
        lbShelfNumber.text = product.fields.shelf_number
        lbSpecificetion.text = product.fields.specification
        lbInventory.text = "\(product.fields.inventory ?? 0)"
        lbDescription.text = product.fields.product_description
        lbName.text = product.fields.brand_name
        lbBrandNo.text = product.fields.brand_no
        lbPhoneNumber.text = product.fields.phone_number
        lbNote.text = product.fields.note
    }
}
