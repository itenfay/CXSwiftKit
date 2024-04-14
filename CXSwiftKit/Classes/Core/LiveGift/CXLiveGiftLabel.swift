//
//  CXLiveGiftLabel.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

#if os(iOS)
import UIKit

public class CXLiveGiftLabel: UILabel {
    
    @objc public var drawTextColor: UIColor = .orange
    
    public override func drawText(in rect: CGRect) {
        let shadowOffSet = self.shadowOffset
        let textColor = self.textColor
        
        let ref = UIGraphicsGetCurrentContext()
        ref?.setLineWidth(5)
        ref?.setLineJoin(CGLineJoin.round)
        ref?.setTextDrawingMode(.fillStroke)
        self.textColor = drawTextColor
        super.drawText(in: rect)
        
        ref?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: rect)
        
        self.shadowOffset = shadowOffSet
    }
    
}

#endif
