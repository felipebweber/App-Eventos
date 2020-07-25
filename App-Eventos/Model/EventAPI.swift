//
//  EventAPI.swift
//  App-Eventos
//
//  Created by Felipe Weber on 25/07/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation
import Alamofire

class EventAPI: NSObject {
    
    let url = "https://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    
    func fetchEventRequest(completion: @escaping(Bool ,[Dictionary<String, Any>]) -> Void) {
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let responseDictionary = response.value as? [Dictionary<String, Any>] {
                    completion(true , responseDictionary)
                }
            case .failure:
                completion(false, [Dictionary<String, Any>]())
            }
        }
    }
}
