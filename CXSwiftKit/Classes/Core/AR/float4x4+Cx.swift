//
//  float4x4+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if canImport(simd) && canImport(GLKit)
import simd
import GLKit

extension float4x4 {
    
    public init() {
        self = unsafeBitCast(GLKMatrix4Identity, to: float4x4.self)
    }
    
    public static func cx_makeScale(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeScale(x, y, z), to: float4x4.self)
    }
    
    public static func cx_makeRotate(_ radians: Float, _ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeRotation(radians, x, y, z), to: float4x4.self)
    }
    
    public static func cx_makeTranslation(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeTranslation(x, y, z), to: float4x4.self)
    }
    
    public static func cx_makePerspectiveViewAngle(_ fovyRadians: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> float4x4 {
        var q = unsafeBitCast(GLKMatrix4MakePerspective(fovyRadians, aspectRatio, nearZ, farZ), to: float4x4.self)
        let zs = farZ / (nearZ - farZ)
        q[2][2] = zs
        q[3][2] = zs * nearZ
        return q
    }
    
    public static func cx_makeFrustum(_ left: Float, _ right: Float, _ bottom: Float, _ top: Float, _ nearZ: Float, _ farZ: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeFrustum(left, right, bottom, top, nearZ, farZ), to: float4x4.self)
    }
    
    public static func cx_makeOrtho(_ left: Float, _ right: Float, _ bottom: Float, _ top: Float, _ nearZ: Float, _ farZ: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeOrtho(left, right, bottom, top, nearZ, farZ), to: float4x4.self)
    }
    
    public static func cx_makeLookAt(_ eyeX: Float, _ eyeY: Float, _ eyeZ: Float, _ centerX: Float, _ centerY: Float, _ centerZ: Float, _ upX: Float, _ upY: Float, _ upZ: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ), to: float4x4.self)
    }
    
    public mutating func cx_scale(_ x: Float, _ y: Float, _ z: Float) {
        self = self * float4x4.cx_makeScale(x, y, z)
    }
    
    public mutating func cx_rotate(_ radians: Float, x: Float, y: Float, z: Float) {
        self = float4x4.cx_makeRotate(radians, x, y, z) * self
    }
    
    public mutating func cx_rotateAroundX(_ x: Float, _ y: Float, _ z: Float) {
        var rotationM = float4x4.cx_makeRotate(x, 1, 0, 0)
        rotationM = rotationM * float4x4.cx_makeRotate(y, 0, 1, 0)
        rotationM = rotationM * float4x4.cx_makeRotate(z, 0, 0, 1)
        self = self * rotationM
    }
    
    public mutating func cx_translate(_ x: Float, y: Float, z: Float) {
        self = self * float4x4.cx_makeTranslation(x, y, z)
    }
    
    public static func cx_numberOfElements() -> Int {
        return 16
    }
    
    public static func cx_degrees(toRad angle: Float) -> Float {
        return Float(Double(angle) * Double.pi / 180)
    }
    
    public mutating func cx_multiplyLeft(_ matrix: float4x4) {
        let glMatrix1 = unsafeBitCast(matrix, to: GLKMatrix4.self)
        let glMatrix2 = unsafeBitCast(self, to: GLKMatrix4.self)
        let result = GLKMatrix4Multiply(glMatrix1, glMatrix2)
        self = unsafeBitCast(result, to: float4x4.self)
    }
    
    public var cx_translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
    
}

#endif
