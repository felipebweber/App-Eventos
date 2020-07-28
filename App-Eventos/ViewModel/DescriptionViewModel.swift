//
//  DescriptionViewModel.swift
//  App-Eventos
//

import Foundation
import RxSwift
import RxCocoa

final class DescriptionViewModel {
    private let eventPublish: PublishSubject<Event> = PublishSubject()
    private let errorPublish: PublishSubject<FetchError> = PublishSubject()
    
    private var eventApi: EventAPI!
    
    let event = BehaviorRelay<Event?>(value: nil)
    let fetchError = BehaviorRelay<FetchError>(value: .none)
    
    private let disposeBag = DisposeBag()
    let eventId: String
    
    /// Initializes a new view model
    /// - Parameter eventId: a `String` with the event id
    /// - Parameter eventApi: a `EventAPI`
    init(eventId: String, eventApi: EventAPI) {
        self.eventId = eventId
        self.eventApi = eventApi
        bindOutput()
    }
    
    private func bindOutput() {
        eventPublish.asObserver()
            .bind(to: event)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputFetchError() {
        errorPublish.asObserver()
            .bind(to: fetchError)
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
