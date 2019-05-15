//
//  jsonData.swift
//  News Reader
//
//  Created by MacOS on 4/2/19.
//  Copyright © 2019 MacOS. All rights reserved.
//

import Foundation


struct NewsJson : Codable {
    let status : String
    let totalResults : Int
    let articles : [News]
    
    enum CodingKeys : String,CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
}
struct News  : Codable {
    let source : SourceOfNews
    let author : String?
    let title : String?
    let description : String?
    let url : String
    let urlToImage : String?
    let publishedAt: String
    
    enum CodingKeys : String,CodingKey {
        case author = "author"
        case publishedAt = "publishedAt"
        case title = "title"
        case source = "source"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
    }
    
    struct SourceOfNews : Codable{
        let name : String?
        enum CodingKeys : String,CodingKey {
            case name = "name"
        }
    }
}
