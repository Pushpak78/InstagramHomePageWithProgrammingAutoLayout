//
//  HomeViewModel.swift
//  InstagramClone
//
//  Created by OMNIADMIN on 19/08/22.
//

import UIKit

class HomeViewModel {
    
    var homeService: HomeService? = nil
    var userData = ""
    var userId = ""
    var userPostList : [UserPost] = []
    var sections: [HomeSections] = []
    
    func getUserPostDataList (completion: @escaping (Result<Bool,BaseServiceError>) -> Void) {
        
        if homeService == nil {
            
            homeService = HomeService(session: URLSession(configuration: .default))
        }
        userId = "1234"
        homeService!.getUserPostData(userId: userId){ [weak self] ( result, error) in
            
            if error == nil {
                
                if let postList = result as? [UserPost] {
                    
                    self?.userPostList = postList
                    completion(.success(true))
                }
            } else {
                
                completion(.failure(error!))
            }
        }
    }
    
    func getuserPostDataWithAsync(completion: (Result<Bool,BaseServiceError>) -> Void) async {
        // Not using
        await homeService!.getUserPostDataWithAsync(userId: "1234") { [weak self] (result) in
            
            switch result {
                
                case .success(let postList):
                    self?.userPostList = postList
                    completion(.success(true))
                
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func postUserData(completion: @escaping () -> Void) {
        
        completion()
    }
    
    func getHomeViewControllerRelatedData(completion: @escaping () -> Void) {
        
        let group = DispatchGroup()
        
        group.enter()
        
        getUserPostDataList {_ in
            group.leave()
        }
        
        group.enter()
        
        postUserData {
            group.leave()
        }
        
        group.notify(queue: .main) {
            
            completion()
        }
    }
}

