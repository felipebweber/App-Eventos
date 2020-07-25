//
//  EventAPI.swift
//  App-Eventos
//

import Foundation
import Alamofire

final class EventAPI: NSObject {
    
    private let url = "https://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    
    func fetchEventRequest(completion: @escaping(Bool , [Event]) -> Void) {
        AF.request(url).responseDecodable { (response: DataResponse<[Event], AFError>) in
            switch response.result {
            case .success(let events):
                completion(true, events)
            case .failure(_):
                completion(false, [])
            }
        }
    }
}
