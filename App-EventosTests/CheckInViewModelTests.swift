//
//  CheckInViewModelTests.swift
//  App-EventosTests
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa
@testable import App_Eventos

class CheckInViewModelTests: XCTestCase {
    
    var checkInViewModel: CheckInViewModel!
    var disposeBag: DisposeBag!
    var mockCheckInAPI: MockCheckInAPI!
    
    override func setUp() {
        super.setUp()
        
        mockCheckInAPI = MockCheckInAPI()
        checkInViewModel = CheckInViewModel(eventId: "1", checkInApi: mockCheckInAPI)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        self.checkInViewModel = nil
        self.disposeBag = nil
        super.tearDown()
    }
    
    
    func testCheckInViewModel_for_CheckInSuccess() {
        
        mockCheckInAPI.chekcInStatus = .success
        
        checkInViewModel.checkIn(name: "Name", email: "Email")
        
        let expactations = expectation(description: "Check-in Status")
        
        checkInViewModel.check.subscribe(onNext: { checkInStatus in
            XCTAssertEqual(checkInStatus, CheckInStatus.success)
            expactations.fulfill()
        })
            .disposed(by: disposeBag)
        wait(for: [expactations], timeout: 0.1)
    }
    
    func testCheckInViewModel_for_CheckInFail() {
        
        mockCheckInAPI.chekcInStatus = .fail
        
        checkInViewModel.checkIn(name: "Name", email: "Email")
        
        let expactations = expectation(description: "Check-in Fail")
        
        checkInViewModel.check.subscribe(onNext: { checkInStatus in
            XCTAssertEqual(checkInStatus, CheckInStatus.fail)
            expactations.fulfill()
        })
            .disposed(by: disposeBag)
        wait(for: [expactations], timeout: 0.1)
    }
}
