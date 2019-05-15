//
//  NewsRequest.swift
//  News Reader
//
//  Created by MacOS on 4/2/19.
//  Copyright © 2019 MacOS. All rights reserved.
//

import Foundation
import UIKit

class Request {
    func newsRequest(name : Int,country : String,typeOfNews : String,closure : @escaping (NewsJson?,Error?) ->Void){
        var str = "https://newsapi.org/v2/top-headlines?country=\(country)&pageSize=5&page=\(name)&\(typeOfNews)&apiKey=d3ab9511b1524555a5b087d66eca941c"
        str = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: str) else{print("bad URL")
            return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) {
            ( data, response, error) in
            if error == nil {
                
                do {
                    let place = try JSONDecoder().decode(NewsJson.self, from: data!)
                    closure(place,nil)
                }
                catch {
                    closure(nil,error)
                }
            }
            }.resume()
    }
}
