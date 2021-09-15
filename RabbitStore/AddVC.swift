//
//  AddVC.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/6.
//

import UIKit
import PhotosUI

class AddVC: UIViewController, PHPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    private let apiKey = "key5GfBm1fhMHnU29"
    
    var allCellsPlaceholder: [PlaceholderItem] = [PlaceholderItem(text: "Product Name"),
                                                  PlaceholderItem(text: "category") ,
                                                  PlaceholderItem(text: "ISBN"),
                                                  PlaceholderItem(text: "Selling Price"),
                                                  PlaceholderItem(text: "Purchase Price"),
                                                  PlaceholderItem(text: "Wholesale Price"),
                                                  PlaceholderItem(text: "Profit"),
                                                  PlaceholderItem(text: "Platform Price"),
                                                  PlaceholderItem(text: "Japan Price"),
                                                  PlaceholderItem(text: "Shelf Number"),
                                                  PlaceholderItem(text: "Specification"),
                                                  PlaceholderItem(text: "Count"),
                                                  PlaceholderItem(text: "Product Description"),
                                                  PlaceholderItem(text: "Manufacturer Number"),
                                                  PlaceholderItem(text: "Manufacturer Name"),
                                                  PlaceholderItem(text: "Phone Number"),
                                                  PlaceholderItem(text: "Note"),]
    
    var data: [Item] = [Item(text: ""), Item(text: ""), Item(text: ""),
                        Item(text: ""), Item(text: ""), Item(text: ""),
                        Item(text: ""), Item(text: ""), Item(text: ""),
                        Item(text: ""), Item(text: ""), Item(text: ""),
                        Item(text: ""), Item(text: ""), Item(text: ""),
                        Item(text: ""), Item(text: ""),]
    
    var images: [UIImage]!
    var screenSize: CGSize!
    var imageURL: URL?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [UIImage]()
        setCollectionViewLayout()
        self.tableview.dataSource = self
        self.tableview.delegate = self
        registerForKeyboardNotifications()
    }
    
    func setCollectionViewLayout() {
        screenSize = UIScreen.main.bounds.size
        // 設定UICollectionView背景色
        collectionView.backgroundColor = UIColor.lightGray
        // 取得UICollectionView排版物件
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 設定內容與邊界的間距
        layout.sectionInset = UIEdgeInsets(top: 25, left: 5, bottom: 25, right: 5);
        // 設定每一列的間距
        layout.minimumLineSpacing = 25
        // 設定每個項目的尺寸
        layout.itemSize = CGSize(
            width: CGFloat(screenSize.width)/3 - 10.0,
            height: 128.0)
    }
    
    /* collection View */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = images[indexPath.row]
        let cellId = "imageCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.imageView.image = image
        return cell
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        print("results.count: \(results.count)")
        var images = [UIImage]()
        for result in results {
            // 檢查是否可以載入圖片物件
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
                    if error == nil {
                        if let image = image as? UIImage {
                            images.append(image)
                            PhotoManager.shared.uploadImage(image: image) { data in
                                print(data.link)
                                self?.imageURL = data.link
                            }
                            /* 取得Image數量等於勾選數量時才重刷CollectionView，
                             以避免每取得一張Image就重刷一次 */
                            if images.count == results.count {
                                self!.images += images
                                DispatchQueue.main.async {
                                    self!.collectionView.reloadData()
                                }
                            }
                        }
                    } else {
                        print("error: \(error!.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    
    
    /* keybord textFidld 上移 */
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        tableview.contentInset = contentInsets
        tableview.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableview.contentInset = contentInsets
        tableview.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func clickPickImages(_ sender: Any) {
        // 建立設定物件實體
        var configuration = PHPickerConfiguration()
        // 設定可以挑選的多媒體格式，預設是全部類型
        configuration.filter = .images
        // 可以設定成多種格式
        // configuration.filter = .any(of: [.images,.livePhotos,.videos])
        
        // 設定可選圖片數，預設為1張，如果不想限制可設為0
        configuration.selectionLimit = 0
        // 建立PHPickerViewController物件實體
        let picker = PHPickerViewController(configuration: configuration)
        // 設定PHPickerViewControllerDelegate
        picker.delegate = self
        // 跳出選取畫面
        present(picker, animated: true)
    }
    
    
    
    
    /* 新增 */
    @IBAction func clickAdd(_ sender: Any) {
        // is Empty
        
        
        let productName = data[0].text ?? ""
        let category = data[1].text ?? ""
        let isbn = Int((data[2].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let sellingPrice = Int((data[3].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let purchasePrice = Int((data[4].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let approval = Int((data[5].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let profit = Int((data[6].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let platformPrice = Int((data[7].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let japanPrice = Int((data[8].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let productNo = data[9].text ?? ""
        let specification = data[10].text ?? ""
        let count = Int((data[11].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
        let productDescription = data[12].text ?? ""
        let codeName = data[13].text ?? ""
        let manufacturerName = data[14].text ?? ""
        let phoneNumber = data[15].text ?? ""
        let note = data[16].text ?? ""

        
        
        
        
        
        let productBody = Product.Create(records: [.init(fields: .init(name: productName, category: category, isbn: isbn, selling_price: sellingPrice, purchase_price: purchasePrice, wholesale_price: approval, profit: profit, platform_price: platformPrice, japan_price: japanPrice, shelf_number: productNo, specification: specification, inventory: count, product_description: productDescription, brand_no: codeName, brand_name: manufacturerName, phone_number: phoneNumber, note: note, photos: [ImageData.init(url: (imageURL ?? URL(string: "https://i.imgur.com/DfaKczq.png"))!)]))])
        
        let url = URL(string: "https://api.airtable.com/v0/appjIlXjle9FOzU0c/Rabbit")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.string(from: Date())
        encoder.dateEncodingStrategy = .formatted(formatter)
        request.httpBody = try? encoder.encode(productBody)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
                
            }
        }.resume()
    }
}



// MARK: - UITableViewDataSource
extension AddVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    // 針對特定的IndexPath去建立Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewProductCell") as? NewProductTableViewCell {
            
            cell.textField.placeholder = allCellsPlaceholder[indexPath.row].text
            cell.textField.text = data[indexPath.row].text
            // add cell clear Mode always or whileEditing
            cell.textField.clearButtonMode = .always
            cell.closure = { [weak self] text in
                self?.data[indexPath.row] = Item(text: text)
//                print("row \(indexPath.row) text has changed to \(text)")
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        10
//    }
}

// MARK: - UITableViewDelegate
extension AddVC: UITableViewDelegate {
    
}
