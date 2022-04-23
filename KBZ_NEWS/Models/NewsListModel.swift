//
//  NewsListModel.swift
//  KBZ_NEWS
//
//  Created by Kyaw Ye Htun on 23/04/2022.
//

import Foundation
import ObjectMapper

class NewsListModel : Mappable {
    
    var articles : [resultsMapperResponse]?
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        articles <- map["articles"]
    }
        
}

class resultsMapperResponse : Mappable {
    
    var author: String?
    var title: String?
    var description: String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    required init?(map: Map) {
        
    }
    
    
    
    func mapping(map: Map) {
        
        author <- map["author"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
    
}
