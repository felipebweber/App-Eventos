//
//  DescriptionViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift

final class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleEventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var shareEventText = ""
    
    var descriptionViewModel: DescriptionViewModel?
    private let bag = DisposeBag()
    
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
            }).disposed(by: bag)
    }
    
    private func bindShared() {
        descriptionViewModel?.event.asObservable()
            .subscribe(onNext: { event in
                if let event = event {
                    self.shareEventText = "\(String(describing: event.title))\n \(String(describing: event.description))\n It will happen in: \(String(describing: Double(event.date).dateFormat()))\n Event price: R$ \(event.price)"
                }
            }).disposed(by: bag)
    }
    
    private func configureView(event: Event) {
        image.setImage(with: URL(string: event.image))
        titleEventLabel.text = event.title
        dateLabel.text = "Dia e hora: \(Double(event.date).dateFormat())"
        personLabel.text = "Responsável: \(event.people.first?.name ?? "Não informado")"
        priceLabel.text = "R$ \(event.price)"
    }
    
    @IBAction func checkIn(_ sender: Any) {
        if let eventId = descriptionViewModel?.eventId {
            let controller = storyboard?.instantiateViewController(identifier: "checkIn") as! ConfirmEventViewController
            let checkInViewModel = CheckInViewModel(eventId: eventId)
            controller.checkInViewModel = checkInViewModel
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [shareEventText], applicationActivities: nil)
                present(activityViewController, animated: true)
    }
    
}
