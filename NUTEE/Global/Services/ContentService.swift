//
//  ContentService.swift
//  NUTEE
//
//  Created by eunwoo on 2020/12/26.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct ContentService {
    private init() {}
    
    static let shared = ContentService()
    
    //MARK: - 게시글(Post) 받아오기
    
    // 카테고리에 있는 게시글들(posts) 가져오기
    func getCategoryPosts(category: String, lastId: Int, limit: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.Posts + category + "?lastId=" + "\(lastId)" + "&limit=" + "\(limit)"
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization:": "Bearer " + KeychainWrapper.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseData{ response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode{
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(Posts.self, from: value)
                                completion(.success(result))
                                print(KeychainWrapper.standard.string(forKey: "token")!)
                                print(URL)
                            } catch {
                                completion(.pathErr)
                            }
                        case 409:
                            print("실패 409")
                            completion(.pathErr)
                        case 500:
                            print("실패 500")
                            completion(.serverErr)
                        default:
                            break
                        }
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                
            }
            
        }
        
    }
}
