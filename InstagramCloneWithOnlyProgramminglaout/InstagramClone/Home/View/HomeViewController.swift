//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by OMNIADMIN on 17/08/22.
//

import UIKit

class HomeViewController: BaseClassViewController {

    private let tableView: UITableView = {
       
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        
        return tblView
    }()
    
    var viewModel: HomeViewModel
    var homeControllerQueue = DispatchQueue.global(qos: .userInitiated)
    var homeControllerSemaphore = DispatchSemaphore.init(value: 1)
    
    init(viewModel: HomeViewModel) {
        
        self.viewModel = viewModel
        viewModel.sections = [.stories, .userPostCells]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.setUpForTableView()
        self.setUpTabBar()
        self.addLayoutConstraints()
        /*
        homeControllerQueue.async {
            
            self.homeControllerSemaphore.wait()
            self.viewModel.getUserPostDataList { [weak self] (result) in
                
                self?.homeControllerSemaphore.signal()
                switch result {
                    
                    case .success(_):
         
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
         
                    case.failure(let error) :
                        self?.presentErrorPopUp(with: error)
                }
            }
        }*/
        
        homeControllerQueue.async(flags: .barrier) {
            
            self.viewModel.getUserPostDataList {  [weak self] (result) in
                
                switch result {
                    
                    case .success(_):
                    
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    
                    case.failure(let error) :
                        self?.presentErrorPopUp(with: error)
                }
            }
        }
        /*
        self.viewModel.getUserPostDataList { [weak self] (result) in
            
            switch result {
                
                case .success(_): self?.tableView.reloadData()
                case.failure(let error) : self?.presentErrorPopUp(with: error)
            }
        }*/
       
        /*viewModel.getHomeViewControllerRelatedData { [weak self] in
            
            self?.tableView.reloadData()
        }*/
    }
    
    
    func getHomeViewControllerData() async {
        
        await viewModel.getuserPostDataWithAsync { [weak self] (result)  in
            
            switch result {
                
                case .success(_):
                    self?.tableView.reloadData()
    
                case .failure(let error):
                    self?.presentErrorPopUp(with: error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpTabBar() {
        
        setTabBarImage(title: "Home", imageName: "house")
    }
}

//MARK: Layout constraints and styles

extension HomeViewController {
    
    func addLayoutConstraints() {
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: TableView delegates and datasources
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setUpForTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(StoriesTableViewCell.self,forCellReuseIdentifier: StoriesTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let currentSection = viewModel.sections[section]
        switch currentSection {
            
            case .stories: return 1
            case .userPostCells: return viewModel.userPostList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSection = viewModel.sections[indexPath.section]
        
        switch currentSection {
            
        case .stories:
            let cell = tableView.dequeueReusableCell(withIdentifier: StoriesTableViewCell.identifier, for: indexPath) as! StoriesTableViewCell
            
            cell.setUp(with: viewModel.userPostList)
            
            return cell
            
        case .userPostCells:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            
            let item = viewModel.userPostList[indexPath.row]
            cell.setUp(name: item.name,
                       imageName: item.imageName,
                       count: item.likesCount,
                       description: item.description)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let currentSection = viewModel.sections[indexPath.section]
        
        switch currentSection {
            
            case .stories: return 160
            case .userPostCells: return 600
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIViewController {
    
    func presentErrorPopUp(with error: BaseServiceError) {
        
        self.popUpAlert(title: "Error!", message: error.rawValue, actionTitle: "Ok")
    }
    
    func popUpAlert(title: String?, message: String?, actionTitle:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default)
        alert.addAction(action)
        
        DispatchQueue.main.async {
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
