//
//  DescriptionViewModel.swift
//  App-Eventos
//

import Foundation
import RxSwift
import RxCocoa

final class DescriptionViewModel {
    private let eventPublish: PublishSubject<Event> = PublishSubject()
    private let errorPublish: PublishSubject<Error> = PublishSubject()
    
    private let eventApi = EventAPI()
    let event = BehaviorRelay<Event?>(value: nil)
    private let disposeBag = DisposeBag()
    let eventId: String
    
    init(eventId: String) {
        self.eventId = eventId
        bindOutput()
    }
    
    func bindOutput() {
        eventPublish.asObserver()
            .bind(to: event)
            .disposed(by: disposeBag)
    }
}

extension DescriptionViewModel {
    func fetchEvent() {
        eventApi.fetchEvent(eventId: eventId) { result, event in
            if result {
                guard let event = event else { return self.errorPublish.onNext(FetchError.itemNotFound) }
                self.eventPublish.onNext(event)
            } else {
                self.errorPublish.onNext(FetchError.failNetworking)
            }
        }
    }
}
