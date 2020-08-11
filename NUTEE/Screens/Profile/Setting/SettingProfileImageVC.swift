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
            $0.image = #imageLiteral(resourceName: "nutee_zigi_green")
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
        let profileImageAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        profileImageAlert.view.tintColor = .nuteeGreen
        
        let albumAction = UIAlertAction(title: "앨범에서 프로필 사진 선택", style: .default) { action in
            self.openLibrary()
        }
        let cameraAction = UIAlertAction(title: "카메라로 프로필 사진 찍기", style: .default) { action in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        profileImageAlert.addAction(albumAction)
        profileImageAlert.addAction(cancel)
        
        if (UIImagePickerController .isSourceTypeAvailable(.camera)) {
            profileImageAlert.addAction(cameraAction)
        }
        
        present(profileImageAlert, animated: true)
    }
}

// MARK: - 프로필 이미지 선택 창 전환 기능 구현

extension SettingProfileImageVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openLibrary(){
        profileImagePicker.sourceType = .photoLibrary
        
        present(profileImagePicker, animated: true, completion: nil)
    }
    func openCamera(){
        profileImagePicker.sourceType = .camera
        
        present(profileImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            profileImageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
    
}
