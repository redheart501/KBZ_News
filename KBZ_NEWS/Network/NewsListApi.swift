//
//  NewsListApi.swift
//  KBZ_NEWS
//
//  Created by Kyaw Ye Htun on 23/04/2022.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public struct ApiClient {
    
    static func getDataFromServer(_ listType : String , complete: @escaping (_ success : Bool , _ data: NewsListModel? )->() ){
        let url = Constants.baseUrl + "top-headlines?category=\(listType)" + "&apiKey=" + Constants.apikey
       let request = Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<NewsListModel>) in
                guard (response.result.value != nil) else {
                    print("Error while fetching Device List: \(String(describing: response.result.error))")
                
                    return
                }

                guard let responseJSON = response.result.value else {
                    print("Invalid tag information received from the service")

                    return
                }

                complete(true, responseJSON)

            }
        print(request.debugDescription)

         
    }
}
