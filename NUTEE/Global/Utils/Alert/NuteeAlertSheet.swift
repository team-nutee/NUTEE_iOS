//
//  NuteeAlertSheet.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/15.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit
import SnapKit

class NuteeAlertSheet : UIViewController {
    
    // MARK: - UI components

    let backgroundView = UIView()
    
    let cardView = UIView()
    let handleView = UIView()
    
    let optionTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    // to store the card view top constraint value before the dragging start
    var cardPanStartingTopConstant : CGFloat = 30.0 //default is 30 pt from safe area top
    var handleArea: CGFloat = 30
    
    var optionList = [["", UIColor.self, ""]]
    var optionHeight: CGFloat = 50

    var cardViewTopConstraint: Constraint?
    
    weak var settingProfileImageVCDelegate: SettingProfileImageVCDelegate?
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeConstraints()
        initView()
        
        addPanGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presentingViewController?.view.alpha = 0.7
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        self.presentingViewController?.view.alpha = 1.0
    }
    
    // MARK: - Helper
    
    func initView() {
        
        _ = backgroundView.then {
            $0.backgroundColor = .clear
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutsideCardSheet)))
            $0.isUserInteractionEnabled = true
        }
        
        _ = cardView.then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            $0.backgroundColor = .white
        }
        _ = handleView.then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 3
            $0.backgroundColor = .lightGray
            $0.alpha = 0.5
        }
        _ = optionTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(OptionListTVCell.self, forCellReuseIdentifier: Identify.OptionListTVCell)
            
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
        }
        
    }
    
    func makeConstraints() {
        // Add SubViews
        view.addSubview(backgroundView)
        
        view.addSubview(cardView)
        cardView.addSubview(handleView)
        cardView.addSubview(optionTableView)
        
        
        // Make Constraints
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }

        let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height ?? 0
        cardView.snp.makeConstraints {
            cardViewTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(safeAreaHeight - handleArea - optionHeight * CGFloat(optionList.count)).constraint
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
        handleView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(6)
            
            $0.centerX.equalTo(cardView)
            $0.top.equalTo(cardView.snp.top).offset(10)
        }
        optionTableView.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.top).offset(handleArea)
            $0.left.equalTo(cardView.snp.left)
            $0.right.equalTo(cardView.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func didTapOutsideCardSheet() {
        self.presentingViewController?.view.alpha = 1.0
        self.dismiss(animated: true)
    }
    
    // MARK: - Pan Recognizer
    
    func addPanGestureRecognizer() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false

        self.view.addGestureRecognizer(viewPan)
    }
    
    // this function will be called when user pan/drag the view
    @objc func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
      // how much has user dragged
      let translation = panRecognizer.translation(in: self.view)
      
      switch panRecognizer.state {
      case .began:
        cardPanStartingTopConstant = cardViewTopConstraint?.layoutConstraints[0].constant ?? 0
        
      case .changed :
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height {
            
            let standardPos = safeAreaHeight - handleArea - optionHeight * CGFloat(optionList.count)
            
            let swipeDownSensitivity: CGFloat = 1.5
            if self.cardPanStartingTopConstant + translation.y > standardPos {
                if self.cardPanStartingTopConstant + translation.y * swipeDownSensitivity > 30.0 {
                    cardView.snp.updateConstraints {
                        $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(self.cardPanStartingTopConstant + translation.y * swipeDownSensitivity)
                    }
                    
                    // change the backgroundView alpha based on how much user has dragged
                    self.presentingViewController?.view.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint?.layoutConstraints[0].constant ?? 0)
                }
                
                
            } else {
                
                let swipeUpSensitivity: CGFloat = 0.5
                if self.cardPanStartingTopConstant + translation.y * swipeUpSensitivity > 30.0 {
                    cardView.snp.updateConstraints {
                        $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(self.cardPanStartingTopConstant + translation.y * swipeUpSensitivity)
                    }
                    
                    // change the backgroundView alpha based on how much user has dragged
                    self.presentingViewController?.view.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint?.layoutConstraints[0].constant ?? 0)
                }
                
            }
            
        }
         
      case .ended :
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height {
          
            if self.cardViewTopConstraint?.layoutConstraints[0].constant ?? 0 < (safeAreaHeight - handleArea - optionHeight * CGFloat(optionList.count)) * 0.25 {
            // show the card at normal state
                setRegularPosition()
          } else if self.cardViewTopConstraint?.layoutConstraints[0].constant ?? 0 < (safeAreaHeight) - 200 {
            // show the card at normal state
                setRegularPosition()
          } else {
            // hide the card and dismiss current view controller
            didTapOutsideCardSheet()
          }
        }
        
      default:
        break
      }
    }
    
    private func setRegularPosition() {
        // ensure there's no pending layout changes before animation runs
        self.view.layoutIfNeeded()
        
        // set the new top constraint value for card view
        // card view won't move up just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height {
            
            cardView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(safeAreaHeight - handleArea - optionHeight * CGFloat(optionList.count))
            }
        }
        
        // move card up from bottom by telling the app to refresh the frame/position of view
        // create a new property animator
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        // run the animation
        showCard.startAnimation()
    }
    
    // MARK: - Change alpha value by position
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
      let fullBackgroundViewAlpha: CGFloat = 0.7
      
      // ensure safe area height and safe area bottom padding is not nil
        guard let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
        let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom else {
        return fullBackgroundViewAlpha
      }
      
      // when card view top constraint value is equal to this, the darkest alpha (0.7)
      let fullDimPosition = (safeAreaHeight - handleArea - optionHeight * CGFloat(optionList.count))
      
      // when card view top constraint value is equal to this, the lightest alpha (0.0)
      let noDimPosition = safeAreaHeight + bottomPadding
      
      // if card view top constraint is lesser than fullDimPosition, it is darkest
      if value < fullDimPosition {
        return fullBackgroundViewAlpha
      }
      
      // if card view top constraint is more than noDimPosition, it is lighest
      if value > noDimPosition {
        return 0.0
      }
      
      // else return an alpha value in between 0.0 and 0.7 based on the top constraint value
        return fullBackgroundViewAlpha * 1 + ((value - fullDimPosition) / fullDimPosition) //* 0.4
    }
    
