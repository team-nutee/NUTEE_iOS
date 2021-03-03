//
//  TagsLayout.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/02.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class TagsLayout: UICollectionViewFlowLayout {
    
    required override init() {
        super.init();
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        common()
    }
    
    private func common() {
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }
    
    override func layoutAttributesForElements(
        in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let att = super.layoutAttributesForElements(in: rect) else {return []}
        var layoutX: CGFloat = sectionInset.left
        var layoutY: CGFloat = -1.0
        
        for layout in att {
            if layout.representedElementCategory != .cell { continue }
            
            if layout.frame.origin.y >= layoutY { layoutX = sectionInset.left }
            layout.frame.origin.x = layoutX
            layoutX += layout.frame.width + minimumInteritemSpacing
            layoutY = layout.frame.maxY
        }
        return att
    }
}
