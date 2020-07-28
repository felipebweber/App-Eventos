//
//  EventViewModelTests.swift
//  App-EventosTests
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa
@testable import App_Eventos

class EventViewModelTests: XCTestCase {
    var eventViewModel: EventViewModel!
    var disposeBag: DisposeBag!
    var mockEventAPI: MockEventAPI!
    
    override func setUp() {
        super.setUp()
        
        mockEventAPI = MockEventAPI()
        
        eventViewModel = EventViewModel(eventApi: mockEventAPI)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        self.eventViewModel = nil
        super.tearDown()
    }
    
    func testEventViewModel_for_Events() {
        
        let people1 = Person(id: "1", eventId: "1", name: "name 2", picture: "https://")
        let cupons1 = Cupons(id: "1", eventId: "1", discount: 62)
        
        let evento1 = Event(description: "Event description one", date: 1534784400000, image: "http://", longitude: -51.2146267, latitude: -30.0392981, price: 29.9, title: "Event title 1", id: "1", people: [people1], cupons: [cupons1])
        
        
        let people2 = Person(id: "1", eventId: "1", name: "name 2", picture: "https://")
        let cupons2 = Cupons(id: "1", eventId: "1", discount: 42)
        
        let evento2 = Event(description: "Event description two", date: 1534784400000, image: "http://", longitude: -51.2148497, latitude: -30.037878, price: 59.99, title: "Event title 1", id: "1", people: [people2], cupons: [cupons2])
        
        mockEventAPI.fetchEventsResult = [evento1, evento2]
        mockEventAPI.success = true
        
        eventViewModel.fetchEvents()
        
        let expactations = expectation(description: "Get events")
        
        eventViewModel.events.subscribe(onNext: { eventos in
            XCTAssertEqual(eventos[0].id, evento1.id)
            XCTAssertEqual(eventos[0].date, evento1.date)
            XCTAssertEqual(eventos[0].description, evento1.description)
            XCTAssertEqual(eventos[0].image, evento1.image)
            XCTAssertEqual(eventos[0].longitude, evento1.longitude)
            XCTAssertEqual(eventos[0].latitude, evento1.latitude)
            XCTAssertEqual(eventos[0].price, evento1.price)
            XCTAssertEqual(eventos[0].title, evento1.title)
            
            XCTAssertEqual(eventos[0].people[0].id, evento1.people[0].id)
            XCTAssertEqual(eventos[0].people[0].eventId, evento1.people[0].eventId)
            XCTAssertEqual(eventos[0].people[0].name, evento1.people[0].name)
            XCTAssertEqual(eventos[0].people[0].picture, evento1.people[0].picture)
            
            XCTAssertEqual(eventos[0].cupons[0].id, evento1.cupons[0].id)
            XCTAssertEqual(eventos[0].cupons[0].eventId, evento1.cupons[0].eventId)
            XCTAssertEqual(eventos[0].cupons[0].discount, evento1.cupons[0].discount)
            
            XCTAssertEqual(eventos[1].id, evento2.id)
            XCTAssertEqual(eventos[1].date, evento2.date)
            XCTAssertEqual(eventos[1].description, evento2.description)
            XCTAssertEqual(eventos[1].image, evento2.image)
            XCTAssertEqual(eventos[1].longitude, evento2.longitude)
            XCTAssertEqual(eventos[1].latitude, evento2.latitude)
            XCTAssertEqual(eventos[1].price, evento2.price)
            XCTAssertEqual(eventos[1].title, evento2.title)
            
            XCTAssertEqual(eventos[1].people[0].id, evento2.people[0].id)
            XCTAssertEqual(eventos[1].people[0].eventId, evento2.people[0].eventId)
            XCTAssertEqual(eventos[1].people[0].name, evento2.people[0].name)
            XCTAssertEqual(eventos[1].people[0].picture, evento2.people[0].picture)
            
            XCTAssertEqual(eventos[1].cupons[0].id, evento2.cupons[0].id)
            XCTAssertEqual(eventos[1].cupons[0].eventId, evento2.cupons[0].eventId)
            XCTAssertEqual(eventos[1].cupons[0].discount, evento2.cupons[0].discount)
            
            
            expactations.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expactations], timeout: 0.1)
    }
}
