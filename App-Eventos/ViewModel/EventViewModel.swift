//
//  EventViewModel.swift
//  App-Eventos
//

import Foundation
import RxSwift
import RxCocoa

final class EventViewModel {
    private let eventsPublish: PublishSubject<[Event]> = PublishSubject()
    private let errorPublish: PublishSubject<FetchError> = PublishSubject()
    
    let events = BehaviorRelay<[Event]>(value: [])
    let fetchError = BehaviorRelay<FetchError>(value: .none)
    
    private let disposeBag = DisposeBag()
    
    private var eventApi = EventAPI()
    
    init() {
        bindOutputFetchError()
        bindOutput()
    }
    
    func bindOutput() {
        eventsPublish.asObserver()
            .bind(to: events)
            .disposed(by: disposeBag)
    }
    
    func bindOutputFetchError() {
        errorPublish.asObserver()
            .bind(to: fetchError)
            .disposed(by: disposeBag)
    }
}

extension EventViewModel {
    func fetchEvents() {
        eventApi.fetchEvents { result, events in
            if result {
                self.eventsPublish.onNext(events)
            } else {
                self.errorPublish.onNext(FetchError.failNetworking)
            }
        }
    }
}
