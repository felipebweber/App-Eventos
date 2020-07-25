//
//  EventAPI.swift
//  App-Eventos
//

import Foundation
import Alamofire

class EventAPI: NSObject {
    
    let url = "https://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    
    func fetchEventRequest(completion: @escaping(Bool , Data) -> Void) {
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    completion(true , responseData)
                }
            case .failure:
                completion(false, Data())
            }
        }
    }
}
