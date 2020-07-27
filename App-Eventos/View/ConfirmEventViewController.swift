//
//  ConfirmEventViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift

final class ConfirmEventViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var finishCheckIn: UIButton!
    
    var checkInViewModel: CheckInViewModel?
    
    private let disposeBag = DisposeBag()
    
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
            .subscribe(onNext: { [weak self] _ in
                self?.hideKeyboard()
            })
            .disposed(by: disposeBag)
        
        checkInViewModel?.check.asObservable()
            .subscribe(onNext: { [weak self] checkInStatus in
                switch checkInStatus {
                case .none:
                    break
                case .success:
                    self?.showError(true)
                case .fail:
                    self?.showError(false)
                }
            })
            .disposed(by: disposeBag)
        
        checkInViewModel?.credentialsValid?
            .drive(onNext: { [weak self] valid in
                self?.finishCheckIn.isEnabled = valid
            })
            .disposed(by: disposeBag)
        
        finishCheckIn.rx.tap
            .withLatestFrom(checkInViewModel!.credentialsValid!)
            .filter { $0 }
            .bind { _ in
                self.checkInViewModel?.checkIn(name: self.nameTextField.text!, email: self.emailTextField.text!)
        }
        .disposed(by: disposeBag)
    }
    
    fileprivate func showError(_ success: Bool) {
        let title: String
        let message: String
        if success {
            title = "Atenção"
            message = "Check-in realizado com sucesso"
        } else {
            title = "Atenção"
            message = "Não foi possível realizar o check-in"
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
