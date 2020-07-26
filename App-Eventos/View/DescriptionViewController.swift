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
    
    var descriptionViewModel: DescriptionViewModel?
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionViewModel?.fetchEvent()
        bind()
    }
    
    private func bind() {
        descriptionViewModel?.event.asObservable()
            .subscribe(onNext: { event in
                if let event = event {
                    self.configureView(event: event)
                }
            }).disposed(by: bag)
    }
    
    private func configureView(event: Event) {
        titleEventLabel.text = event.title
        priceLabel.text = "\(event.price)"
    }
    
    @IBAction func checkIn(_ sender: Any) {
        if let eventId = descriptionViewModel?.eventId {
            let controller = storyboard?.instantiateViewController(identifier: "checkIn") as! ConfirmEventViewController
            let checkInViewModel = CheckInViewModel(eventId: eventId)
            controller.checkInViewModel = checkInViewModel
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
