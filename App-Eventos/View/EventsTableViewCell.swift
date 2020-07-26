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
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var event: Event? {
        didSet {
            guard let event = event else { return }
            titleEventLabel.text = event.title
            namePersonLabel.text = event.people.first?.name
            dateLabel.text = Double(event.date).dateFormat()
            discountLabel.text = "\(String(describing: event.cupons.first?.discount))"
            eventImage.setImage(with: URL(string: event.image))
        }
    }
    
}

extension Double {
    func dateFormat() -> String {
        let date = Date(timeIntervalSince1970: self/1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
}
