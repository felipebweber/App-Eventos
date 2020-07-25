//
//  EventManager.swift
//  App-Eventos
//

import Foundation
import RxSwift
import RxCocoa

final class EventViewModel {
    private let eventsPublish: PublishSubject<[Event]> = PublishSubject()
    private let errorPublish: PublishSubject<Error> = PublishSubject()
    
    let events = BehaviorRelay<[Event]>(value: [])
    private let bag = DisposeBag()
    
    private var eventApi = EventAPI()
    
    enum FetchError: Error {
        case error
    }
    
    init() {
       bindOutput()
    }
    
    func bindOutput() {
        eventsPublish.asObserver()
            .bind(to: events)
        .disposed(by: bag)
    }
}

extension EventViewModel {
    func fetchEvent() {
        eventApi.fetchEventRequest { (result, events) in
            if result {
                self.eventsPublish.onNext(events)
            } else {
                self.errorPublish.onNext(FetchError.error)
            }
        }
    }
}
