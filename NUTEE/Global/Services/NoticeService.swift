//
//  NoticeService.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/12.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Alamofire

struct NoticeService {
    
    private init() {}
    
    static let shared = NoticeService()
    
    func getNoticeFromUrl(url: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = url
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData {
            response in
            
            switch response.result {
                
            case .success:
                // parameter 위치
                if let value = response.result.value {
                    //response의 respones안에 있는 statusCode를 추출
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(Notice.self, from: value)
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
                break
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
            }
        }
    }
    
}
