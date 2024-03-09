import Foundation
import UIKit

class AppInfoViewController: UIViewController {
    
    private let about: UILabel = {
        let label = UILabel()
        label.text = "About App"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let version: UILabel = {
        let label = UILabel()
//        label.text = "version v1.0.0"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let content: UILabel = {
        let label = UILabel()
        label.text = "This app is built upon TMDB (The Movie Database) as its foundation, offering users the ability to browse a variety of movie and TV show information. It utilizes Firebase for login authentication, allowing users to register or directly log in using their Facebook or Google accounts.\n\nThe backend database is powered by Firestore Database, enabling users to save and collect movies they are interested in.\nDue to copyright concerns, the app uses YouTube trailers for video content, while the text and image data of the movies are sourced from TMDB."
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(about)
        view.addSubview(version)
        view.addSubview(content)
        
        NSLayoutConstraint.activate([
            about.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 3),
            about.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            version.topAnchor.constraint(equalTo: about.bottomAnchor, constant: 30),
            version.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 5),
            
            content.topAnchor.constraint(equalTo: version.bottomAnchor, constant: 30),
            content.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 5),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: content.trailingAnchor, multiplier: 5),
        ])
    }
    
    private func getVersion() -> String {
        if let bundle = Bundle.main.infoDictionary, let version = bundle["CFBundleShortVersionString"] as? String, let build = bundle["CFBundleVersion"] as? String {
            return "v\(version) (\(build))"
        } else {
            return "unknown"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.version.text = getVersion()
    }
}
