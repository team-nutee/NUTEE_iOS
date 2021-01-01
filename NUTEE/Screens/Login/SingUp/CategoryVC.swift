//
//  CategoryVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/12/28.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class CategoryVC: UIViewController {
    
    // MARK: - UI components
    
    // 로그인 화면
    let closeButton = HighlightedButton()
    
    let progressView = UIProgressView()
    
    let guideLabel = UILabel()
    
    let selectCategoryButton = HighlightedButton()
    let selectCategoryUnderLineView = UIView()
    
    let categoryTableView = UITableView()
    
    let previousButton = HighlightedButton()
    let nextButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var totalSignUpViews: Float = 0.0
    var progressStatusCount: Float = 0.0

//    var userId: String = ""
//    var email: String = ""
//    var otp: String = ""

    var animationDuration: TimeInterval = 1.4
    let xPosAnimationRange: CGFloat = 50
    let yPosAnimationRange: CGFloat = 50
    
    var categoryTVCellHeight: CGFloat = 50
    
    var categoryList = ["카테고리1", "카테고리2", "카테고리3"]
    var selectedCategoryList: [String] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeConstraints()
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectCategoryButtonAligment()
        enterCategoryVCAnimate()
    }
    
    // MARK: - Helper
    
    func initView() {
        
        _ = view.then {
            $0.backgroundColor = .white
            $0.tintColor = .nuteeGreen
        }
        
        _ = closeButton.then {
            $0.setTitle("닫기", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            $0.alpha = 0
        }
        
        _ = progressView.then {
            $0.progressViewStyle = .bar
            $0.tintColor = .nuteeGreen
            $0.progress = progressStatusCount / totalSignUpViews
            progressStatusCount += 1
        }
        
        _ = guideLabel.then {
            $0.text = "선호하는 카테고리를 설정해주세요!!"
            $0.font = .boldSystemFont(ofSize: 20)
            
            $0.alpha = 0
        }
        
        _ = selectCategoryButton.then {
            $0.setTitle("카테고리를 설정하러 가볼까요?", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.setTitleColor(.black, for: .normal)
            
            let configuration = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
            $0.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
            
            $0.contentHorizontalAlignment = .right
            $0.semanticContentAttribute = .forceRightToLeft
            
            selectCategoryButtonAligment()
            
            $0.addTarget(self, action: #selector(didTapSelectCategoryButton), for: .touchUpInside)
            
            $0.alpha = 0
        }
        _ = selectCategoryUnderLineView.then {
            $0.backgroundColor = .nuteeGreen
            
            $0.alpha = 0
        }
        
        _ = categoryTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(CategoryTVCell.self, forCellReuseIdentifier: Identify.CategoryTVCell)
            
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
        }
        
        _ = previousButton.then {
            $0.setTitle("이전", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        }
        _ = nextButton.then {
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.isEnabled = true
            $0.setTitleColor(.veryLightPink, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        }
        
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(closeButton)
        
        view.addSubview(progressView)
        
        view.addSubview(guideLabel)
        
        view.addSubview(selectCategoryButton)
        view.addSubview(selectCategoryUnderLineView)
        
        view.addSubview(categoryTableView)
        
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        
        // Make Constraints
        closeButton.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(closeButton.snp.width)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(20)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(35 - yPosAnimationRange)
            $0.left.equalTo(closeButton.snp.left)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        selectCategoryButton.snp.makeConstraints {
            $0.height.equalTo(30)
            
            $0.top.equalTo(guideLabel.snp.bottom).offset(40 + yPosAnimationRange)
            $0.left.equalTo(guideLabel.snp.left).offset(xPosAnimationRange)
            $0.right.equalTo(guideLabel.snp.right).inset(-xPosAnimationRange)
        }
        selectCategoryUnderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(selectCategoryButton.snp.width)
            
            $0.top.equalTo(selectCategoryButton.snp.bottom)
            $0.left.equalTo(selectCategoryButton.snp.left)
            $0.right.equalTo(selectCategoryButton.snp.right)
        }
        
        categoryTableView.snp.makeConstraints {
            $0.top.equalTo(selectCategoryUnderLineView.snp.bottom).offset(30)
            $0.left.equalTo(guideLabel.snp.left)
            $0.right.equalTo(guideLabel.snp.right)
            $0.bottom.equalTo(previousButton.snp.top).inset(-30)
        }
        
        previousButton.snp.makeConstraints {
            $0.width.equalTo(view.frame.size.width / 2.0)
            $0.height.equalTo(50)
            
            $0.left.equalTo(view.snp.left)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        nextButton.snp.makeConstraints {
            $0.width.equalTo(previousButton.snp.width)
            $0.height.equalTo(previousButton.snp.height)
            
            $0.centerY.equalTo(previousButton)
            $0.left.equalTo(previousButton.snp.right)
        }
    }
    
    func selectCategoryButtonAligment() {
        var space: CGFloat = 0.0
        space = selectCategoryButton.frame.width - (selectCategoryButton.titleLabel?.frame.width ?? 0) - (selectCategoryButton.imageView?.frame.width ?? 0)
        selectCategoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
    }
    
    func updateCategoryVC() {
        categoryTableView.reloadData()
        
        if selectedCategoryList.isEmpty == true {
            selectCategoryButton.titleLabel?.alpha = 0.5
            UIView.animate(withDuration: animationDuration,
                           delay: 0.1,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 1,
                           options: [.curveEaseIn],
                           animations: {
                            self.selectCategoryButton.titleLabel?.alpha = 1
            })
            
            selectCategoryButton.setTitle("카테고리를 설정하러 가볼까요?", for: .normal)
            
            nextButton.isEnabled = false
            nextButton.setTitleColor(.veryLightPink, for: .normal)
        } else {
            selectCategoryButton.setTitle("선택한 카테고리를 확인해주세요", for: .normal)
            
            nextButton.isEnabled = true
            nextButton.setTitleColor(.nuteeGreen, for: .normal)
        }
        selectCategoryButton.titleLabel?.sizeToFit()
    }
    
    @objc func didTapSelectCategoryButton() {
        let selectCategorySheet = NuteeAlertSheet()
        selectCategorySheet.categoryVC = self
        
        selectCategorySheet.handleArea = 0
        selectCategorySheet.titleContent = "카테고리를 선택해주세요"
        
        var optionList = [[Any]]()
        for category in categoryList {
            optionList.append([category, UIColor.gray, "selectCategory", true])
        }
        selectCategorySheet.optionList = optionList
        selectCategorySheet.optionContentAligment = "left"
        
        selectCategorySheet.modalPresentationStyle = .custom
        
        present(selectCategorySheet, animated: true)
    }
    
    @objc func didTapPreviousButton() {
        self.modalTransitionStyle = .crossDissolve
        
        dismiss(animated: true)
    }
    
    @objc func didTapNextButton() {
        let majorVC = MajorVC()
        majorVC.totalSignUpViews = totalSignUpViews
        majorVC.progressStatusCount = progressStatusCount
        
        majorVC.modalPresentationStyle = .fullScreen
        
        present(majorVC, animated: false)
    }
    
}

// MARK: - CategoryVC Animation

extension CategoryVC {
    
    private func enterCategoryVCAnimate() {
        
        // guide title
        UIView.animate(withDuration: animationDuration,
                       delay: 1,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.guideLabel.alpha = 1
                        self.guideLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
        })
        
        // select category button
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4 + 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        
                        self.selectCategoryButton.alpha = 1
                        self.selectCategoryButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.selectCategoryUnderLineView.alpha = 1
                        self.selectCategoryUnderLineView.transform = CGAffineTransform.init(translationX: -50, y: 0)
        })
        
        // progressView
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: { [self] in
                        progressView.setProgress(progressStatusCount / totalSignUpViews, animated: true)
        })
        
    }
    
}

