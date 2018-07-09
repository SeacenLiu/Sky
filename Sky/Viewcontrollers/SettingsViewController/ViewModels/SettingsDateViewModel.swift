
import UIKit

struct SettingsDateViewModel {
    let dateMode: DateMode
    
    private let dateFormatter = DateFormatter()
    
    var labelText: String {
        let now = Date()
        dateFormatter.dateFormat = dateMode.format
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

