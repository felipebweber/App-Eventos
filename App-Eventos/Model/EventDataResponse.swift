//
//  EventDataResponse.swift
//  App-Eventos
//

import Foundation

struct EventDataResponse: Codable {
    let description: String
    let date: Int
    let image: String
    let longitude: Double
    let latitude: Double
    let price: Double
    let title: String
    let id: String
    
    let people: [People]
    let cupons: [Cupons]
}
extension EventDataResponse {
    struct People: Codable {
        let id: String
        let eventId: String
        let name: String
        let picture: String
    }
    
    struct Cupons: Codable {
        let id: String
        let eventId: String
        let discount: Int
    }
}
