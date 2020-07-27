//
//  CheckInViewModel.swift
//  App-Eventos
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class CheckInViewModel {
    private let checkInPublish: PublishSubject<CheckInStatus> = PublishSubject()
    let check = BehaviorRelay<CheckInStatus>(value: .none)
    let bag = DisposeBag()
    
    private let eventId: String
    var name: Driver<String>?
    var email: Driver<String>?
    var credentialsValid: Driver<Bool>?
    
    let checkInApi = CheckInAPI()
    
    init(eventId: String) {
        self.eventId = eventId
        bindOutput()
    }
    
    func bindOutput() {
        checkInPublish.asObserver()
            .bind(to: check)
            .disposed(by: bag)
    }
    
    func validate() {
        let nameValid = name!
            .distinctUntilChanged()
            .throttle(.milliseconds(300))
            .map { $0.utf8.count > 3}
        let emailValid = email!
            .distinctUntilChanged()
            .throttle(.milliseconds(300))
            .map { $0.utf8.count > 3 }
        credentialsValid = Driver.combineLatest(nameValid, emailValid) { $0 && $1 }
    }
}

extension CheckInViewModel {
    func checkIn(name: String, email: String) {
        checkInApi.checkIn(eventId: eventId, name: name, email: email) { checkInStatus in
            switch checkInStatus {
            case .success:
                self.checkInPublish.onNext(.success)
            case .fail:
                self.checkInPublish.onNext(.fail)
            case .none:
                self.checkInPublish.onNext(.none)
            }
        }
    }
}

