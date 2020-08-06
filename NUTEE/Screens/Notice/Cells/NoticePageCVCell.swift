//
//  NoticePageCVCell.swift
//  NUTEE
//
//  Created by 오준현 on 2020/08/03.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class NoticePageCVCell: UICollectionViewCell {
    
    static let identifier = Identify.noticePageCVCell

    let contentCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: UICollectionViewLayout()).then
    {
        $0.backgroundColor = .white
        $0.register(NoticeCVCell.self, forCellWithReuseIdentifier: Identify.noticeCVCell)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(contentCollectionView)
        
        contentCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    
    
}

extension NoticePageCVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: contentView.frame.width, height: 60)
    }
    
}

extension NoticePageCVCell: UICollectionViewDelegate { }

extension NoticePageCVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.noticeCVCell,
                                                      for: indexPath) as! NoticeCVCell
        
        cell.awakeFromNib()
        
        return cell
    }
    
    
}
