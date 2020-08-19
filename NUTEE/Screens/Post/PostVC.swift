//
//  PostVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit
import Photos

import YPImagePicker
import FirebaseAnalytics

class PostVC: UIViewController {
    
    // MARK: - UI components
    
    let scrollView = UIScrollView()
    
    let containerView = UIView()
    
    let postContentTextView = UITextView()
    let placeholderLabel = UILabel()
    
    let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let imagePickerView = UIView()
    let imagePickerButton = UIButton()
    
    // MARK: - Variables and Properties

    var pickedIMG : [UIImage] = []
    
    var selectedItems = [YPMediaItem]()
    
    var uploadedImages: [NSString] = []
    
//    var editNewsPost: NewsPostsContentElement?
    var isEditMode = false
    var editPostImg: [Image] = []
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setNavigationBarItem()
        initPostingView()
        addSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        Analytics.logEvent("postview", parameters: [
            "name": "포스팅 뷰 선택" as NSObject,
            "full_text": "포스팅 뷰 선택" as NSObject
        ])
        
        addKeyboardNotification()
        self.postContentTextView.becomeFirstResponder()
    }
    
    // MARK: - Helper
    
    func setNavigationBarItem() {
        let barItemFont = UIFont.boldSystemFont(ofSize: 20)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(didTapClosePosting))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: barItemFont, NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(didTapClosePosting))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: barItemFont, NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
    }
    
    func initPostingView() {
        _ = scrollView.then {
            $0.verticalScrollIndicatorInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        }
        
        _ = postContentTextView.then {
            $0.delegate = self
            
            $0.font = .systemFont(ofSize: 15)
            
            $0.tintColor = .nuteeGreen
            $0.isScrollEnabled = false
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        }
        
        _ = placeholderLabel.then {
            $0.text = "내용을 입력해주세요"
            $0.sizeToFit()
            $0.font = .systemFont(ofSize: 15)
            $0.textColor = .gray
        }
        
        _ = imageCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            
            $0.collectionViewLayout = layout
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(PostImageCVCell.self, forCellWithReuseIdentifier: "PostImageCVCell")
            
            $0.backgroundColor = .white
            $0.showsHorizontalScrollIndicator = false
        }
        
        _ = imagePickerView.then {
            $0.addBorder(.top, color: .nuteeGreen, thickness: 1)
            $0.alpha = 0.6
        }
        
        _ = imagePickerButton.then {
            $0.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
            $0.tintColor  = .nuteeGreen
            $0.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        }
    }
    
    func addSubView() {
        
        // Add SubViews
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(postContentTextView)
        postContentTextView.addSubview(placeholderLabel)

        containerView.addSubview(imageCollectionView)
        
        view.addSubview(imagePickerView)
        imagePickerView.addSubview(imagePickerButton)
        
        // Make Constraints
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(20)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }
        
        let leftAndRightSpace = 15
        containerView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.greaterThanOrEqualTo(scrollView.snp.height)
            
            $0.top.equalTo(scrollView.snp.top)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        
        postContentTextView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.left.equalTo(containerView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(containerView.snp.right).inset(leftAndRightSpace)
        }
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(postContentTextView.snp.top)
            $0.left.equalTo(postContentTextView.snp.left)
            $0.right.equalTo(postContentTextView.snp.right)
        }

        imageCollectionView.snp.makeConstraints {
            $0.height.equalTo(60)
            
            $0.top.equalTo(postContentTextView.snp.bottom).offset(10)
            $0.left.equalTo(containerView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(containerView.snp.right).inset(leftAndRightSpace)
            $0.bottom.equalTo(containerView.snp.bottom).inset(10)
        }
        
        imagePickerView.snp.makeConstraints {
            $0.height.equalTo(50)
            
            $0.top.equalTo(scrollView.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        imagePickerButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(imagePickerButton.snp.width)
            
            $0.centerY.equalTo(imagePickerView)
            $0.left.equalTo(imagePickerView.snp.left).offset(15)
        }
    }
 
//    func setEditMode() {
//        isEditMode = true
//        postContentTextView.text = editNewsPost?.content
//        editPostImg = editNewsPost?.images ?? []
//        self.navigationItem.leftBarButtonItem?.title = "취소"
//        self.navigationItem.rightBarButtonItem?.title = "수정"
//    }
    
    @objc func didTapClosePosting() {
        // 입력된 빈칸과 줄바꿈 개수 구하기
        var str = postContentTextView.text.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        
        // 빈칸이나 줄바꿈으로만 입력된 경우 포스팅 창 바로 나가기
        if pickedIMG.count != 0 || editPostImg.count > 1 || str.count != 0 {
            var content = ""
            if isEditMode == true {
                content = "수정을 취소하시겠습니까?"
            } else {
                content = "작성을 취소하시겠습니까?"
            }
            let nuteeAlertDialogue = NuteeAlertDialogue()
            nuteeAlertDialogue.dialogueData = ["나가기", content]
            nuteeAlertDialogue.okButtonData = ["예", UIColor.red, UIColor.white]
            nuteeAlertDialogue.cancelButtonData[0] = "아니오"
            
            nuteeAlertDialogue.addCancelPostAction()

            nuteeAlertDialogue.modalPresentationStyle = .overCurrentContext
            nuteeAlertDialogue.modalTransitionStyle = .crossDissolve
            
            present(nuteeAlertDialogue, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
//    @objc func didTapPosting(){
//
//        LoadingHUD.show()
//        if isEditMode == false {
//            // 사진이 있을때는 사진 올리고 게시물 업로드를 위한 분기처리
//            if pickedIMG != [] {
//                postImage(images: pickedIMG, completionHandler: {(returnedData)-> Void in
//                    self.postContent(images: self.uploadedImages,
//                                     postContent: self.postContentTextView.text)
//                })
//            } else {
//                postContent(images: [], postContent: postContentTextView.text)
//            }
//        } else {
//            // 사진이 있을때는 사진 올리고 게시물 업로드를 위한 분기처리
//            var images: [String] = []
//            for img in self.editPostImg {
//                images.append(img.src ?? "")
//            }
//            if pickedIMG != [] {
//                postImage(images: pickedIMG, completionHandler: {(returnedData)-> Void in
//                    for uploadimg in self.uploadedImages {
//                        images.append(uploadimg as String)
//                    }
//                    self.editPostContent(postId: self.editNewsPost?.id ?? 0,
//                                         postContent: self.postContentTextView.text, postImages: images)
//                })
//            } else {
//                editPostContent(postId: editNewsPost?.id ?? 0,
//                                postContent: postContentTextView.text,
//                                postImages: images)
//            }
//        }
//
//
//    }
//
//    @objc func activeself.navigationItem.rightBarButtonItem?() {
//        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification,
//                                               object: postContentTextView ,
//                                               queue: OperationQueue.main) { (notification) in
//            if self.postContentTextView.text != "" || self.pickedIMG != []{
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
//            } else {
//                self.navigationItem.rightBarButtonItem?.isEnabled = false
//            }
//        }
//    }

}

// MARK: - imageCollectionView Delegate

extension PostVC : UICollectionViewDelegate { }
extension PostVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
}
extension PostVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEditMode == false {
            return pickedIMG.count
        } else {
            return (editPostImg.count ) + pickedIMG.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCVCell", for: indexPath) as! PostImageCVCell
        
        if isEditMode == false {
            cell.postImageImageView.image = pickedIMG[indexPath.row]
            if ( pickedIMG.count != 0 || editPostImg.count != 0) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            if editPostImg.count >= 1 && indexPath.row < editPostImg.count {
//                cell.postImageImageView.setImageNutee(editNewsPost?.images[indexPath.row].src ?? "")
            } else {
                let fixIndex = Int(indexPath.row) - (editPostImg.count)
                cell.postImageImageView.image = pickedIMG[fixIndex]
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 입력된 빈칸과 줄바꿈 개수 구하기
        var str = postContentTextView.text.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        
        if isEditMode == false {
            pickedIMG.remove(at: indexPath.row)
            if (pickedIMG.count != 0 || editPostImg.count > 1 || str.count != 0){
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            print(false)
            if editPostImg.count > 0 && indexPath.row < editPostImg.count {
                editPostImg.remove(at: indexPath.row)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                let fixIndex = Int(indexPath.row) - (editPostImg.count)
                pickedIMG.remove(at: fixIndex)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
            if (pickedIMG.count != 0 || editPostImg.count != 0 || str.count != 0){
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
            
        }
        
        self.imageCollectionView.reloadData()
    }
    
}

// MARK: - UITextView Delegate

extension PostVC: UITextViewDelegate {
    
    // TextView의 동적인 크기 변화를 위한 function
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        // 입력된 빈칸과 줄바꿈 개수 구하기
        var str = postContentTextView.text.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        
        if str != "" {
            self.placeholderLabel.isHidden = true
        } else {
            self.placeholderLabel.isHidden = false
        }
        
        // 빈칸이나 줄바꿈으로만 입력된 경우 버튼 비활성화
        if pickedIMG.count != 0 || editPostImg.count > 1 || str.count != 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

// MARK: - KeyBoard

extension PostVC {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification)  {
        if let info = notification.userInfo {
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = keyboardFrame.height
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            let bottomPadding = keyWindow?.safeAreaInsets.bottom ?? 0
            
            imagePickerView.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardHeight - bottomPadding)
            }
            
            self.view.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let info = notification.userInfo {
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            
            imagePickerView.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            scrollView.contentInset = .zero
            self.view.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

// MARK: - YPImagePicker

extension PostVC {
    
    @objc func showPicker() {
        var config = YPImagePickerConfiguration()
        
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = true
        config.startOnScreen = .library
        config.wordings.libraryTitle = "갤러리"
        config.maxCameraZoomFactor = 2.0
        config.library.maxNumberOfItems = 10
        config.gallery.hidesRemoveButton = false
        config.hidesBottomBar = false
        config.hidesStatusBar = false
        config.library.preselectedItems = selectedItems
        config.colors.tintColor = .nuteeGreen
        config.overlayView = UIView()
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            self.pickedIMG = []
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            for item in items {
                switch item {
                case .photo(let p):
                    self.pickedIMG.append(p.image)
                    
                default:
                    print("")
                    
                }
            }
            picker.dismiss(animated: true) {
                self.imageCollectionView.reloadData()
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
}

// MARK: - PostVC 서버 연결

//extension PostVC {
//    func postContent(images: [NSString], postContent: String){
//        ContentService.shared.uploadPost(pictures: images, postContent: postContent){
//            [weak self]
//            data in
//
//            guard let `self` = self else { return }
//
//            switch data {
//            case .success(_ ):
//
//                LoadingHUD.hide()
//                self.dismiss(animated: true, completion: nil)
//            case .requestErr:
//                LoadingHUD.hide()
//                print("requestErr")
//            case .pathErr:
//                print(".pathErr")
//
//            case .serverErr:
//                print(".serverErr")
//
//            case .networkFail:
//                print(".networkFail")
//
//
//            }
//        }
//
//    }
//
//    func postImage(images: [UIImage],
//                   completionHandler: @escaping (_ returnedData: [NSString]) -> Void ) {
//        dump(images[0])
//
//        ContentService.shared.uploadImage(pictures: images){
//            [weak self]
//            data in
//
//            guard let `self` = self else { return }
//
//            switch data {
//            case .success(let res):
//                self.uploadedImages = res as! [NSString]
//                print(".successful uploadImage")
//                completionHandler(self.uploadedImages)
//            case .requestErr:
//                self.simpleAlert(title: "실패", message: "")
//
//            case .pathErr:
//                print(".pathErr")
//
//            case .serverErr:
//                print(".serverErr")
//
//            case .networkFail:
//                print(".networkFail")
//
//            }
//        }
//
//    }
//
//    func editPostContent(postId: Int, postContent: String, postImages: [String]){
//        ContentService.shared.editPost(postId, postContent, postImages){
//            [weak self]
//            data in
//
//            guard let `self` = self else { return }
//
//            switch data {
//            case .success(_ ):
//
//                LoadingHUD.hide()
//                self.dismiss(animated: true, completion: nil)
//            case .requestErr:
//                LoadingHUD.hide()
//                print("requestErr")
//            case .pathErr:
//                print(".pathErr")
//
//            case .serverErr:
//                print(".serverErr")
//
//            case .networkFail:
//                print(".networkFail")
//
//
//            }
//        }
//
//    }
//
//}
