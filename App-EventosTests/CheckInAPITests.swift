//
//  CheckInAPITests.swift
//  App-EventosTests
//

import XCTest
@testable import App_Eventos
import OHHTTPStubs

class CheckInAPITests: XCTestCase {
    var sut: CheckInAPI!
    
    let json = [
        "code": "200"
    ]
    
    override func setUp() {
        super.setUp()
        sut = CheckInAPI()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCheckInApi_when_PostCheckInEvent() {
        let eventId = "1"
        let name = "Fulano de Tal"
        let email = "email@email.com.br"
        
        //MARK: - Given
        stub(condition: { (requestURl) -> Bool in
            return requestURl.url?.absoluteString.contains("checkin")  ?? false
        }) { (response) -> HTTPStubsResponse in
            return HTTPStubsResponse(jsonObject: self.json, statusCode: 200, headers: nil)
        }
        
        let exception = self.expectation(description: "calling Api failed!")
        var expectedResult: CheckInStatus = .none
        
        //MARK: - When
        let worker:CheckInAPI? = CheckInAPI()
        worker?.checkIn(eventId: eventId, name: name, email: email, completion: { checkInStatus in
            expectedResult = checkInStatus
            exception.fulfill()
        })
        
        //MARK: - Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(expectedResult, CheckInStatus.success)
        XCTAssertNotEqual(expectedResult, CheckInStatus.fail)
    }
    
}
