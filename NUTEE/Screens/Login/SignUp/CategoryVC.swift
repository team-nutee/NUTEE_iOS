//
//  CategoryVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/12/28.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class CategoryVC: SignUpViewController {
    
    // MARK: - UI components
    
    let selectCategoryButton = HighlightedButton()
    let selectCategoryUnderLineView = UIView()
    
    let categoryTableView = UITableView()
    
    // MARK: - Variables and Properties
    
//    var userId: String = ""
//    var email: String = ""
//    var otp: String = ""

    var categoryTVCellHeight: CGFloat = 50
    
    var categoryList = ["카테고리1", "카테고리2", "카테고리3"]
    var selectedCategoryList: [String] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeConstraints()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        enterCategoryVCAnimate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectCategoryButtonAligment()
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = guideLabel.then {
            $0.text = "선호하는 카테고리를 설정해주세요!!"
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
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(selectCategoryButton)
        view.addSubview(selectCategoryUnderLineView)
        
        view.addSubview(categoryTableView)
        
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        
        // Make Constraints
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
        selectCategorySheet.isNeedCompleteButton = true
        
        var optionList = [[Any]]()
        for category in categoryList {
            optionList.append([category, UIColor.gray, "selectCategory", true])
        }
        selectCategorySheet.optionList = optionList
        selectCategorySheet.optionContentAligment = "left"
        
        present(selectCategorySheet, animated: true)
    }
    
    @objc override func didTapNextButton() {
        let majorVC = MajorVC()
        majorVC.totalSignUpViews = totalSignUpViews
        majorVC.progressStatusCount = progressStatusCount
        
        present(majorVC, animated: false)
    }
    
}

// MARK: - CategoryVC Animation

extension CategoryVC {
    
    private func enterCategoryVCAnimate() {
        // select category button
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        
                        self.selectCategoryButton.alpha = 1
                        self.selectCategoryButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.selectCategoryUnderLineView.alpha = 1
                        self.selectCategoryUnderLineView.transform = CGAffineTransform.init(translationX: -50, y: 0)
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