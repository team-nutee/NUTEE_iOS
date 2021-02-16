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
    
    // 모든 게시글 가져오기
    func getAllPosts(lastId: Int, limit: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.Post + "/all?lastId=" + "\(lastId)" + "&limit=" + "\(limit)"
        
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
    
    // 즐겨찾기한 카테고리 게시글 가져오기
    func getFavoritePosts(lastId: Int, limit: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.Post + "/favorite" + "?lastId=" + "\(lastId)" + "&limit=" + "\(limit)"
        
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
    
    // 전공 게시글 가져오기
    
    
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
        let URL = APIConstants.Post + "/" + String(postId)
        
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
    
    // 게시물 생성
    func createPost(title: String, content: String, category: String, images: [NSString], completion: @escaping (NetworkResult<Any>) -> Void) {
        
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
            "category" : category,
            "images" : images
        ]
        
        Alamofire.request(APIConstants.Post, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200, 201:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(PostContent.self, from: value)
                                completion(.success(result))
                            } catch {
                                completion(.pathErr)
                            }
                        case 400:
                            // 전공이나 카테고리를 선택하지 않았을 경우
                            print("실패 400")
                            completion(.requestErr(value))
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
    
    func uploadImage(images: [UIImage], completion: @escaping(NetworkResult<Any>)->Void) {

        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Accept": "application/hal+json",
            "Authorization": token
        ]

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for image in images {
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    multipartFormData.append(imageData, withName: "images", fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
        }, to: APIConstants.Image, method: .post, headers: headers) { (encodingResult) in

            switch encodingResult {

            case .success(let upload, _, _):
                upload.responseJSON { (response) in
                    
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200, 201:
                            do{
                                let result = try JSONDecoder().decode(UploadImage.self, from : response.data!)
                                
                                completion(.success(result.body))
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
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
        }
    }
    
    // 게시물 수정
    func editPost(postId: Int, title: String, content: String, images: [NSString], completion: @escaping (NetworkResult<Any>) -> Void) {
        
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
            "images" : images
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
                        completion(.success(status))
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
    
    // MARK: - Comments
    
    func createComment(_ postId: Int, comment: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId) + "/comment"
        
        var token = "Bearer "
        token += KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json;charset=UTF-8",
            "Accept": "application/hal+json",
            "Authorization": token
        ]
        
        let body : Parameters = [
            "content" : comment
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200, 201:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(Comment.self, from: value)
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
    
    func deleteComment(_ postId: Int, commentId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId) + "/comment/" + String(commentId)
        
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
                        completion(.success("comment 삭제 성공."))
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
    
    func editComment(_ postId: Int, _ commentId: Int, _ content: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Post + "/" + String(postId) + "/comment/" + String(commentId)
        
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
                                let result = try decoder.decode(Comment.self, from: value)
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
