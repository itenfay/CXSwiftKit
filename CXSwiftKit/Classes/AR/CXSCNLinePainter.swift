//
//  CXSCNLinePainter.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if canImport(ARKit) && canImport(SCNLine)
import ARKit
import SCNLine

public class SCNLinePainter: NSObject {
    
    private weak var sceneView: ARSCNView?
    
    /// Used for calculating where to draw using hitTesting
    private var cameraFrameNode: SCNNode!
    
    @objc public init(sceneView: ARSCNView) {
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = false
        // Set the view's delegate
        //sceneView.delegate = self
        #if DEBUG
        ceneView.showsStatistics = true
        #endif
        sceneView.autoenablesDefaultLighting = true
        self.sceneView = sceneView
        self.cameraFrameNode = SCNNode(geometry: SCNFloor())
        self.cameraFrameNode.isHidden = true
        self.sceneView?.pointOfView?.addChildNode(self.cameraFrameNode)
        self.cameraFrameNode.position.z = -0.5
        self.cameraFrameNode.eulerAngles.x = -.pi / 2
    }
    
    @objc public convenience init(sceneView: ARSCNView, radius: CGFloat, color: UIColor) {
        self.init(sceneView: sceneView)
        self.radius = radius
        self.color = color
    }
    
    private var drawingNode: SCNLineNode?
    
    private var centerVerticesCount: Int32 = 0
    private var hitVertices: [SCNVector3] = []
    
    private var lastPoint = SCNVector3Zero
    private var minimumMovement: Float = 0.005
    
    @objc public var pointTouching: CGPoint = .zero
    @objc public var isDrawing: Bool = false
    
    /// Get a random color.
    @objc public var randomColor: UIColor {
        return UIColor(displayP3Red: CGFloat.random(in: 0...1),
                       green: CGFloat.random(in: 0...1),
                       blue: CGFloat.random(in: 0...1),
                       alpha: 1)
    }
    
    @objc public var color: UIColor?
    @objc public var radius: CGFloat = 0.01
    
    deinit {
        reset()
        cameraFrameNode.removeFromParentNode()
    }
    
}

extension SCNLinePainter {
    
    @objc public func startDrawing(with touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        pointTouching = location
        begin()
        isDrawing = true
    }
    
    @objc public func drawing(with touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        pointTouching = location
    }
    
    @objc public func endDrawing(with touches: Set<UITouch>) {
        isDrawing = false
        reset()
    }
    
    @objc public func rendererUpdade(_ renderer: SCNSceneRenderer, atTime time: TimeInterval) {
        if isDrawing {
            addPointAndCreateVertices()
        }
    }
    
    private func begin() {
        drawingNode = SCNLineNode(with: [], radius: Float(radius), edges: 12, maxTurning: 12)
        // Creating a specified colored material.
        let material = SCNMaterial()
        material.diffuse.contents = color ?? randomColor
        material.isDoubleSided = true
        drawingNode?.lineMaterials = [material]
        sceneView?.scene.rootNode.addChildNode(drawingNode!)
    }
    
    @objc public func addPointAndCreateVertices() {
        guard let lastHit = self.sceneView?.hitTest(self.pointTouching, options: [
            SCNHitTestOption.rootNode: cameraFrameNode!, SCNHitTestOption.ignoreHiddenNodes: false
        ]).first else {
            return
        }
        if lastHit.worldCoordinates.cx_distance(vector: lastPoint) > minimumMovement {
            hitVertices.append(lastHit.worldCoordinates)
            lastPoint = lastHit.worldCoordinates
            updateGeometry(with: lastPoint)
        }
    }
    
    private func updateGeometry(with point: SCNVector3) {
        guard hitVertices.count > 1, let drawNode = drawingNode else {
            return
        }
        drawNode.add(point: point)
    }
    
    private func reset() {
        hitVertices.removeAll()
        drawingNode = nil
    }
    
}

#endif
