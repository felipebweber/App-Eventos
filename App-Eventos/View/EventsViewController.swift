//
//  ViewController.swift
//  App-Eventos
//

import UIKit
import RxSwift
import RxCocoa

class EventsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let eventViewModel = EventViewModel()
    
    let disp = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        eventViewModel.fetchEvent()
        configureTableView()
        bind()
    }
    
    private func configureTableView() {
        tableView.rowHeight = 140
    }
    
    private func bind() {
        eventViewModel.events.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: EventsTableViewCell.Identifier, cellType: EventsTableViewCell.self)) { row, event, cell in
                cell.event = event
        }.disposed(by: disp)
    }
}

