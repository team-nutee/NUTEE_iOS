//
//  SettingProfileImageVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingProfileImageVC : UIViewController {
    
    // MARK: - UI components
    
    let profileImageView = UIImageView()
    let profileImagePicker = UIImagePickerController()
    
    let saveButton = UIButton()
    
    // MARK: - Variables and Properties
    
    var userProfileImageSrc: String?
    
    var uploadedImages: [NSString] = []

    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
        view.backgroundColor = .white
        
        initView()
        addSubView()
        
        setProfileImageClickActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initViewAfterLoadLayout()
    }
    // MARK: - Helper
    
    func initView() {
        _ = profileImageView.then {
            $0.setImageNutee(userProfileImageSrc, profileImageView)
            $0.contentMode = .scaleAspectFit
        }
        _ = profileImagePicker.then {
            $0.delegate = self
        }
        
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func initViewAfterLoadLayout() {
        _ = profileImageView.then {
            $0.layer.cornerRadius = 0.5 * $0.frame.size.width
            $0.layer.masksToBounds = true
        }
    }
    
    func addSubView() {
        
        view.addSubview(profileImageView)
        view.addSubview(saveButton)
        
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(profileImageView.snp.width)
            
            $0.top.equalTo(view.snp.top).offset(45)
            $0.centerX.equalTo(view)
        }
        saveButton.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.centerX.equalTo(profileImageView)
        }
        
    }
    
    func setProfileImageClickActions() {
        profileImageView.tag = 1
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer1.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer1)
    }
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imgView = tapGestureRecognizer.view as! UIImageView
        //Give your image View tag
        if (imgView.tag == 1) {
            didTapProfileImageView()
        }
    }
    
    @objc func didTapProfileImageView() {
        let nuteeAlertSheet = NuteeAlertSheet()
        nuteeAlertSheet.titleHeight = 0
        
        nuteeAlertSheet.optionList = [["앨범에서 프로필 사진 선택", UIColor.nuteeGreen, "openLibrary"]]
        
        if (UIImagePickerController .isSourceTypeAvailable(.camera)) {
            nuteeAlertSheet.optionList.append([["카메라로 프로필 사진 찍기", UIColor.nuteeGreen, "openCamera"]])
        }
        
        nuteeAlertSheet.settingProfileImageVCDelegate = self
        
        nuteeAlertSheet.modalPresentationStyle = .custom
        
        present(nuteeAlertSheet, animated: true)
    }
}

extension SettingProfileImageVC : SettingProfileImageVCDelegate {
    func openSettingProfileImageVCLibrary() {
        dismiss(animated: true)
        openLibrary()
    }
    
    func openSettingProfileImageVCCamera() {
        dismiss(animated: true)
        openCamera()
    }
}

// MARK: - 프로필 이미지 선택 창 전환 기능 구현

extension SettingProfileImageVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openLibrary(){
        profileImagePicker.sourceType = .photoLibrary
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        
        profileImagePicker.modalPresentationStyle = .overFullScreen
        
        present(profileImagePicker, animated: true, completion: nil)
    }
    func openCamera(){
        profileImagePicker.sourceType = .camera
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        
        profileImagePicker.modalPresentationStyle = .overFullScreen
        
        present(profileImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            profileImageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Server connect

extension SettingProfileImageVC {
    func postImage(images: [UIImage],
                   completionHandler: @escaping (_ returnedData: [NSString]) -> Void ) {
        dump(images[0])
        
        ContentService.shared.uploadImage(images: images){
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.uploadedImages = res as! [NSString]
                completionHandler(self.uploadedImages)
            case .requestErr:
                self.simpleAlert(title: "실패", message: "")
                
            case .pathErr:
                print(".pathErr")
                
            case .serverErr:
                print(".serverErr")
                
            case .networkFail:
                print(".networkFail")
                
            }
        }
        
    }
    
    func changeUserProfileImageService(image: NSString){
        UserService.shared.changeUserProfileImage(userProfileImage: image){
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(_ ):
                self.dismiss(animated: true, completion: nil)
                
            case .requestErr:
                print("requestErr")
                
            case .pathErr:
                print(".pathErr")
                
            case .serverErr:
                print(".serverErr")
                
            case .networkFail:
                print(".networkFail")
                
                
            }
        }
        
    }
}
