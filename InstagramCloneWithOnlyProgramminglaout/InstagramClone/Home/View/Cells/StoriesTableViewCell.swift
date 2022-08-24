//
//  StoreiesTableViewCell.swift
//  InstagramClone
//
//  Created by OMNIADMIN on 22/08/22.
//

import UIKit

class StoriesTableViewCell: UITableViewCell {
    
    static let identifier = "StoriesTableViewCell"
    
    private let collectionView: UICollectionView = {
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        
        let clnView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        clnView.contentMode = .top
        clnView.showsHorizontalScrollIndicator = false
        clnView.translatesAutoresizingMaskIntoConstraints = false
        clnView.backgroundColor = .clear
        
        return clnView
    }()
    
    private var storiesList: [UserPost] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpForCollectionView()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        addLayoutConstraints()
    }
    
    func setUp(with list: [UserPost]) {
        
        storiesList = list
        self.collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: layout and styles

extension StoriesTableViewCell {

    func addLayoutConstraints() {
        
        contentView.addSubview(collectionView)
    
        NSLayoutConstraint.activate([
        
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: CollectionView delegates and datasources

extension StoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setUpForCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CircleCollectionViewCell.self, forCellWithReuseIdentifier: CircleCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCollectionViewCell.identifier, for: indexPath) as! CircleCollectionViewCell
        
        cell.setUp(name: storiesList[indexPath.row].name,
                   imageName: storiesList[indexPath.row].imageName)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return storiesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
}

