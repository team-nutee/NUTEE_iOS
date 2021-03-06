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
    
    let postTitleTextField = UITextField()
    
    let categoryButton = UIButton()
    let majorButton = UIButton()
    
    let postContentTextView = PlaceholderTextView()
    
    let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let imagePickerView = UIView()
    let imagePickerButton = UIButton()
    
    // MARK: - Variables and Properties
    
    var categoryList: [String] = []
    var selectedCategory: String?
    
    var majorList: [String] = []
    var selectedMajor: String?
    
    var pickedCategory: String?

    var pickedIMG : [UIImage] = []
    
    var selectedItems = [YPMediaItem]()
    
    var uploadedImages: [NSString] = []
    
    var isEditMode = false
    
    var editPostBody: PostBody?
    var editPostContent: PostContent?
    var editPostImage: [PostImage?] = []
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setNavigationBarItem()
        initPostingView()
        addSubView()
        
        setEditMode()
        
        getCategoriesService()
        getMyProfileService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        Analytics.logEvent("postview", parameters: [
            "name": "포스팅 뷰 선택" as NSObject,
            "full_text": "포스팅 뷰 선택" as NSObject
        ])
        
        addKeyboardNotification()
        self.postTitleTextField.becomeFirstResponder()
        
        if isEditMode {
            categoryButton.setTitle(selectedCategory, for: .normal)
            categoryButton.isEnabled = false
            
            majorButton.isHidden = true
        }
    }
    
    
    // MARK: - Helper
    
    func setNavigationBarItem() {
        let barItemFont = UIFont.boldSystemFont(ofSize: 20)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(didTapClosePosting))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: barItemFont, NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        
        var rightBarTitle = "게시"
        if isEditMode == true {
            rightBarTitle = "수정"
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightBarTitle, style: .plain, target: self, action: #selector(didTapUploadPosting))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: barItemFont, NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: barItemFont, NSAttributedString.Key.foregroundColor: UIColor.veryLightPink], for: .disabled)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func initPostingView() {
        _ = scrollView.then {
            $0.verticalScrollIndicatorInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        }
        
        _ = postTitleTextField.then {
            $0.delegate = self
            
            $0.font = .boldSystemFont(ofSize: 20)
            $0.placeholder = "제목을 입력해주세요"
            $0.tintColor = .nuteeGreen
        }
        
        _ = categoryButton.then {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .nuteeGreen

            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("카테고리", for: .normal)
            
            $0.addTarget(self, action: #selector(didTapSelectPostCategoryButton), for: .touchUpInside)
        }
        
        
        _ = majorButton.then {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .nuteeGreen

            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("내 전공", for: .normal)
            
            $0.addTarget(self, action: #selector(didTapSelectPostMajorButton), for: .touchUpInside)
        }
        
        _ = postContentTextView.then {
            $0.delegate = self
            
            $0.font = .systemFont(ofSize: 15)
            
            $0.placeholderLabel.text = "내용을 입력해주세요"
            $0.placeholderLabel.font = .systemFont(ofSize: 15)
            
            $0.tintColor = .nuteeGreen
            $0.isScrollEnabled = false
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
        
        containerView.addSubview(postTitleTextField)
        containerView.addSubview(categoryButton)
        containerView.addSubview(majorButton)
        containerView.addSubview(postContentTextView)

        containerView.addSubview(imageCollectionView)
        
        view.addSubview(imagePickerView)
        imagePickerView.addSubview(imagePickerButton)
        
        // Make Constraints
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(20)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }
        
        let topAndBottomSpace = 15
        let leftAndRightSpace = 15
        
        containerView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.greaterThanOrEqualTo(scrollView.snp.height)
            
            $0.top.equalTo(scrollView.snp.top)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        
        postTitleTextField.snp.makeConstraints {
            $0.height.equalTo(24)
            
            $0.top.equalTo(containerView.snp.top)
            $0.left.equalTo(containerView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(containerView.snp.right).inset(leftAndRightSpace)
        }
        
        categoryButton.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(67)
            $0.height.equalTo(28)
            
            $0.top.equalTo(postTitleTextField.snp.bottom).offset(topAndBottomSpace)
            $0.left.equalTo(postTitleTextField.snp.left)
        }
        
        majorButton.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(67)
            $0.height.equalTo(28)
            
            $0.top.equalTo(postTitleTextField.snp.bottom).offset(topAndBottomSpace)
            $0.left.equalTo(categoryButton.snp.right).offset(leftAndRightSpace)
        }
        
        postContentTextView.snp.makeConstraints {
            $0.top.equalTo(categoryButton.snp.bottom).offset(topAndBottomSpace)
            $0.left.equalTo(containerView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(containerView.snp.right).inset(leftAndRightSpace)
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.height.equalTo(60)
            
            $0.top.equalTo(postContentTextView.snp.bottom).offset(topAndBottomSpace)
            $0.left.equalTo(containerView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(containerView.snp.right).inset(leftAndRightSpace)
            $0.bottom.equalTo(containerView.snp.bottom).inset(topAndBottomSpace)
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
            $0.left.equalTo(imagePickerView.snp.left).offset(leftAndRightSpace)
        }
    }
    
    func setEditMode() {
        if self.editPostContent != nil {
            postTitleTextField.text = editPostContent?.body.title ?? ""
            postContentTextView.text = editPostContent?.body.content ?? ""
            selectedCategory = editPostContent?.body.category ?? ""
            editPostImage = editPostContent?.body.images ?? []
        } else {
            postTitleTextField.text = editPostBody?.title ?? ""
            postContentTextView.text = editPostBody?.content ?? ""
            selectedCategory = editPostBody?.category ?? ""
            editPostImage = editPostBody?.images ?? []
        }
    }
    
    @objc func didTapClosePosting() {
        // 입력된 빈칸과 줄바꿈 개수 구하기
        let titleStr = postTitleTextField.text?.count
        var contentStr = postContentTextView.text.replacingOccurrences(of: " ", with: "")
        contentStr = contentStr.replacingOccurrences(of: "\n", with: "")
        
        // 빈칸이나 줄바꿈으로만 입력된 경우 포스팅 창 바로 나가기
        if pickedIMG.count != 0 || editPostImage.count > 1 || contentStr.count != 0 || titleStr != 0 {
            var content = ""
            if isEditMode == true {
                content = "수정을 취소하시겠습니까?"
            } else {
                content = "작성을 취소하시겠습니까?"
            }
            let nuteeAlertDialogue = NuteeAlertDialogue()
            nuteeAlertDialogue.dialogueData = ["나가기", content]
            
            nuteeAlertDialogue.cancelButtonData[0] = "아니오"
            
            nuteeAlertDialogue.okButtonData = ["예", UIColor.white, UIColor.red]
            nuteeAlertDialogue.okButton.addTarget(self, action: #selector(didTapCancelPostYes), for: .touchUpInside)
            
            nuteeAlertDialogue.modalPresentationStyle = .overCurrentContext
            nuteeAlertDialogue.modalTransitionStyle = .crossDissolve
            
            present(nuteeAlertDialogue, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTapCancelPostYes() {
        let beforeVC = self.presentingViewController
        dismiss(animated: true, completion: {
            beforeVC?.dismiss(animated: true)
        })
    }
    
    @objc func didTapUploadPosting() {
        if isEditMode == false {
            // 사진이 있을때는 사진 올리고 게시물 업로드를 위한 분기처리
            if pickedIMG != [] {
                postImage(images: pickedIMG, completionHandler: {(returnedData)-> Void in
                    self.uploadPost(images: self.uploadedImages, title: self.postTitleTextField.text ?? "", content: self.postContentTextView.text ?? "", category: self.pickedCategory ?? "")
                })
            } else {
                uploadPost(images: [], title: postTitleTextField.text ?? "", content: postContentTextView.text ?? "", category: self.pickedCategory ?? "")
            }
            
        } else {
            // 사진이 있을때는 사진 올리고 게시물 업로드를 위한 분기처리
            var images: [NSString] = []
            for image in self.editPostImage {
                images.append((image?.src! ?? "") as NSString)
            }
            
            if pickedIMG != [] {
                postImage(images: pickedIMG, completionHandler: {(returnedData)-> Void in
                    for uploadimg in self.uploadedImages {
                        images.append(uploadimg)
                    }
                    
                    if self.editPostContent != nil {
                        self.editPost(postId: self.editPostContent?.body.id ?? 0, title: self.postTitleTextField.text ?? "", content: self.postContentTextView.text ?? "", images: images)
                    } else {
                        self.editPost(postId: self.editPostBody?.id ?? 0, title: self.postTitleTextField.text ?? "", content: self.postContentTextView.text ?? "", images: images)
                    }
                })
            } else {
                if self.editPostContent != nil {
                    self.editPost(postId: self.editPostContent?.body.id ?? 0, title: self.postTitleTextField.text ?? "", content: self.postContentTextView.text ?? "", images: images)
                } else {
                    self.editPost(postId: self.editPostBody?.id ?? 0, title: self.postTitleTextField.text ?? "", content: self.postContentTextView.text ?? "", images: images)
                }
            }
        }
    }

    
    func updatePostMajorButtonStatus() {
        majorButton.alpha = 1.0
        majorButton.setTitle(selectedMajor, for: .normal)
        pickedCategory = selectedMajor
        
        if selectedCategory != "" {
            selectedCategory = ""
            categoryButton.setTitle("카테고리", for: .normal)
        }
        categoryButton.alpha = 0.5
    }
    
    func updatePostCategoryButtonStatus() {
        categoryButton.alpha = 1.0
        categoryButton.setTitle(selectedCategory, for: .normal)
        pickedCategory = selectedCategory
        
        if selectedMajor != "" {
            selectedMajor = ""
            majorButton.setTitle("내 전공", for: .normal)
        }
        majorButton.alpha = 0.5
    }
    
    @objc func didTapSelectPostCategoryButton() {
        showCategoryListSheet()
    }
    
    @objc func didTapSelectPostMajorButton() {
        showMajorListSheet()
    }
}

// MARK: - NuteeAlert Action Definition

extension PostVC: NuteeAlertActionDelegate {
    
    func showCategoryListSheet() {
        let selectCategorySheet = NuteeSelectSheet()
        selectCategorySheet.nuteeAlertActionDelegate = self
        selectCategorySheet.selectMode = .category
        
        selectCategorySheet.titleContent = "카테고리를 선택해주세요"
        
        selectCategorySheet.itemList = categoryList
        
        selectCategorySheet.modalPresentationStyle = .custom
        present(selectCategorySheet, animated: true)
    }
    
    func showMajorListSheet() {
        let selectMajorSheet = NuteeSelectSheet()
        selectMajorSheet.nuteeAlertActionDelegate = self
        selectMajorSheet.selectMode = .major
        
        selectMajorSheet.titleContent = "전공을 선택해주세요"
        
        selectMajorSheet.itemList = majorList
        
        selectMajorSheet.modalPresentationStyle = .custom
        present(selectMajorSheet, animated: true)
    }
    
    func nuteeSelectSheetAction(selectedOptionItem: String, sheetMode: SelectMode) {
        switch sheetMode {
        case .category:
            selectedCategory = selectedOptionItem
            updatePostCategoryButtonStatus()
        case .major:
            selectedMajor = selectedOptionItem
            updatePostMajorButtonStatus()
        default:
            break
        }
    }
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
            return (editPostImage.count ) + pickedIMG.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCVCell", for: indexPath) as! PostImageCVCell
        
        if isEditMode == false {
            cell.postImageImageView.image = pickedIMG[indexPath.row]
        } else {
            if editPostImage.count > 0 && indexPath.row < editPostImage.count {
                cell.postImageImageView.setImage(with: editPostImage[indexPath.row]?.src ?? "")
            } else {
                let fixIndex = Int(indexPath.row) - (editPostImage.count)
                cell.postImageImageView.image = pickedIMG[fixIndex]
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditMode == false {
            pickedIMG.remove(at: indexPath.row)
        } else {
            if editPostImage.count > 0 && indexPath.row < editPostImage.count {
                editPostImage.remove(at: indexPath.row)
            } else {
                let fixIndex = Int(indexPath.row) - (editPostImage.count)
                pickedIMG.remove(at: fixIndex)
            }
        }
        
        self.imageCollectionView.reloadData()
    }
    
}

// MARK: - UITextView Delegate, UITextField Delegate
extension PostVC: UITextViewDelegate {
    
    // TextView의 동적인 크기 변화를 위한 function
    func textViewDidChange(_ textView: UITextView) {
        
        postContentTextView.handlePlaceholder()
        
        // textView 높이 동적으로 구성하기
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        // 게시 버튼 활성화(빈칸이나 줄바꿈으로만 입력된 경우 비활성화) 조건
        let titleStr = postTitleTextField.text ?? ""
        
        var str = postContentTextView.text.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        
        if str.count != 0 && titleStr.count != 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
}

extension PostVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        // 제목 글자 수 한글 기준 30자 제한
        let newLength = text.count + string.count - range.length
        return newLength <= 31
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textViewDidChange(postContentTextView)
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
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
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
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        }
        present(picker, animated: true, completion: nil)
    }
    
}

// MARK: - PostVC 서버 연결
extension PostVC {
    
    func uploadPost(images: [NSString], title: String, content: String, category: String){
        ContentService.shared.createPost(title: title, content: content, category: category, images: images){
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(_ ):
                self.dismiss(animated: true, completion: nil)
            
            case .requestErr(_):
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "카테고리나 전공을 선택해주세요")

            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "서버 연결에 오류가 있습니다")

            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "서버에 오류가 있습니다")

            case .networkFail:
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "네트워크에 오류가 있습니다")
            }
        }
    }

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
                self.simpleNuteeAlertDialogue(title: "이미지 업로드 실패", message: "\(message)")

            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "이미지 업로드 실패", message: "서버 연결에 오류가 있습니다")

            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "이미지 업로드 실패", message: "서버에 오류가 있습니다")

            case .networkFail:
                self.simpleNuteeAlertDialogue(title: "이미지 업로드 실패", message: "네트워크에 오류가 있습니다")

            }
        }
    }
    
    func editPost(postId: Int, title: String, content: String, images: [NSString]){
        ContentService.shared.editPost(postId: postId, title: title, content: content, images: images){
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(_ ):
                self.dismiss(animated: true, completion: nil)
                
            case .requestErr(let message):
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "\(message)")

            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "서버 연결에 오류가 있습니다")

            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "서버에 오류가 있습니다")

            case .networkFail:
                self.simpleNuteeAlertDialogue(title: "게시물 업로드 실패", message: "네트워크에 오류가 있습니다")

            }
        }
    }
    
    func getCategoriesService() {
        ContentService.shared.getCategories() {
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.categoryList = res as! [String]
                
            case .requestErr(let message):
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "\(message)")

            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "서버 연결에 오류가 있습니다")
                
            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "서버에 오류가 있습니다")

            case .networkFail:
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "네트워크에 오류가 있습니다")
            }
        }
    }
    
    func getMyProfileService() {
        UserService.shared.getMyProfile(completion: { (returnedData) -> Void in
            
            switch returnedData {
            case .success(let res):
                let response = res as! User
                self.majorList = response.body.majors
                
            case .requestErr(let message):
                self.simpleNuteeAlertDialogue(title: "내 정보 조회 실패", message: "\(message)")

            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "내 정보 조회 실패", message: "서버 연결에 오류가 있습니다")
                
            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "내 정보 조회 실패", message: "서버에 오류가 있습니다")

            case .networkFail:
                self.simpleNuteeAlertDialogue(title: "내 정보 조회 실패", message: "네트워크에 오류가 있습니다")
            }
        })
    }
}
