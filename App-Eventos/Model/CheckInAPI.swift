//
//  CheckInAPI.swift
//  App-Eventos
//

import Foundation
import Alamofire

class CheckInAPI {
    
    private let checkInURL = "https://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"
    
    func checkIn(eventId: String, name: String, email: String, completion: @escaping(CheckInStatus) -> Void) {
        let data: [String: Any] = ["eventId": eventId, "name": name, "email": email]
        AF.request(checkInURL, method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON{ response in
            switch response.result {
            case .success(_):
                completion(CheckInStatus.success)
            case .failure(_):
                completion(CheckInStatus.fail)
            }
        }
    }
}
