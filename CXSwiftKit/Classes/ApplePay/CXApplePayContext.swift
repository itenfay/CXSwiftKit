//
//  CXApplePayContext.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(PassKit) && !os(tvOS)
import Foundation
import PassKit

/// For In-App-Purchase, please see:
/// - [ObjC](https://github.com/chenxing640/DYFStoreKit)
/// - [Swift](https://github.com/chenxing640/DYFStore)

/// The class for Apple payment.
public class CXApplePayContext: NSObject {
    
    @objc public weak var controller: CXViewController!
    
    @objc public init(controller: CXViewController) {
        self.controller = controller
    }
    
    @objc public private(set) var currentPaymentRequest: PKPaymentRequest?
    
    @objc public var onPaymentAction: (() -> Void)?
    @objc public var shouldMakePayments: ((Bool) -> Void)?
    @objc public var shouldSupportPaymentNetworks: ((Bool) -> Void)?
    @objc public var willAuthorizePayment: (() -> Void)?
    @objc public var didAuthorizePayment: ((PKPayment) -> Void)?
    @objc public var didFinishPayment: (() -> Void)?
    @objc public var didSelectPaymentMethod: ((PKPaymentMethod) -> Void)?
    @objc public var didSelectShippingContact: ((PKContact) -> Void)?
    @objc public var didSelectShippingMethod: ((PKShippingMethod) -> Void)?
    
    @objc public func makeOSPaymentButton(frame: CGRect) -> PKPaymentButton {
        return makeOSPaymentButton(frame: frame, type: .buy, style: .black)
    }
    
    @objc public func makeOSPaymentButton(frame: CGRect, type: PKPaymentButtonType, style: PKPaymentButtonStyle) -> PKPaymentButton {
        let paymentButton = PKPaymentButton(paymentButtonType: type, paymentButtonStyle: style)
        paymentButton.frame = frame
        paymentButton.addTarget(self, action: #selector(paymentAction(_:)), for: .touchUpInside)
        return paymentButton
    }
    
    @objc public func makePaymentButton(frame: CGRect) -> PKPaymentButton {
        return makePaymentButton(frame: frame, image: nil)
    }
    
    @objc public func makePaymentButton(frame: CGRect, image: UIImage?) -> PKPaymentButton {
        let bgImage = image ?? UIImage(named: "ApplePay_Payment_Mark")
        let paymentButton = PKPaymentButton(frame: frame)
        paymentButton.setBackgroundImage(bgImage, for: .normal)
        paymentButton.addTarget(self, action: #selector(paymentAction(_:)), for: .touchUpInside)
        return paymentButton
    }
    
    @objc private func paymentAction(_ sender: PKPaymentButton) {
        onPaymentAction?()
    }
    
    /// Returns whether the user can make payments.
    @objc public var canMakePayments: Bool {
        return PKPaymentAuthorizationViewController.canMakePayments()
    }
    
    @objc public func makeRequest(countryCode: String,
                                  currencyCode: String,
                                  merchantIdentifier: String,
                                  paymentItems: [PKPaymentSummaryItem]) -> PKPaymentRequest?
    {
        var paymentNetworks: [PKPaymentNetwork]!
        if #available(iOS 9.2, *) {
            paymentNetworks = [
                PKPaymentNetwork.visa,
                PKPaymentNetwork.masterCard,
                PKPaymentNetwork.chinaUnionPay]  // ChinaUnionPay: iOS 9.2 +
        } else {
            paymentNetworks = [
                PKPaymentNetwork.visa,
                PKPaymentNetwork.masterCard]
        }
        return makeRequest(countryCode: countryCode, currencyCode: currencyCode, paymentNetworks: paymentNetworks, merchantIdentifier: merchantIdentifier, paymentItems: paymentItems)
    }
    
    @objc public func makeRequest(countryCode: String,
                                  currencyCode: String,
                                  paymentNetworks: [PKPaymentNetwork],
                                  merchantIdentifier: String,
                                  paymentItems: [PKPaymentSummaryItem]) -> PKPaymentRequest?
    {
        return makeRequest(countryCode: countryCode, currencyCode: currencyCode, paymentNetworks: paymentNetworks, merchantIdentifier: merchantIdentifier, merchantCapabilities: [.capability3DS, .capabilityEMV, .capabilityCredit, .capabilityDebit], paymentItems: paymentItems)
    }
    
    @objc public func makeRequest(countryCode: String,
                                  currencyCode: String,
                                  paymentNetworks: [PKPaymentNetwork],
                                  merchantIdentifier: String,
                                  merchantCapabilities: PKMerchantCapability,
                                  paymentItems: [PKPaymentSummaryItem]) -> PKPaymentRequest?
    {
        if !canMakePayments {
            CXLogger.log(level: .error, message: "The device does not support making apple payments.")
            shouldMakePayments?(false)
            return nil
        }
        shouldMakePayments?(true)
        // Determine whether this device can process payments using the specified networks and capabilities bitmask.
        if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks, capabilities: merchantCapabilities) {
            CXLogger.log(level: .error, message: "The user can not make apple payments through any of the specified networks and capabilities bitmask.")
            shouldSupportPaymentNetworks?(false)
            return nil
        }
        shouldSupportPaymentNetworks?(true)
        let request = PKPaymentRequest()
        request.countryCode = countryCode // e.g.: "CN"
        request.currencyCode = currencyCode // e.g.: "CNY"
        request.supportedNetworks = paymentNetworks
        request.merchantIdentifier = merchantIdentifier // e.g.: "merchant.xxx.xxx.xxx"
        request.merchantCapabilities = merchantCapabilities
        // let item1 = PKPaymentSummaryItem.init(label: "Coffee", amount: NSDecimalNumber(value: 29.99))
        // let item2 = PKPaymentSummaryItem.init(label: "Fee", amount: NSDecimalNumber(value: 19.99))
        request.paymentSummaryItems = paymentItems // e.g.: [item1, item2]
        currentPaymentRequest = request
        return request
    }
    
