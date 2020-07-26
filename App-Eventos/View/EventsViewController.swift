//
//  ViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift
import RxCocoa

final class EventsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let eventsViewModel = EventViewModel()
    
    private let disp = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsViewModel.fetchEvents()
        configureTableView()
        bind()
    }
    
    private func configureTableView() {
        tableView.rowHeight = 140
    }
    
    private func bind() {
        eventsViewModel.events.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: EventsTableViewCell.Identifier, cellType: EventsTableViewCell.self)) { row, event, cell in
                cell.event = event
        }.disposed(by: disp)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                print("tapped \(indexPath.row)")
                self?.tableView.deselectRow(at: indexPath, animated: true)
                if let event = self?.eventsViewModel.events.value[indexPath.row] {
                    let controller = self?.storyboard?.instantiateViewController(identifier: "description") as! DescriptionViewController
                    let descriptionViewModel = DescriptionViewModel(eventId: event.id)
                    controller.descriptionViewModel = descriptionViewModel
                    
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }).disposed(by: disp)
    }
}
