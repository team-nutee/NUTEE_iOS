//
//  UserService.swift
//  NUTEE
//
//  Created by eunwoo on 2020/12/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct UserService {
    
    private init() {}
    
    static let shared = UserService()
    
// MARK: - 회원가입
    
    func signUp(_ userId: String, _ nickname: String, _ email: String, _ password: String, _ otp: String, _ interests: [String], _ majors: [String], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.SignUp
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        
        let body : Parameters = [
            "userId" : userId,
            "nickname" : nickname,
            "schoolEmail" : email,
            "password" : password,
            "otp" : otp,
            "interests" : interests,
            "majors" : majors
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
                
            case .success:
                // parameter 위치
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(SignUp.self, from: value)
                                completion(.success(result))
                            } catch {
                                completion(.pathErr)
                            }
                        case 409:
                            completion(.pathErr)
                        case 500:
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
    
// MARK: - sendOTP
    
    func sendOTP(_ email : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.OTPSend
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let body : Parameters = [
            "schoolEmail" : email
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        completion(.success("해당 이메일로 OTP를 전송하였습니다."))
                    case 409:
                        completion(.requestErr("이미 등록 된 이메일입니다."))
                    case 500:
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
        
// MARK: - checkOTP
    
    func checkOTP(_ otpNumber : String, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.OTPCheck
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let body : Parameters = [
            "otpcheck" : otpNumber
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            switch response.result {
            case .success:
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        completion(.success(status))
                    case 401:
                        completion(.pathErr)
                    case 500:
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
}
