//
//  Product.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/3.
//

import Foundation

struct Product: Equatable{
    
    struct List:Decodable {
        let records: [Record]
        
        struct Record: Codable {
            let id: String
            let fields: Fields
        }
        
        struct Fields: Codable {
            let name: String? // 商品名稱
            let category: String? // 類別
            let isbn: Int? // ISBN
            let selling_price: Int? // 售價
            let purchase_price: Int? // 進價
            let wholesale_price: Int? // 批發價
            let profit: Int? // 利潤
            let platform_price: Int? // 平台售價
            let japen_price: Int? // 日幣價格
            let shelf_number: String? // 貨架編號
            let specification: String? // 規格
            let inventory: Int? // 庫存數量
            let product_description: String? //商品簡介
            let brand_no: String? // 廠商代號
            let brand_name: String? // 廠商名稱
            let phone_number: String? // 廠商電話
            let note: String? // 備註
//            let photos: [ImageData]
        }
    }
    
    struct Create:Encodable {
        let records: [Record]
        struct Record: Codable {
            let fields: Fields
        }
        
        struct Fields: Codable {
            let name: String? // 商品名稱
            let category: String? // 類別
            let isbn: Int? // ISBN
            let selling_price: Int? // 售價
            let purchase_price: Int? // 進價
            let wholesale_price: Int? // 批發價
            let profit: Int? // 利潤
            let platform_price: Int? // 平台售價
            let japen_price: Int? // 日幣價格
            let shelf_number: String? // 貨架編號
            let specification: String? // 規格
            let inventory: Int? // 庫存數量
            let product_description: String? //商品簡介
            let brand_no: String? // 廠商代號
            let brand_name: String? // 廠商名稱
            let phone_number: String? // 廠商電話
            let note: String? // 備註
            let photos: [ImageData]
        }
        
    }
    
    struct Update:Encodable {
        
        let records: [Record]
        struct Record: Codable {
            
            let fields: Fields
        }
        
        struct Fields: Codable {
            let name: String? // 商品名稱
            let category: String? // 類別
            let isbn: Int? // ISBN
            let selling_price: Int? // 售價
            let purchase_price: Int? // 進價
            let wholesale_price: Int? // 批發價
            let profit: Int? // 利潤
            let platform_price: Int? // 平台售價
            let japen_price: Int? // 日幣價格
            let shelf_number: String? // 貨架編號
            let specification: String? // 規格
            let inventory: Int? // 庫存數量
            let product_description: String? //商品簡介
            let brand_no: String? // 廠商代號
            let brand_name: String? // 廠商名稱
            let phone_number: String? // 廠商電話
            let note: String? // 備註
            let photos: [ImageData]
        }
        
    }
    
    struct Delete:Decodable {
        let records: [Record]
        struct Record: Codable {
            let deleted: Bool
        }
    }
    
}

