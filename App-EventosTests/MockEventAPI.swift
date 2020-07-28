//
//  MockEventAPI.swift
//  App-EventosTests
//

import XCTest
@testable import App_Eventos

final class MockEventAPI: EventAPI {
    var fetchEventsResult: [Event] = [Event]()
    var success: Bool = false
    var event: Event?
    
    override func fetchEvents(completion: @escaping (Bool, [Event]) -> Void) {
        completion(success, fetchEventsResult)
    }
    
    override func fetchEvent(eventId: String, completion: @escaping(Bool , Event?) -> Void) {
        completion(success, event)
    }
}
