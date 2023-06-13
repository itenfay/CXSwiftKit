//
//  SCNSceneRenderer+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if os(iOS) || os(macOS)
import SceneKit
import Metal
import CoreAudio

@available(iOS 11.0, *)
extension SCNSceneRenderer {
    
    /// Gets the pixel buffer stores an image in main memory.
    public var cx_cvPixelBuffer: CVPixelBuffer? {
        if self.currentRenderPassDescriptor.colorAttachments[0].texture == nil {
            return nil
        }
        let t = self.currentRenderPassDescriptor.colorAttachments[0].texture!
        var outPixelbuffer: Unmanaged<CVPixelBuffer>?
        if t.iosurface == nil {
            return nil
        }
        CVPixelBufferCreateWithIOSurface(kCFAllocatorDefault, t.iosurface!, nil, &outPixelbuffer)
        let buffer = outPixelbuffer?.takeRetainedValue()
        return buffer
    }
    
    /// Creates an image by drawing the renderer’s content at the current time.
    ///
    /// var renderer: SCNSceneRenderer
    /// Needs to set renderer.delegate = `target`
    public func cx_snapshot(for scnView: SCNView) -> CXImage {
        #if os(macOS)
        return cx_snapshot(for: scnView, size: scnView.bounds.size)
        #else
        return cx_snapshot(for: scnView, size: UIScreen.main.bounds.size)
        #endif
    }
    
    /// Creates an image by drawing the renderer’s content at the current time and specified size.
    ///
    /// var renderer: SCNSceneRenderer
    /// Needs to set renderer.delegate = `target`
    public func cx_snapshot(for scnView: SCNView, size: CGSize) -> CXImage {
        let renderer = SCNRenderer(device: scnView.device, options: nil)
        renderer.scene = scnView.scene
        let image = renderer.snapshot(atTime: CACurrentMediaTime(), with: size, antialiasingMode: .multisampling4X)
        return image
    }
    
}

#endif
