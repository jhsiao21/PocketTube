import UIKit

enum TabBarPage {
    case home
    case hotNewRelease
    case favorite
    case profile

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .hotNewRelease
        case 2:
            self = .favorite
        case 3:
            self = .profile
        default:
            return nil
        }
    }

    var pageOrderNumber: Int {
        switch self {
        case .home:
            return 0
        case .hotNewRelease:
            return 1
        case .favorite:
            return 2
        case .profile:
            return 3
        }
    }

    var pageTitleValue: String {
        switch self {
        case .home:
            return "首頁"
        case .hotNewRelease:
            return "熱播新片"
        case .favorite:
            return "口袋名單"
        case .profile:
            return "個人頁面"
        }
    }

    var pageIconImage: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house") ?? UIImage()
        case .hotNewRelease:
            return UIImage(systemName: "play.rectangle.on.rectangle") ?? UIImage()
        case .favorite:
            return UIImage(systemName: "play.rectangle.on.rectangle") ?? UIImage()
        case .profile:
            return UIImage(systemName: "heart.circle") ?? UIImage()
        }
    }
}
