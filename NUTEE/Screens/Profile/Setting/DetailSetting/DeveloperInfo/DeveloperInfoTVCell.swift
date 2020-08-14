//
//  DeveloperInfoTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/15.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SafariServices

class DeveloperInfoTVCell: UITableViewCell {
    
    static let identifier = Identify.DeveloperInfoTVCell
    
    // MARK: - UI components
    
    let nameLabel = UILabel()
    
    let partLabel = UILabel()
    let termLabel = UILabel()
    
    let gitButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: - Variables and Properties
    
    var developerInfoVC: UIViewController?
    
    var developer = ["", "", "", ""]
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    func initCell () {
        _ = nameLabel.then {
            $0.text = developer[0]
            $0.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 18.0)
        }
        
        _ = partLabel.then {
            $0.text = developer[1]
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15.0)
        }
        
        _ = termLabel.then {
            $0.text = developer[2]
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15.0)
        }
        
        _ = gitButton.then {
            if developer[3] == "" {
                $0.isHidden = true
            }
            
            $0.setTitle("GIT", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            
            $0.tintColor = .white
            $0.backgroundColor = .nuteeGreen
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 0.2 * $0.frame.size.width
            
            $0.addTarget(self, action: #selector(didTapGitButton), for: .touchUpInside)
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(nameLabel)
        
        contentView.addSubview(partLabel)
        contentView.addSubview(termLabel)
        
        contentView.addSubview(gitButton)
        
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(contentView.snp.left).offset(20)
        }
        
        partLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.left.equalTo(nameLabel.snp.right).offset(30)
        }
        termLabel.snp.makeConstraints {
            $0.top.equalTo(partLabel.snp.bottom).offset(10)
            $0.left.equalTo(partLabel.snp.left)
            $0.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
        
        gitButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.right.equalTo(contentView.snp.right).inset(20)
        }
        
    }
    
    @objc func didTapGitButton() {
        let url = URL(string: "https://github.com/" + developer[3])
        let safariViewController = SFSafariViewController(url: url!)
        safariViewController.preferredControlTintColor = .nuteeGreen

        developerInfoVC?.present(safariViewController, animated: true, completion: nil)
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
