//
//  CXSCNTextPainter.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if canImport(ARKit) && canImport(SceneKit)
import ARKit
import SceneKit

@available(iOS 11.0, *)
public class SCNTextPainter: NSObject {
    
    @objc public var textColor: UIColor = .orange
    @objc public var materialColor: UIColor = .cyan
    @objc public var depth: Float = 0.01
    @objc public var font: UIFont? = UIFont(name: "Futura", size: 0.15)
    
    private weak var sceneView: ARSCNView?
    
    @objc public init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    @objc public func draw(text: String, position: CGPoint) {
        // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        guard let arHitTestResults : [ARHitTestResult] = sceneView?.hitTest(position, types: [.featurePoint])
        else {
            return
        }
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform: matrix_float4x4 = closestResult.worldTransform
            let worldCoord: SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            // Create 3D Text
            let node: SCNNode = createBubbleParentNode(text)
            sceneView?.add(node: node)
            node.position = worldCoord
        }
    }
    
    private func createBubbleParentNode(_ s: String) -> SCNNode {
        // Warning: Creating 3D Text is susceptible to crashing.
        // To reduce chances of crashing; reduce number of polygons, letters, smoothness, etc.
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // BUBBLE-TEXT
        let bubble = SCNText(string: s, extrusionDepth: CGFloat(depth))
        bubble.font = font?.cx.withTraits(.traitBold)
        bubble.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        bubble.firstMaterial?.diffuse.contents = textColor
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness, setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(depth)
        
        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation((maxBound.x - minBound.x)/2, minBound.y, depth/2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = materialColor
        let sphereNode = SCNNode(geometry: sphere)
        
        // BUBBLE PARENT NODE
        let bubbleNodeParent = SCNNode()
        bubbleNodeParent.addChildNode(bubbleNode)
        bubbleNodeParent.addChildNode(sphereNode)
        bubbleNodeParent.constraints = [billboardConstraint]
        
        return bubbleNodeParent
    }
    
    @objc public func createTextNode(_ s: String) -> SCNNode {
        // TEXT
        let text = SCNText(string: s, extrusionDepth: CGFloat(depth))
        text.font = font
        text.firstMaterial?.diffuse.wrapT = .clamp
        text.firstMaterial?.diffuse.contents = textColor
        text.chamferRadius = CGFloat(depth)
        
        // TEXT NODE
        let (minBound, maxBound) = text.boundingBox
        let textNode = SCNNode(geometry: text)
        // Centre Node - to Centre-Bottom point
        textNode.pivot = SCNMatrix4MakeTranslation((maxBound.x - minBound.x)/2, minBound.y, depth/2)
        // Reduce default text size
        textNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = materialColor
        let sphereNode = SCNNode(geometry: sphere)
        
        // TEXT PARENT NODE
        let textParentNode = SCNNode()
        textParentNode.addChildNode(textNode)
        textParentNode.addChildNode(sphereNode)
        
        return textParentNode
    }
    
}

#endif
