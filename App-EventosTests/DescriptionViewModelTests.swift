//
//  DescriptionViewModelTests.swift
//  App-EventosTests
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa
@testable import App_Eventos

class DescriptionViewModelTests: XCTestCase {
    var descriptionViewModel: DescriptionViewModel!
    var disposeBag: DisposeBag!
    var mockEventAPI: MockEventAPI!
    
    override func setUp() {
        super.setUp()
        
        mockEventAPI = MockEventAPI()
        
        descriptionViewModel = DescriptionViewModel(eventId: "1", eventApi: mockEventAPI)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        self.descriptionViewModel = nil
        self.disposeBag = nil
        super.tearDown()
    }
    
    func testEventViewModel_for_Event() {
        let people = Person(id: "1", eventId: "1", name: "name 1", picture: "https://")
        let cupons = Cupons(id: "1", eventId: "1", discount: 62)
        
        let evento = Event(description: "Event description 1", date: 1534784400000, image: "https://", longitude: -51.2148497, latitude: -30.037878, price: 19.99, title: "Event title descriptio 1", id: "1", people: [people], cupons: [cupons])
        
        
        mockEventAPI.event = evento
        
        mockEventAPI.success = true
        
        descriptionViewModel.fetchEvent()
        
        let expactations = expectation(description: "Get event")
        
        descriptionViewModel.event.subscribe(onNext: { event in
            
            XCTAssertEqual(event?.id, evento.id)
            XCTAssertEqual(event?.description, evento.description)
            XCTAssertEqual(event?.date, evento.date)
            XCTAssertEqual(event?.longitude, evento.longitude)
            XCTAssertEqual(event?.latitude, evento.latitude)
            XCTAssertEqual(event?.price, evento.price)
            XCTAssertEqual(event?.title, evento.title)
            XCTAssertEqual(event?.people[0].eventId, evento.people[0].eventId)
            XCTAssertEqual(event?.people[0].name, evento.people[0].name)
            XCTAssertEqual(event?.people[0].picture, evento.people[0].picture)
            XCTAssertEqual(event?.cupons[0].discount, evento.cupons[0].discount)
            XCTAssertEqual(event?.cupons[0].id, evento.cupons[0].id)
            XCTAssertEqual(event?.cupons[0].eventId, evento.cupons[0].eventId)
            
            expactations.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expactations], timeout: 0.1)
    }
}
