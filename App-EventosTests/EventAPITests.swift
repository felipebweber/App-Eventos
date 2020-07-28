//
//  EventAPITests.swift
//  App-EventosTests
//

import XCTest
@testable import App_Eventos
import OHHTTPStubs

class EventAPITests: XCTestCase {
    
    var sut: EventAPI!
    
    let path = Bundle.main.path(forResource: "jsonEvents", ofType: "json")
    
    override func setUp() {
        super.setUp()
        sut = EventAPI()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testEventApi_when_isGetResoucesDownInternet() {
        guard let path = path else { return }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
        
        //MARK: - Given
        stub(condition: { (requestURl) -> Bool in
            return requestURl.url?.absoluteString.contains("events")  ?? false
        }) { (response) -> HTTPStubsResponse in
            return HTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        var expectedResponse = [Event]()
        let exception = self.expectation(description: "calling Api failed!")
        var expectedResult: Bool = false
        
        //MARK: - When
        let worker: EventAPI? = EventAPI()
        worker?.fetchEvents(completion: { (result, events) in
            expectedResponse = events
            expectedResult = result
            exception.fulfill()
        })
        
        //MARK: - Then
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(expectedResponse)
        XCTAssertTrue(expectedResult)
        XCTAssertTrue(expectedResponse.count==3, "Not Matched")
    }
}
