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
    
    let dismissButton = HighlightedButton()
    let pageControl = UIPageControl()
    
    // MARK: - Variables and Properties
    
    let minimumAlphaValue: CGFloat = 0.15
    let maximumAlphaValue: CGFloat = 1.0
    
    var imageList: [PostImage?] = []
    var imageTag: Int?
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
        
        initView()
        makeConstraints()
        
        addPanGestureRecognizer()
        
        scrollToSelectedImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presentingViewController?.view.alpha = minimumAlphaValue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        self.presentingViewController?.view.alpha = maximumAlphaValue
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = view.then {
            $0.backgroundColor = .clear
        }
        
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
            
            $0.backgroundColor = .clear
        }
        
        _ = dismissButton.then {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .white
            
            $0.addTarget(self, action: #selector(dismissImageViewer), for: .touchUpInside)
        }
        _ = pageControl.then {
            $0.backgroundColor = .clear
            $0.pageIndicatorTintColor = .white
            $0.currentPageIndicatorTintColor = .nuteeGreen
            $0.isUserInteractionEnabled = false
        }
    }
    
    func makeConstraints() {
        view.addSubview(imageViewContainerCollectionView)
        
        view.addSubview(dismissButton)
        view.addSubview(pageControl)
        
        
        imageViewContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        dismissButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(dismissButton.snp.width)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(view.snp.right).inset(10)
        }
        pageControl.snp.makeConstraints {
            $0.height.equalTo(50)
            
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    func setImageSource(imageList: [PostImage?], tag: Int) {
        self.imageList = imageList
        self.imageTag = tag
        
        let numberOfImages = imageList.count
        if numberOfImages > 1 {
            _ = pageControl.then {
                $0.numberOfPages = numberOfImages
                $0.currentPage = imageTag ?? 0
            }
        }
    }
    
    func scrollToSelectedImage() {
        imageViewContainerCollectionView.performBatchUpdates(nil) { [self] (isLoded) in
            if isLoded {
                let indexPath = IndexPath(item: imageTag ?? 0, section: 0)
                imageViewContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    @objc func dismissImageViewer() {
        dismiss(animated: true, completion: nil)
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
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        let viewTranslation = sender.translation(in: view)
        let absoluteViewTranslationY = abs(viewTranslation.y)
        
        switch sender.state {
            case .changed:
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [self] in
                    dismissButton.alpha = 0
                    pageControl.alpha = 0
                    
                    imageViewContainerCollectionView.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                })
                
                presentingViewController?.view.alpha = changeAlphaByDragLevel(value: absoluteViewTranslationY)
                
            case .ended:
                if absoluteViewTranslationY < 200 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [self] in
                        dismissButton.alpha = 1
                        pageControl.alpha = 1
                        
                        imageViewContainerCollectionView.transform = .identity
                    })
                } else {
                    dismissImageViewer()
                }
                
                presentingViewController?.view.alpha = minimumAlphaValue
                
            default:
                break
            }
    }
    
    // MARK: - Change alpha value by position

    private func changeAlphaByDragLevel(value: CGFloat) -> CGFloat {
      // ensure safe area height and safe area bottom padding is not nil
        guard let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height else {
        return maximumAlphaValue
      }
    
        let alphaValue = value / (safeAreaHeight / 2)
        
        if alphaValue > minimumAlphaValue {
            return alphaValue
        } else {
            return minimumAlphaValue
        }
    }
    
}

// MARK: - ImageViewer CollectionView

extension NuteeImageViewer : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }
    
}

extension NuteeImageViewer : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentImageIndex = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = currentImageIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageViewContainerCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewerCVCell", for: indexPath) as! ImageViewerCVCell
        
        cell.nuteeImageViewer = self
        cell.imageView.imageFromUrl(imageList[indexPath.row]?.src, defaultImgPath: "")
        
        return cell
    }
    
}

// MARK: - ImageViewer CollectionView Cell Definition

class ImageViewerCVCell : UICollectionViewCell {
    
    // MARK: - UI components
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    // MARK: - Variables and Properties
    
    var nuteeImageViewer: NuteeImageViewer?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCell()
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = scrollView.then {
            $0.delegate = self
            
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            $0.minimumZoomScale = 1.0
            $0.maximumZoomScale = 3.0
            
            $0.clipsToBounds = false
            
            $0.backgroundColor = .clear
        }
        _ = imageView.then {
            $0.contentMode = .scaleAspectFit
            
            $0.isUserInteractionEnabled = true
            setClickActionsInImageView($0)
            
            $0.backgroundColor = .clear
        }
    }
    
    func addContentView() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)

        
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
    }
    
    func setClickActionsInImageView(_ imageView: UIImageView) {
        imageView.tag = 1
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(singleTapImageView(sender:)))
        tapGestureRecognizer1.numberOfTapsRequired = 1
        
        imageView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(doubleTapImageView(sender:)))
        tapGestureRecognizer2.numberOfTapsRequired = 2
        
        imageView.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    @objc func singleTapImageView(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3) { [self] in
                scrollView.zoomScale = 1.0
                
                if nuteeImageViewer?.dismissButton.alpha == 0 {
                    nuteeImageViewer?.dismissButton.alpha = 1
                    nuteeImageViewer?.pageControl.alpha = 1
                } else {
                    nuteeImageViewer?.dismissButton.alpha = 0
                    nuteeImageViewer?.pageControl.alpha = 0
                }
            }
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc func doubleTapImageView(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3) { [self] in
                let point = sender.location(in: imageView)
                let size = CGSize(width: scrollView.frame.size.width / scrollView.maximumZoomScale,
                                  height: scrollView.frame.size.height / scrollView.maximumZoomScale)
                let origin = CGPoint(x: point.x - size.width / 2,
                                     y: point.y - size.height / 2)
                scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
            }
        }
        sender.cancelsTouchesInView = false
    }
    
}

// MARK: - Scroll Delegate

extension ImageViewerCVCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height

                let ratio = ratioW < ratioH ? ratioW : ratioH

                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio

                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        UIView.animate(withDuration: 0.1) { [self] in
            nuteeImageViewer?.dismissButton.alpha = 0
            nuteeImageViewer?.pageControl.alpha = 0
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            UIView.animate(withDuration: 0.1) { [self] in
                nuteeImageViewer?.dismissButton.alpha = 1
                nuteeImageViewer?.pageControl.alpha = 1
            }
        }
    }
}
