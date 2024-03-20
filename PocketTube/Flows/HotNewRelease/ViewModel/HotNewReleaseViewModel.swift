import Foundation

protocol HotNewReleaseViewModelDelegate: AnyObject {
    func hotNewReleaseViewModel(didReceiveItem item: [HotNewReleaseViewModelItem])
    
    func hotNewReleaseViewModel(didReceiveError error: Error)
}

protocol HotNewReleaseViewModelDataProvider {
    func fetchMediaData(completion: @escaping (Result<[HotNewReleaseViewModelItem], Error>) -> Void)
}

protocol HotNewReleaseViewModelItem {
    var type: SectionType { get }
    var sectionTitle: String { get }
    var sectionImageName: String { get }
    var rowCount: Int { get }
}

final class HotNewReleaseViewModel {
    
    private let dataProvider: HotNewReleaseViewModelDataProvider
    weak var delegate: HotNewReleaseViewModelDelegate?
    var items: [HotNewReleaseViewModelItem] = []
        
    init(dataProvider: HotNewReleaseViewModelDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchData() {
        dataProvider.fetchMediaData { [weak self] result in
            switch result {
            case .success(let item):
                self?.delegate?.hotNewReleaseViewModel(didReceiveItem: item)
            case .failure(let error):
                self?.delegate?.hotNewReleaseViewModel(didReceiveError: error)
            }
        }
    }
}

struct HotNewReleaseViewModelPopularItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Popular
    }
    
    var sectionTitle: String {
        return "大家都在看"
    }
    
    var sectionImageName: String {
        return "fire"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

struct HotNewReleaseViewModelUpcomingItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Upcoming
    }
    
    var sectionTitle: String {
        return "即將上線"
    }
    
    var sectionImageName: String {
        return "popcorn"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

struct HotNewReleaseViewModelTop10MoviesItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Top10Movies
    }
    
    var sectionTitle: String {
        return "Top 10 電影"
    }
    
    var sectionImageName: String {
        return "Top10"
    }
    
    var rowCount: Int {
        return 10
    }

    var medias: [Media]

    init(medias: [Media]) {
        self.medias = medias
    }
}

struct HotNewReleaseViewModelTop10TVsItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Top10TVs
    }
    
    var sectionTitle: String {
        return "Top 10 節目"
    }
    
    var sectionImageName: String {
        return "Top10"
    }
    
    var rowCount: Int {
        return 10
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}
