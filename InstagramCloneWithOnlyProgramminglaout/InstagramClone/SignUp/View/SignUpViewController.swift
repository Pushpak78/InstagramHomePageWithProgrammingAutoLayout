//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by OMNIADMIN on 23/08/22.
//

import UIKit

class SignUpViewController : UIViewController {
    
    private let searchBar: UISearchBar = {
        
        let searchbar = UISearchBar()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchbar
    }()
    
    private let collectionView: UICollectionView = {
        
       // let clnView = UICollectionView(frame: .zero, collectionViewLayout: SignUpViewController.getCustomCompostionalLayout())
        let clnView = UICollectionView()
        clnView.translatesAutoresizingMaskIntoConstraints = false
    
        return clnView
    }()
    
    var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        
        self.viewModel = viewModel
        //viewModel.sections = [.stories, .userPostCells]
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addLayoutConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
}


extension SignUpViewController {
    
    func addLayoutConstraints() {
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
        
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SignUpViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    
}



