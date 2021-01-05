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
        let URL = APIConstants.Post + "/category/" + category + "?lastId=" + "\(lastId)" + "&limit=" + "\(limit)"
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
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
                                let result = try decoder.decode(Post.self, from: value)
                                completion(.success(result))
                                
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
                            print(status)
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
    
    // 게시글(post) 하나 가져오기
    func getPost(_ postId: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.BackURL + "/" + String(postId)
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
        ]
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseData{ response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode{
                        print("response 코드", status)
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(PostContent.self, from: value)
                                completion(.success(result))
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
    
    // 게시글 생성
    
    // 게시물 수정
    func editPost(_ postId: Int, _ title: String, _ content: String, _ images: [String], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId)
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
        ]
        
        let body : Parameters = [
            "title" : title,
            "content" : content,
            "image" : images
        ]
        
        
        Alamofire.request(URL, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(PostContent.self, from: value)
                                completion(.success(result))
                            } catch {
                                completion(.pathErr)
                            }
                        case 401:
                            print("실패 401")
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
    
    // 포스트 삭제
    func deletePost(_ postId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId)
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
        ]
        
        Alamofire.request(URL, method: .delete, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        completion(.success("post 삭제 성공."))
                    case 401:
                        print("실패 401")
                        completion(.pathErr)
                    case 500:
                        print("실패 500")
                        completion(.serverErr)
                    default:
                        break
                    }
                }
                
                break
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
            }
        }
    }
    
    // 게시물 신고하기
    func reportPost(_ postId: Int, _ content: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId) + "/report"
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
        ]
        
        let body : Parameters = [
            "content" : content
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(PostContent.self, from: value)
                                completion(.success(result))
                            } catch {
                                completion(.pathErr)
                            }
                        case 401:
                            print("실패 401")
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
    
    // 좋아요
    func postLike(_ postId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId) + "/like"
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
        ]
        
        Alamofire.request(URL, method: .post, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(PostContent.self, from: value)
                                completion(.success(result))
                            } catch {
                                completion(.pathErr)
                            }
                        case 401:
                            print("실패 401")
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
    
    // 좋아요 취소
    func deleteLike(_ postId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId) + "/like"
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
        ]
        
        Alamofire.request(URL, method: .delete, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(PostContent.self, from: value)
                                completion(.success(result))
                            } catch {
                                completion(.pathErr)
                            }
                        case 401:
                            print("실패 401")
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
