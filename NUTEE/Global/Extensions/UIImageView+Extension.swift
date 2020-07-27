//
//  UIImageView+Extension.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/22.
//  Copyright © 2020 Nutee. All rights reserved.
//
import Kingfisher
import UIKit

// Kingfisher를 이용하여 url로부터 이미지를 가져오는 extension
extension UIImageView {

    public func imageFromUrl(_ urlString: String?, defaultImgPath : String?) {
        let tmpUrl : String?

        if urlString == nil {
            tmpUrl = ""
        } else  {
            tmpUrl = urlString
        }
        if let url = tmpUrl, let defaultURL : String = defaultImgPath {
            if url.isEmpty {
                self.kf.setImage(with: URL(string: defaultURL), options: [.transition(ImageTransition.fade(0.5))])
            } else {
                self.kf.setImage(with: URL(string: url), options: [.transition(ImageTransition.fade(0.5))])
            }
        }

    }
    
}
