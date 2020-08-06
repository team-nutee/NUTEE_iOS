//
//  NoticeCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class NoticeCVCell: UICollectionViewCell {
    
    static let identifier = Identify.noticeCVCell
    
    let label = UILabel().then {
        $0.text = "123"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
        }
        contentView.backgroundColor = .systemBlue
    }
    
}
