
import UIKit

struct SettingsDateViewModel {
    let dateMode: DateMode
    
    private let dateFormatter = DateFormatter()
    
    var labelText: String {
        let now = Date()
        switch dateMode {
        case .text:
            dateFormatter.dateFormat = "E, dd MMMM"
        case .digit:
            dateFormatter.dateFormat = "EEEEE, MM/dd"
        }
        return dateFormatter.string(from: now)
    }
    
    var accessory: UITableViewCellAccessoryType {
        if UserDefaults.dateMode() == dateMode {
            return .checkmark
        }
        else {
            return .none
        }
    }
}

extension SettingsDateViewModel: SettingsRepresentable {}

