//
//  EventsTableViewCell.swift
//  App-Eventos
//

import UIKit

final class EventsTableViewCell: UITableViewCell {
    
    static var Identifier = "EventsTableViewCell"
    
    @IBOutlet private weak var titleEventLabel: UILabel!
    @IBOutlet private weak var namePersonLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var eventImage: UIImageView!
    
    var event: Event? {
        didSet {
            guard let event = event else { return }
            titleEventLabel.text = event.title
            namePersonLabel.text = "Responsável: \(event.people.first?.name ?? "Não informado")"
            dateLabel.text = Double(event.date).dateFormat()
            eventImage.setImage(with: URL(string: event.image))
        }
    }
    
}
