//
//  EventDataResponse.swift
//  App-Eventos
//

import Foundation

struct Event: Codable, Equatable {
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    let description: String
    let date: Int
    let image: String
    let longitude: Double
    let latitude: Double
    let price: Double
    let title: String
    let id: String
    
    let people: [Person]
    let cupons: [Cupons]
}
