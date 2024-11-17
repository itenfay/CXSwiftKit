//
//  CXAssociatedKey.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/14.
//

//MARK: - CXAssociatedKey

internal struct CXAssociatedKey {
    /// The key for rotating animation of layer.
    static var isAnimationRotating = "cx.animation.isRotating"
    /// The key for the placeholder of text view.
    static var textViewPlaceholder = "cx.textView.placeholder"
    
    /// The keys for the rich text of label.
    static var labelRichTextClickEffectEnabled = "cx.label.richText.clickeffectEnabled"
    static var labelRichTextClickColor = "cx.label.richText.clickColor"
    static var labelRichTextAttributeStrings  = "cx.label.richText.attributeStrings"
    static var labelRichTextEffectDict = "cx.label.richText.effectDict"
    static var labelRichTextHasClickAction = "cx.label.richText.hasClickAction"
    static var labelRichTextClickAction = "cx.label.richText.clickAction"
    
    /// The key for saving image to photos album.
    static var imageSavedToPhotosAlbum = "cx.imageSavedTo.photosalbum"
    
    /// The key for presenting overlay direction.
    static var presentOverlayDirection = "cx.present.overlayDirection"
    static var presentOverlayMask = "cx.present.overlayMask"
    static var dismissOverlayAction = "cx.dismiss.overlayAction"
    static var overlayIsFromCenter = "cx.present.isFromCenter"
}
