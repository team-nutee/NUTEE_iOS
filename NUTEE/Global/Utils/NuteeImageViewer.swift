//
//  NuteeImageViewer.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/11.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import SnapKit

class NuteeImageViewer: UIViewController {
    
    // MARK: - UI components
    
    let imageViewContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
    
    var imageList: [UIImage?] = []
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
        addPanGestureRecognizer()
    }

    // MARK: - Helper
    
    func initView() {
        _ = imageViewContainerCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(ImageViewerCVCell.self, forCellWithReuseIdentifier: "ImageViewerCVCell")
            
            $0.backgroundColor = .blue
        }
    }
    
    func makeConstraints() {
        view.addSubview(imageViewContainerCollectionView)
        
        
        imageViewContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    // MARK: - Pan Recognizer
    
    func addPanGestureRecognizer() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(sender:)))
        
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false

        self.view.addGestureRecognizer(viewPan)
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            case .ended:
                if viewTranslation.y < 200 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.transform = .identity
                    })
                } else {
                    dismiss(animated: true, completion: nil)
                }
            default:
                break
            }
    }
    
}

// MARK: - ImageView CollectionView

extension NuteeImageViewer : UICollectionViewDelegate { }
extension NuteeImageViewer : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }
    
}

extension NuteeImageViewer : UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//       view.frame.origin.x = scrollView.contentOffset.x
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let menuIndex = Int(targetContentOffset.pointee.x / view.frame.width)
//        let indexPath = IndexPath(item: menuIndex, section: 0)
//        menuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageViewContainerCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewerCVCell", for: indexPath) as! ImageViewerCVCell
        
        cell.initCell()
        cell.addContentView()
        
        cell.imageView.image = imageList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - ImageViewer CollectionView Cell Definition

class ImageViewerCVCell : UICollectionViewCell {
    
    // MARK: - UI components
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    // MARK: - Helper
    
    func initCell() {
        _ = scrollView.then {
            $0.delegate = self
            
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            $0.minimumZoomScale = 1.0
            $0.maximumZoomScale = 2.0
            
            $0.clipsToBounds = false
            
            $0.backgroundColor = .yellow
        }
        _ = imageView.then {
            $0.contentMode = .scaleAspectFit
            
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView(sender:))))
            
            $0.backgroundColor = .green
        }
    }
    
    func addContentView() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
//        contentView.addSubview(imageView)
        
        scrollView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.width)
            $0.height.equalTo(imageView.snp.height)

            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
//        imageView.snp.makeConstraints {
//            $0.top.equalTo(contentView.snp.top)
//            $0.left.equalTo(contentView.snp.left)
//            $0.right.equalTo(contentView.snp.right)
//            $0.bottom.equalTo(contentView.snp.bottom)
//        }
    }
    
    @objc func didTapImageView(sender: UITapGestureRecognizer) {
        
        print("tapped")
        
        if sender.state == .ended {
            scrollView.zoomScale = 1.0
        }
        sender.cancelsTouchesInView = false
    }
    
}

// MARK: - Scroll Delegate

extension ImageViewerCVCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
