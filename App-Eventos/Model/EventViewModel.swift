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
        eventApi.fetchEventRequest { (result, events) in
            if result {
            } else {
                print("Erro de conexão")
            }
        }
    }
}
