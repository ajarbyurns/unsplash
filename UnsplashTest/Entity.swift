//
//  Entity.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import Foundation

struct ItemResponse : Decodable {
    let total: Int?
    let total_pages : Int?
    let results : [Item]?
    let errors : [String]?
}

struct Item : Decodable {
    let width : Int?
    let height : Int?
    let urls : ItemURL?
}

struct ItemURL : Decodable {
    let full : String?
    let regular : String?
    let small : String?
}
