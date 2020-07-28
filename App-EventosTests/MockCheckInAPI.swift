//
//  MockCheckInAPI.swift
//  App-EventosTests
//

import XCTest
@testable import App_Eventos

final class MockCheckInAPI: CheckInAPI {
    var chekcInStatus: CheckInStatus = .none
    
    override func checkIn(eventId: String, name: String, email: String, completion: @escaping(CheckInStatus) -> Void) {
        completion(chekcInStatus)
    }
}