// MARK: - optionList TableView

extension CategoryVC : UITableViewDelegate { }
extension CategoryVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return categoryTVCellHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return categoryTVCellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.CategoryTVCell, for: indexPath) as! CategoryTVCell
        cell.selectionStyle = .none
        
        cell.categoryVC = self
        cell.indextPathRow = indexPath.row
        
        cell.initCell()
        cell.addContentView()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}

// MARK: - Setting TableViewCell

class CategoryTVCell : UITableViewCell {
    
    static let identifier = Identify.CategoryTVCell
    
    // MARK: - UI components
    
    let selectedCategoryLabel = UILabel()
    let deleteCategoryButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var categoryVC: CategoryVC?
    var indextPathRow: Int?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = selectedCategoryLabel.then {
            $0.text = categoryVC?.selectedCategoryList[indextPathRow!]
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .black
            $0.textAlignment = .left
        }
        _ = deleteCategoryButton.then {
            $0.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            $0.tintColor = .gray
            
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
            
            $0.addTarget(self, action: #selector(didTapDeleteCategoryButton), for: .touchUpInside)
        }
    }
    
    func addContentView() {
        contentView.addSubview(selectedCategoryLabel)
        contentView.addSubview(deleteCategoryButton)
        
        selectedCategoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(contentView.snp.left)
        }
        deleteCategoryButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(deleteCategoryButton.snp.width)
            
            $0.centerY.equalTo(selectedCategoryLabel)
            $0.left.equalTo(selectedCategoryLabel.snp.right).offset(10)
            $0.right.equalTo(contentView.snp.right)
        }
    }
    
    @objc func didTapDeleteCategoryButton() {
        categoryVC?.selectedCategoryList.remove(at: indextPathRow!)
        categoryVC?.updateCategoryVC()
    }
    
}

// MARK: - Server connect

extension CategoryVC {
}
