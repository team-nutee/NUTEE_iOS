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
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/hal+json"
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
                                print("회원가입 성공")
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
    
    // MARK: - sign in
    
    func signIn(_ userId: String, _ password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.Login
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/hal+json"
        ]
        
        let body : Parameters = [
            "userId" : userId,
            "password" : password
        ]
        
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                // parameter 위치
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        
                        var result: SignIn?
                        do {
                            let decoder = JSONDecoder()
                            result = try decoder.decode(SignIn.self, from: value)
                        } catch {
                            completion(.pathErr)
                        }
                        
                        switch status {
                        case 200:
                            // 로그인 성공 시 토큰 저장
                            KeychainWrapper.standard.set(result!.body.accessToken, forKey: "token")
                            KeychainWrapper.standard.set(result!.body.memberId, forKey: "id")
                            completion(.success(result!))
                        case 401:
                            completion(.pathErr)
                        case 403:
                            // ex)비밀번호가 맞지 않는 경우
                            completion(.requestErr(result!))
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
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/hal+json"
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
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/hal+json"
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
    
    // MARK: - id 중복체크
    
    func checkID(_ userId: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.IDCheck
        let headers: HTTPHeaders = [
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/hal+json"
        ]
        
        let body : Parameters = [
            "userId" : userId
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                // parameter 위치
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        completion(.success("아이디 중복체크 성공"))
                    case 409:
                        completion(.requestErr(409))
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
    
    // MARK: - 닉네임 중복 체크
    
    func checkNick(_ nick: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.NickCheck
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/hal+json"
        ]
        
        let body : Parameters = [
            "nickname" : nick
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                // parameter 위치
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        completion(.success(200))
                    case 401:
                        completion(.requestErr("현재 로그인 중입니다."))
                    case 409:
                        completion(.requestErr("이미 사용 중인 닉네임입니다."))
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
    
    // MARK: - 아이디 찾기
    
    func findID(_ email : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.FindID
        let headers: HTTPHeaders = [
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/hal+json"
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
                        completion(.success("입력하신 이메일로 아이디가 발송되었습니다."))
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
    
    // MARK: - 비밀번호 찾기
    
    func findPW(_ userId : String, _ email : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.FindPW
        let headers: HTTPHeaders = [
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/hal+json"
        ]
        
        let body : Parameters = [
            "userId" : userId,
            "schoolEmail" : email
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseData{
            response in
            
            switch response.result {
            
            case .success:
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        completion(.success("입력하신 이메일로 새 비밀번호가 발송되었습니다."))
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
