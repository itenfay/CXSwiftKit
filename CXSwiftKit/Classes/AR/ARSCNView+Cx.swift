//
//  ARSCNView+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if canImport(ARKit) && canImport(SceneKit)
import ARKit
import SceneKit

@available(iOS 11.0, *)
extension ARSCNView {
    
    /// Removes its child nodes.
    @objc public func removeAllNodes() {
        scene.rootNode.childNodes.forEach { node in
            if node.hasActions {
                node.removeAllActions()
            }
            node.removeFromParentNode()
        }
    }
    
    /// Returns a pixel buffer containing the image captured by the camera.
    @objc public var capturedImage: CVPixelBuffer? {
        return session.currentFrame?.capturedImage
    }
    
    /// Adds a node to the node’s array of children.
    @objc public func add(node: SCNNode) {
        scene.rootNode.addChildNode(node)
    }
    
    /// Removes the node from the node’s array of children.
    @objc public func remove(node: SCNNode) {
        scene.rootNode.childNodes.forEach {
            if $0 == node {
                if $0.hasActions {
                    $0.removeAllActions()
                }
                $0.removeFromParentNode()
                return
            }
        }
    }
    
    /// Starts AR processing for the session with the specified configuration.
    @objc public func startSession(with config: ARConfiguration) {
        startSession(with: config, options: [])
    }
    
    /// Starts AR processing for the session with the specified configuration and options.
    @objc public func startSession(with config: ARConfiguration, options: ARSession.RunOptions) {
        session.run(config, options: options)
    }
    
    /// Pauses processing in the session.
    @objc public func pauseSession() {
        session.pause()
    }
    
    /// Adds the specified anchor.
    @objc public func add(anchor: ARAnchor) {
        session.add(anchor: anchor)
    }
    
    /// Removes the specified anchor.
    @objc public func remove(anchor: ARAnchor) {
        session.remove(anchor: anchor)
    }
    
}

#endif
