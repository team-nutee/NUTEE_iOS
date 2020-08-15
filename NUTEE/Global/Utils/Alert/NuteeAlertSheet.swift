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
    
    let cancelButton = UIButton()
    
    // MARK: - Variables and Properties
    
    // to store the card view top constraint value before the dragging start
    var cardPanStartingTopConstant : CGFloat = 30.0 //default is 30 pt from safe area top
    
    var cardViewTopConstraint: Constraint?
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeConstraints()
        initView()
        
        addPanGestureRecognizer()
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
        }
        _ = cancelButton.then {
            $0.setTitle("취소", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
            $0.tintColor = .white
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 0.5 * $0.frame.size.width
            print("2", $0.frame.size.width)
            $0.backgroundColor = .nuteeGreen
        }
        
    }
    
    func makeConstraints() {
        // Add SubViews
        view.addSubview(backgroundView)
        
        view.addSubview(cardView)
        cardView.addSubview(handleView)
        cardView.addSubview(cancelButton)
        
        
        // Make Constraints
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }

        let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height ?? 0
        let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        cardView.snp.makeConstraints {
            cardViewTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset((safeAreaHeight + bottomPadding) / 2).constraint
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
        
        cancelButton.snp.makeConstraints {
            let width = cardView.frame.size.width - 20
            print("1", cardView.frame.size.width - 20)
            $0.width.equalTo(width)
            $0.height.equalTo(40)
            
            $0.centerX.equalTo(cardView)
            $0.left.equalTo(cardView.snp.left).offset(20)
            $0.right.equalTo(cardView.snp.right).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
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
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            
            let standardPos = (safeAreaHeight + bottomPadding) / 2
            
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
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
          let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
          
            if self.cardViewTopConstraint?.layoutConstraints[0].constant ?? 0 < (safeAreaHeight + bottomPadding) * 0.25 {
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
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            cardView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset((safeAreaHeight + bottomPadding) / 2)
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
      let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
      
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
        return fullBackgroundViewAlpha * 1 + ((value - fullDimPosition) / fullDimPosition) * 0.4
    }
   
}
