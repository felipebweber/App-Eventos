//
//  DescriptionViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift

final class DescriptionViewController: UIViewController {
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var titleEventLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var personLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    private var shareEventText = ""
    
    var descriptionViewModel: DescriptionViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionViewModel?.fetchEvent()
        bindFetchError()
        bindShared()
    }
    
    private func bindFetchError() {
        descriptionViewModel?.fetchError.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] fetchError in
                switch fetchError {
                case .failNetworking:
                    self?.showError(.failNetworking)
                case .none:
                    self?.bind()
                case .itemNotFound:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        descriptionViewModel?.event.asObservable()
            .subscribe(onNext: { event in
                if let event = event {
                    self.configureView(event: event)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindShared() {
        descriptionViewModel?.event.asObservable()
            .subscribe(onNext: { event in
                if let event = event {
                    self.shareEventText = "\(String(describing: event.title))\n \(String(describing: event.description))\n Vai acontecer em: \(String(describing: Double(event.date).dateFormat()))\n Valor do evento: R$ \(event.price)"
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureView(event: Event) {
        image.setImage(with: URL(string: event.image))
        titleEventLabel.text = event.title
        dateLabel.text = "Dia e hora: \(Double(event.date).dateFormat())"
        personLabel.text = "Responsável: \(event.people.first?.name ?? "Não informado")"
        priceLabel.text = "R$ \(event.price)"
        descriptionTextView.text = event.description
    }
    
    @IBAction private func checkIn(_ sender: Any) {
        if let eventId = descriptionViewModel?.eventId {
            let controller = storyboard?.instantiateViewController(identifier: "checkIn") as! ConfirmEventViewController
            let checkInViewModel = CheckInViewModel(eventId: eventId)
            controller.checkInViewModel = checkInViewModel
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction private func shareButton(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [shareEventText], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    fileprivate func showError(_ fetchError: FetchError) {
        var title = String()
        var message = String()
        switch fetchError {
        case .none:
            break
        case .failNetworking:
            title = "Erro de rede"
            message = "Verifique a conexão de rede"
        case .itemNotFound:
            break
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
