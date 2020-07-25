//
//  EventManager.swift
//  App-Eventos
//

import Foundation

final class EventViewModel {
    private var eventApi = EventAPI()
}

extension EventViewModel {
    func fetchEvent() {
        eventApi.fetchEventRequest { (result, data) in
            if result {
//                self.parseJSON(data)
            } else {
                print("Erro de conexão")
            }
        }
    }
}
