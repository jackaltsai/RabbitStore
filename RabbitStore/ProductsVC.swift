//
//  ProductsVC.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/3.
//

import UIKit

class ProductsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let apiKey = "key5GfBm1fhMHnU29"
    
    
    private var searchedProducts: [Product.List.Record]!
    private var items = [Product.List.Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        fetchProducts()
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if searchText.isEmpty {
            
            fetchProducts()
            
        } else {
            
            let baseStr = "https://api.airtable.com/v0/appjIlXjle9FOzU0c/Rabbit?filterByFormula=("
            let urlStr = "{name}+=+'\(searchText)')"
            let encodingURL = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: #""%=<>[\]^`{|}"#).inverted)!
            //            print(baseStr + encodingURL)
            let url = URL(string: baseStr + encodingURL)!
            var request = URLRequest(url: url)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data,
                   let content = String(data: data, encoding: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        print(content)
                        
                        let result = try decoder.decode(Product.List.self, from: data)
                        //                    print(result)
                        for value in result.records {
                            print(value.fields.name)
                            self.items = result.records
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
        tableView.reloadData()
    }
    
    
    func fetchProducts() {
        let url = URL(string: "https://api.airtable.com/v0/appjIlXjle9FOzU0c/Rabbit?sort%5B0%5D%5Bfield%5D=name&sort%5B0%5D%5Bdirection%5D=asc")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                let decoder = JSONDecoder()
                do {
                    print(content)
                    
                    let result = try decoder.decode(Product.List.self, from: data)
                    //                    print(result)
                    for value in result.records {
                        print(value.fields.name)
                        self.items = result.records
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProductCell.self)", for: indexPath) as! ProductCell
        
        let item = items[indexPath.row]
        
        cell.nameLabel?.text = item.fields.name
        
        return cell
    }
    
    
    
    // 不想顯示刪除鈕可回傳.none
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    /* UITableViewDelegate的方法，後端左滑修改與刪除資料 */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        /* delete action */
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
            let product = self.items[indexPath.row]
            self.items.remove(at: indexPath.row)
            let url = URL(string: "https://api.airtable.com/v0/appjIlXjle9FOzU0c/Rabbit/\(product.id)")!
            var request = URLRequest(url: url)
            request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    /* 刪除成功時 http status code 為 200 */
                    print(httpResponse.statusCode)
                }
                
            }.resume()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        delete.backgroundColor = .red
        // delete.image = UIImage(named: "delete")
        
        /* [delete, edit]*/
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        // true代表左滑到底視同觸發第一個動作；false代表左滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let product = items[indexPath.row]
            let detailVC = segue.destination as! DetailVC
            detailVC.product = product
        }
    }
    
}