    @objc public func makePayment(_ paymentRequest: PKPaymentRequest?) {
        guard let paymentRequest_ = paymentRequest,
              let paymentAuthViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest_)
        else {
            return
        }
        paymentAuthViewController.delegate = self
        #if os(macOS)
        controller?.presentAsSheet(paymentAuthViewController)
        #else
        controller?.present(paymentAuthViewController, animated: true)
        #endif
    }
    
}

//MARK: - PKPaymentAuthorizationViewControllerDelegate

extension CXApplePayContext: PKPaymentAuthorizationViewControllerDelegate {
    
    /// The user has acted on the payment request. The application should inspect the payment to determine whether the payment request was authorized.
    @available(macOS 11.0, iOS 11.0, watchOS 4.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        didAuthorizePayment?(payment)
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        didAuthorizePayment?(payment)
        completion(.success)
    }
    
    /// When the user has selected a new payment card. Use this method callback if you need to update the summary items in response to the card type changing (for example, applying credit card surcharges)
    @available(macOS 11.0, iOS 11.0, watchOS 4.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
        didSelectPaymentMethod?(paymentMethod)
        completion(PKPaymentRequestPaymentMethodUpdate(errors: nil, paymentSummaryItems: currentPaymentRequest?.paymentSummaryItems ?? []))
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, completion: @escaping ([PKPaymentSummaryItem]) -> Void) {
        didSelectPaymentMethod?(paymentMethod)
        completion(currentPaymentRequest?.paymentSummaryItems ?? [])
    }
    
    /// When the user has selected a new shipping method. The application should determine shipping costs based on the shipping method and either the shipping address supplied in the original.
    @available(macOS 11.0, iOS 11.0, watchOS 4.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        didSelectShippingMethod?(shippingMethod)
        completion(PKPaymentRequestShippingMethodUpdate(paymentSummaryItems: currentPaymentRequest?.paymentSummaryItems ?? []))
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        didSelectShippingMethod?(shippingMethod)
        completion(.success, currentPaymentRequest?.paymentSummaryItems ?? [])
    }
    
    /// When the user has selected a new shipping address. This should inspect the address and must invoke the completion block with an updated array of PKPaymentSummaryItem objects.
    @available(macOS 11.0, iOS 11.0, watchOS 4.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Void) {
        didSelectShippingContact?(contact)
        completion(PKPaymentRequestShippingContactUpdate(errors: nil, paymentSummaryItems: currentPaymentRequest?.paymentSummaryItems ?? [], shippingMethods: currentPaymentRequest?.shippingMethods ?? []))
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        didSelectShippingContact?(contact)
        completion(.success, currentPaymentRequest?.shippingMethods ?? [], currentPaymentRequest?.paymentSummaryItems ?? [])
    }
    
    /// Before the payment is authorized, but after the user has authenticated using passcode or Touch ID. Optional.
    @available(macOS 11.0, iOS 8.3, watchOS 3.0, *)
    public func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
        willAuthorizePayment?()
    }
    
    /// The payment authorization is finished.
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        didFinishPayment?()
        currentPaymentRequest = nil
        #if os(macOS)
        self.controller.dismiss(controller)
        #else
        controller.dismiss(animated: true)
        #endif
    }
    
}

#endif
