//
//  TableView+Cx.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : UITableView {
    
    /// Finds the table view cell by touched point.
    public func findCell(with point: CGPoint) -> UITableViewCell? {
        return base.cx_findCell(with: point)
    }
    
}

extension UITableView {
    
    /// Finds the table view cell by touched point.
    @objc public func cx_findCell(with point: CGPoint) -> UITableViewCell? {
        var cell: UITableViewCell?
        for view in subviews {
            let classPtr = object_getClassName(view)
            let className = String(cString: classPtr)
            if !className.contains("UITableViewWrapperView") {
                continue
            }
            for tempView in view.subviews {
                if tempView.isKind(of: UITableViewCell.self) &&
                    CGRectContainsPoint(tempView.frame, point) {
                    cell = tempView as? UITableViewCell
                    break
                }
            }
            break
        }
        return cell
    }
    
}

#endif
