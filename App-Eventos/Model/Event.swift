//
//  EventDataResponse.swift
//  App-Eventos
//

import Foundation

struct Event: Codable {
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
