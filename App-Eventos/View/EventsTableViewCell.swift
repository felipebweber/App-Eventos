//
//  EventsTableViewCell.swift
//  App-Eventos
//

import UIKit

final class EventsTableViewCell: UITableViewCell {
    
    static var Identifier = "EventsTableViewCell"
    
    @IBOutlet weak var titleEventLabel: UILabel!
    @IBOutlet weak var namePersonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
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
