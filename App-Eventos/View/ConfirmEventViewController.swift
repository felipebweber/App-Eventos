//
//  ConfirmEventViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift

final class ConfirmEventViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var finishCheckIn: UIButton!
    
    var checkInViewModel: CheckInViewModel?
    
    private let dis = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        bind()
    }
    
    private func bind() {
        checkInViewModel?.name = nameTextField.rx.text.orEmpty.asDriver()
        checkInViewModel?.email = emailTextField.rx.text.orEmpty.asDriver()
        
        checkInViewModel?.validate()
        
        let gr = UITapGestureRecognizer()
        gr.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gr)
        gr.rx.event.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.hideKeyboard()
            })
            .disposed(by: dis)
        
        checkInViewModel?.check.asObservable()
            .subscribe(onNext: { [unowned self] checkInStatus in
                switch checkInStatus {
                case .none:
                    break
                case .success:
                    self.showError(true)
                case .fail:
                    self.showError(false)
                }
            })
            .disposed(by: dis)
        
        finishCheckIn.rx.tap
            .withLatestFrom(checkInViewModel!.credentialsValid!)
            .filter { $0 }
            .bind { _ in
                self.checkInViewModel?.checkIn(name: self.nameTextField.text!, email: self.emailTextField.text!)
        }
        .disposed(by: dis)
    }
    
    fileprivate func showError(_ success: Bool) {
        let title: String
        let message: String
        if success {
            title = "Success"
            message = "Check in successfully"
        } else {
            title = "Fail"
            message = "Check in cannot be done"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func hideKeyboard() {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
    }
    
}

extension ConfirmEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameTextField {
            emailTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
}
