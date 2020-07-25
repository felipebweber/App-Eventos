//
//  EventManager.swift
//  App-Eventos
//

import Foundation

class EventManager {
    private var eventApi = EventAPI()
}

extension EventManager {
    func fetchEvent() {
        eventApi.fetchEventRequest { (result, data) in
            if result {
                self.parseJSON(data)
            } else {
                print("Erro de conexão")
            }
        }
    }
    
    private func parseJSON(_ eventData: Data) {
        var eventList = [EventModel]()
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode([EventDataResponse].self, from: eventData) else { return }
        for i in 0..<decodeData.count {
            eventList.append(EventModel(description: decodeData[i].description, date: decodeData[i].date, image: decodeData[i].image, longitude: decodeData[i].longitude, latitude: decodeData[i].latitude, price: decodeData[i].price, title: decodeData[i].title, id: decodeData[i].id, idPeople: decodeData[i].people[0].id, eventIdPeople: decodeData[i].people[0].eventId, namePeople: decodeData[i].people[0].name, picture: decodeData[i].people[0].picture, idCupons: decodeData[i].cupons[0].id, eventIdCupons: decodeData[i].cupons[0].eventId, discount: decodeData[i].cupons[0].discount))
        }
    }
}