// MARK: - Custom Settings
    
    func editPost() {
        let postVC = PostVC()
        postVC.isEditMode = true
        
        let navigationController = UINavigationController(rootViewController: postVC)
        navigationController.modalPresentationStyle = .currentContext
        
        let beforeVC = self.presentingViewController
        dismiss(animated: true, completion: {
            beforeVC?.present(navigationController, animated: true, completion: nil)
        })
    }
    
    func deletePost() {
        let nuteeAlertDialogue = NuteeAlertDialogue()
        nuteeAlertDialogue.dialogueData = ["게시글 삭제", "해당 게시글을 삭제하시겠습니까?"]
        nuteeAlertDialogue.okButtonData = ["삭제", UIColor.white, UIColor.red]
        
        nuteeAlertDialogue.addDeletePostAction()
        
        nuteeAlertDialogue.modalPresentationStyle = .overCurrentContext
        nuteeAlertDialogue.modalTransitionStyle = .crossDissolve
        
        let beforeVC = self.presentingViewController
        dismiss(animated: true, completion: {
            beforeVC?.present(nuteeAlertDialogue, animated: true)
        })
    }
    
    func reportPost() {
        let nuteeAlertDialogue = NuteeAlertDialogue()
        nuteeAlertDialogue.dialogueData = ["신고하기", "해당 게시글을 신고하시겠습니까?"]
        nuteeAlertDialogue.okButtonData = ["신고", UIColor.white, UIColor.red]
        
        nuteeAlertDialogue.addCancelPostAction()
        
        nuteeAlertDialogue.modalPresentationStyle = .overCurrentContext
        nuteeAlertDialogue.modalTransitionStyle = .crossDissolve
        
        let beforeVC = self.presentingViewController
        dismiss(animated: true, completion: {
            beforeVC?.present(nuteeAlertDialogue, animated: true)
        })
    }
    
    func openLibrary() {
        settingProfileImageVCDelegate?.openSettingProfileImageVCLibrary()
    }
   
    func openCamera() {
        settingProfileImageVCDelegate?.openSettingProfileImageVCCamera()
    }
}

// MARK: - SettingProfileImageVC와 통신하기 위한 프로토콜 정의

protocol SettingProfileImageVCDelegate: class {
    func openSettingProfileImageVCLibrary()
    func openSettingProfileImageVCCamera()
}

// MARK: - optionList TableView

extension NuteeAlertSheet : UITableViewDelegate { }
extension NuteeAlertSheet : UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return optionHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return optionHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.OptionListTVCell, for: indexPath) as! OptionListTVCell
        cell.selectionStyle = .none
        
        cell.optionItem = optionList[indexPath.row]
        
        cell.initCell()
        cell.addContentView()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionList[indexPath.row][2] as? String {
        case "editPost":
            editPost()
        case "deletePost":
            deletePost()
        case "reportPost":
            reportPost()
        case "openLibrary":
            openLibrary()
        case "openCamera":
            openCamera()
        default:
            simpleNuteeAlertDialogue(title: "Error😵", message: "Error ocurred: cannot find")
        }
    }

}

// MARK: - Setting TableViewCell

class OptionListTVCell : UITableViewCell {
    
    static let identifier = Identify.OptionListTVCell
    
    // MARK: - UI components
    
    let optionItemLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    var optionItem = ["", UIColor.self] as [Any]
    
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
        _ = optionItemLabel.then {
            $0.text = optionItem[0] as? String
            $0.font = .systemFont(ofSize: 20)
            $0.textColor = optionItem[1] as? UIColor
        }
    }
    
    func addContentView() {
        contentView.addSubview(optionItemLabel)
        
        optionItemLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if isHighlighted == true {
            contentView.backgroundColor = UIColor(red: 227 / 255.0, green: 241 / 255.0, blue: 223 / 255.0 , alpha: 1.0)
        } else {
            contentView.backgroundColor = .white
        }
    }
    
}
