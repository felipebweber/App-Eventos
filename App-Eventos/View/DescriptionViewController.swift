//
//  DescriptionViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift

class DescriptionViewController: UIViewController {

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
    
    func bind() {
        descriptionViewModel?.event.asObservable()
            .subscribe(onNext: { event in
                if let event = event {
                    self.configureView(event: event)
                }
            }).disposed(by: bag)
    }
    
    func configureView(event: Event) {
        titleEventLabel.text = event.title
        priceLabel.text = "\(event.price)"
    }
    
    @IBAction func checkIn(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "checkIn") as! ConfirmEventViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
