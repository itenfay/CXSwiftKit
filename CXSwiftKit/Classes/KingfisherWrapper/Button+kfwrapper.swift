//
//  Button+Cx.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(Kingfisher)
import Kingfisher

extension CXSwiftBase where T : UIButton {
    
    ///  Sets an image to the button for a specified state with a given url string.
    ///
    /// - Parameters:
    ///   - url: A given url string
    ///   - state: The button state to which the image should be set.
    ///   - placeholder: A placeholder to show while retrieving the image from the given url string.
    ///   - headers: Sets the HTTP header fields of the receiver to the given dictionary.
    ///   - progressBlock: Called when the image downloading progress gets updated.
    public func setImage(
        withUrl url: String?,
        forState state: UIControl.State,
        placeholder: UIImage? = nil,
        headers: [String : String] = [:],
        progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil)
    {
        self.base.cx_setImage(withUrl: url, forState: state, placeholder: placeholder, headers: headers, progressBlock: progressBlock)
    }
    
}

extension UIButton {
    
    ///  Sets an image to the button for a specified state with a given url string.
    ///
    /// - Parameters:
    ///   - url: A given url string
    ///   - state: The button state to which the image should be set.
    ///   - placeholder: A placeholder to show while retrieving the image from the given url string.
    ///   - headers: Sets the HTTP header fields of the receiver to the given dictionary.
    ///   - progressBlock: Called when the image downloading progress gets updated.
    @objc public func cx_setImage(
        withUrl url: String?,
        forState state: UIControl.State,
        placeholder: UIImage? = nil,
        headers: [String : String] = [:],
        progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil)
    {
        guard let _url = url, !_url.isEmpty else {
            debugPrint("[I] " + "The url is invalid.")
            return
        }
        var modifier: AnyModifier? = nil
        if !headers.isEmpty {
            modifier = AnyModifier { request in
                var _request = request
                for key in headers.keys {
                    if let value = headers[key], !value.isEmpty {
                        // replace "key" with the field name you need, it's just an example.
                        _request.setValue(value, forHTTPHeaderField: key)
                    }
                }
                return _request
            }
        }
        
        if let _modifier = modifier {
            self.kf.setImage(
                with: URL.init(string: _url),
                for: state,
                placeholder: placeholder,
                options: [.requestModifier(_modifier)],
                progressBlock: progressBlock
            )
        } else {
            self.kf.setImage(
                with: URL.init(string: _url),
                for: state,
                placeholder: placeholder,
                progressBlock: progressBlock
            )
        }
    }
    
}

#endif
#endif
