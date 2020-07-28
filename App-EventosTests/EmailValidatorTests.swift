//
//  EmailValidatorTests.swift
//  App-EventosTests
//

import XCTest
@testable import App_Eventos

class EmailValidatorTests: XCTestCase {
    var sut: EmailValidator!
    
    override func setUp() {
        super.setUp()
        sut = EmailValidator()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testEmailValidator_when_theEmailIsValid() {
        let email = "email@evento.com"
        let notEmail = "email@e.c"
        
        let emailValid = sut.validate(email)
        let emailNotValid = sut.validate(notEmail)
        
        XCTAssert(emailValid==true, "email has been validated")
        XCTAssert(emailNotValid==false, "email has not been validated")
    }
}
