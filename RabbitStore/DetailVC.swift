//
//  DetailVC.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/3.
//

import UIKit

class DetailVC: UIViewController {
    var product: Product.List.Record!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product.fields.name
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
