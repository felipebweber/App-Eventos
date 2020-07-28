//
//  ViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift
import RxCocoa

final class EventsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let eventsViewModel = EventViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsViewModel.fetchEvents()
        configureTableView()
        bindFetchError()
    }
    
    private func configureTableView() {
        tableView.rowHeight = 104
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func bindFetchError() {
        eventsViewModel.fetchError.asObservable()
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
        eventsViewModel.events.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: EventsTableViewCell.Identifier, cellType: EventsTableViewCell.self)) { row, event, cell in
                cell.event = event
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                if let event = self?.eventsViewModel.events.value[indexPath.row] {
                    let controller = self?.storyboard?.instantiateViewController(identifier: "description") as! DescriptionViewController
                    let descriptionViewModel = DescriptionViewModel(eventId: event.id)
                    controller.descriptionViewModel = descriptionViewModel
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }).disposed(by: disposeBag)
    }

    fileprivate func showError(_ fetchError: FetchError) {
        var title = String()
        var message = String()
        switch fetchError {
        case .none:
            break
        case .failNetworking:
            title = "Erro de rede"
            message = "Verifirique a conexão de rede"
        case .itemNotFound:
            break
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
