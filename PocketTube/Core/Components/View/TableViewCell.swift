//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 21/11/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TableViewCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"
    
    weak var contentActionButtonDelegate: ContentActionButtonDelegate?
    
    private var medias: [Media] = [Media]()    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.layer.borderWidth = 0.0
//        collectionView.layer.borderColor = UIColor.systemBackground.cgColor
//        collectionView.layer.masksToBounds = true
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //因為tableViewCell內只有collectionView
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with medias: [Media]) {
        self.medias = medias
        
        //medias array改變就更新collectionView
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }    
    
    private func favoriteMediaAt(indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid,
              let mediaTitle = medias[indexPath.row].original_title ?? medias[indexPath.row].original_name,
              let imageUrl = medias[indexPath.row].poster_path,
              let overview = medias[indexPath.row].overview else {
            return
        }
        
        let media = FMedia(ownerUid: uid, caption: mediaTitle, timestamp: Timestamp(), imageUrl: imageUrl, overview: overview, mId: NSUUID().uuidString)
        contentActionButtonDelegate?.didTappedWatchListBtn(uid: uid, media: media)
    }
}


//MARK: - UICollectionView delegate
extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        guard let model = medias[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(imageUrl: model)
//        cell.backgroundColor = .systemPink
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let media = medias[indexPath.row]
        guard let mediaTitle = media.original_title ?? media.original_name else {
            return
        }
        
        contentActionButtonDelegate?.didTappedPlayBtn(mediaName: "\(mediaTitle)", mediaOverview: media.overview)
    }
    
    // 長按觸發
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "加入口袋名單", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.favoriteMediaAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
}
