//
//  CXLiveGiftView.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(UIKit)
import UIKit

public typealias animationFinished = (Bool, String) -> Void
public typealias completeBlock = (Bool) -> Void

public class CXLiveGiftView: UIView {
    
    var giftCount: Int = 0 {
        willSet {
            self.currentGiftCount += 1
            self.countLabel.text = "x\(self.currentGiftCount)"
            self.countModifier?(self.countLabel, self.currentGiftCount)
            if self.currentGiftCount > 1 {
                self.setGiftCountAnimation(gift: self.countLabel)
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
                self.perform(#selector(hide), with: nil, afterDelay: TimeInterval(animationTime))
            } else {
                self.perform(#selector(hide), with: nil, afterDelay: TimeInterval(animationTime))
            }
        }
    }
    
    lazy var currentGiftCount: Int = 0
    lazy var animationTime: Int = 2
    lazy var giftModel: CXLiveGiftModel = CXLiveGiftModel()
    
    lazy var backGroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var giftView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeThatFits(CGSize(width: 60, height: 60))
        return imageView
    }()
    
    lazy var countLabel: CXLiveGiftLabel = {
        let label = CXLiveGiftLabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    var giftEndCallBack: ((Bool, String) -> Void)? = nil
    var giftKeyCallBack: ((CXLiveGiftModel) -> Void)? = nil
    var backgroundModifier: ((UIView) -> Void)? = nil
    var giftIconModifier: ((UIImageView) -> Void)? = nil
    var contentModifier: ((UILabel, String) -> Void)? = nil
    var countModifier: ((CXLiveGiftLabel, Int) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNormalAttribute()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CXLiveGiftView {
    
    @objc public func modify(backgroundModifier: ((UIView) -> Void)?,
                             giftIconModifier: ((UIImageView) -> Void)?,
                             contentModifier: ((UILabel, String) -> Void)?,
                             countModifier: ((CXLiveGiftLabel, Int) -> Void)?)
    {
        self.backgroundModifier = backgroundModifier
        self.giftIconModifier = giftIconModifier
        self.contentModifier = contentModifier
        self.countModifier = countModifier
    }
    
    func setNormalAttribute() {
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.isHidden = true
        
        self.addSubview(backGroundView)
        backGroundView.addSubview(contentLabel)
        self.addSubview(giftView)
        self.addSubview(countLabel)
        
        backGroundView.frame = CGRect(x: 2, y: 50, width: 220, height: 30)
        backGroundView.addCorner(roundingCorners: [UIRectCorner.bottomRight, UIRectCorner.topRight], cornerSize: CGSize(width: 15, height: 15))
        contentLabel.frame = CGRect(x: 2, y: backGroundView.bounds.size.height/2 - 10/2, width: 150, height: 10)
        giftView.frame = CGRect(x: 148, y: 0, width: 80, height: 80)
        countLabel.frame = CGRect(x: 225, y: 50, width: 50, height: 30)
    }
    
    func show(giftModel: CXLiveGiftModel, isfinished: animationFinished? = nil) {
        self.giftModel = giftModel
        self.giftEndCallBack = isfinished
        giftView.image = UIImage(named: giftModel.giftName)
        contentLabel.text = giftModel.giftDescription
        backgroundModifier?(backGroundView)
        giftIconModifier?(giftView)
        contentModifier?(contentLabel, contentLabel.text ?? "")
        self.isHidden = false
        if let callBack = giftKeyCallBack, self.currentGiftCount == 0 {
            callBack(giftModel)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }) { (finished) in
            self.currentGiftCount = 0
            self.giftCount = giftModel.defaultCount
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: -self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }) { [weak self] (finished) in
            guard let `self` = self else { return }
            if let callBack = self.giftEndCallBack {
                callBack(true, self.giftModel.giftKey)
                self.giftModel = CXLiveGiftModel()
            }
            self.frame = CGRect(x: -self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            self.isHidden = true
            self.currentGiftCount = 0
            self.countLabel.text = ""
            self.contentLabel.attributedText = NSAttributedString(string: "")
        }
    }
    
    private func setGiftCountAnimation(gift: UIView) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.duration = 0.08
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = 1.0
        pulse.toValue = 1.5
        //pulse.isRemovedOnCompletion = true
        gift.layer.add(pulse, forKey: "")
    }
    
}

extension UIView {
    
    public func addCorner(roundingCorners: UIRectCorner, cornerSize: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
    
}

#endif
