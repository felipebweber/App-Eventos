//
//  EventAPI.swift
//  App-Eventos
//

import Foundation
import Alamofire

final class EventAPI: NSObject {
    
    private let baseURL = "https://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    
    func fetchEvents(completion: @escaping(Bool , [Event]) -> Void) {
        AF.request(baseURL).responseDecodable { (response: DataResponse<[Event], AFError>) in
            switch response.result {
            case .success(let events):
                completion(true, events)
            case .failure(_):
                completion(false, [])
            }
        }
    }
    
    func fetchEvent(eventId: String, completion: @escaping(Bool , Event?) -> Void) {
        let eventURL = baseURL.appending("/\(eventId)")
        AF.request(eventURL).responseDecodable { (response: DataResponse<Event, AFError>) in
            switch response.result {
            case .success(let event):
                completion(true, event)
            case .failure(_):
                completion(false, nil)
            }
        }
    }
}
