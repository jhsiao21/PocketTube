import UIKit

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "ProfileTableViewCell"
    
    enum ProfileCellType {
        case plain, selectable, signOut, delete
    }
    
    var type: ProfileCellType = .plain {
        didSet {
            switch type {
            case .plain:
                textLabel?.textColor = .white
                textLabel?.textAlignment = .left
                selectionStyle = .none //set to untappable
                accessoryType = .none
            case .selectable:
                textLabel?.textColor = .white
                textLabel?.textAlignment = .left
                accessoryType = .disclosureIndicator
            case .signOut:
                textLabel?.textColor = .link
                textLabel?.textAlignment = .center
                accessoryType = .none
            case .delete:
                textLabel?.textColor = .red
                textLabel?.textAlignment = .center
                accessoryType = .none
            }
            imageView?.tintColor = .link
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        backgroundColor = .systemBackground
        self.type = .plain
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
