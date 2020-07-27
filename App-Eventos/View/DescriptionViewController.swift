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
    @IBOutlet private weak var localLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    private var shareEventText = ""
    
    var descriptionViewModel: DescriptionViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionViewModel?.fetchEvent()
        bind()
        bindShared()
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
    
}
