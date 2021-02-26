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
    
    let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let profileImagePicker = UIImagePickerController()
    
    let saveButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var userProfileImageSrc: String?
    
    var pickedIMG: [UIImage] = []
    
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
            $0.layer.cornerRadius = 0.5 * profileImageView.frame.size.width
            $0.setImageNutee(userProfileImageSrc)
            $0.clipsToBounds = true
        }
        _ = profileImagePicker.then {
            $0.delegate = self
        }
        
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
            
            $0.isEnabled = false
            
            $0.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
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
        showNuteeAlertSheet()
    }
    
    @objc func didTapSaveButton() {
        postImage(images: self.pickedIMG, completionHandler: {(returnedData)-> Void in
            self.changeProfileImageService(image: self.uploadedImages[0], completionHandler: {
                self.simpleNuteeAlertDialogue(title: "프로필 이미지 변경", message: "성공적으로 변경되었습니다")
                self.saveButton.isEnabled = false
            })
        })
    }
    
    func failToChangeProfile(_ title: String, _ message: String) {
        self.simpleNuteeAlertDialogue(title: title, message: message)
    }
}

// MARK: - NuteeAlert Action Definition

extension SettingProfileImageVC: NuteeAlertActionDelegate {
    
    func showNuteeAlertSheet() {
        let nuteeAlertSheet = NuteeAlertSheet()
        nuteeAlertSheet.nuteeAlertActionDelegate = self
        
        nuteeAlertSheet.optionList = [["앨범에서 프로필 사진 선택", UIColor.nuteeGreen]]
        
        if (UIImagePickerController .isSourceTypeAvailable(.camera)) {
            nuteeAlertSheet.optionList.append([["카메라로 프로필 사진 찍기", UIColor.nuteeGreen]])
        }
        
        nuteeAlertSheet.modalPresentationStyle = .custom
        present(nuteeAlertSheet, animated: true)
    }
    
    func nuteeAlertSheetAction(indexPath: Int) {
        switch indexPath {
        case 0:
            dismiss(animated: true)
            openLibrary()
        case 1:
            dismiss(animated: true)
            openCamera()
        default:
            break
        }
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
            self.pickedIMG = []
            self.pickedIMG.append(image)
            
            profileImageView.image = image
            profileImageView.contentMode = .scaleAspectFill
            
            self.saveButton.isEnabled = true
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
                
            case .requestErr(let message):
                self.failToChangeProfile("이미지 업로드 실패", "\(message)")

            case .pathErr:
                self.failToChangeProfile("이미지 업로드 실패", "서버 에러입니다")
                
            case .serverErr:
                self.failToChangeProfile("이미지 업로드 실패", "서버 에러입니다")

            case .networkFail:
                self.failToChangeProfile("이미지 업로드 실패", "네트워크 에러입니다")

            }
        }
        
    }
    
    func changeProfileImageService(image: NSString, completionHandler: @escaping () -> Void) {
        UserService.shared.changeProfileImage(image, completion: { (returnedData) -> Void in
       
            switch returnedData {
            case .success(_ ):
                completionHandler()

            case .requestErr(let message):
                self.failToChangeProfile("프로필 이미지 변경 실패", "\(message)")

            case .pathErr:
                self.failToChangeProfile("프로필 이미지 변경 실패", "서버 에러입니다")

            case .serverErr:
                self.failToChangeProfile("프로필 이미지 변경 실패", "서버 에러입니다")

            case .networkFail:
                self.failToChangeProfile("프로필 이미지 변경 실패", "네트워크 에러입니다")

            }
        })
    }
}
