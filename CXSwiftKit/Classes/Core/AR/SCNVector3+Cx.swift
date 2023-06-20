//
//  SCNVector3+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

#if canImport(SceneKit)
import SceneKit

// macOS uses CGFloats for describing SCNVector3.
// In order to shae the same code, this typealias allows for conversion between Floats and CGFloats when needed
#if os(macOS)
public typealias SCNFloat = CGFloat
#else
public typealias SCNFloat = Float
#endif

public extension SCNVector3 {
    
    // Universal type for macOS and iOS allowing simultaneous compatiblity when doing operations.
    // (Remember x, y and z are CGFloats on macOS)
    var cx_fx: SCNFloat { SCNFloat(x) }
    var cx_fy: SCNFloat { SCNFloat(y) }
    var cx_fz: SCNFloat { SCNFloat(z) }
    
    /**
     * Negates the vector described by SCNVector3 and returns
     * the result as a new SCNVector3.
     */
    func cx_negate() -> SCNVector3 {
        return self * -1
    }
    
    /**
     * Negates the vector described by SCNVector3
     */
    mutating func cx_negated() -> SCNVector3 {
        self = cx_negate()
        return self
    }
    
    /**
     * Returns the length (magnitude) of the vector described by the SCNVector3
     */
    var cx_length: SCNFloat {
        let sqr = sqrtf(Float(self.cx_lenSq))
        return SCNFloat(sqr)
    }
    
    func cx_angleChange(to: SCNVector3) -> SCNFloat {
        let dot = self.cx_normalized().cx_dot(vector: to.cx_normalized())
        let acos = acos(dot / sqrt(self.cx_lenSq * to.cx_lenSq))
        return SCNFloat(acos)
    }
    
    /**
     * Returns the squared length (magnitude) of the vector described by the SCNVector3
     */
    var cx_lenSq: SCNFloat {
        return cx_fx*cx_fx + cx_fy*cx_fy + cx_fz*cx_fz
    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0 and returns
     * the result as a new SCNVector3.
     */
    func cx_normalized() -> SCNVector3 {
        return self / self.cx_length
    }
    
    /**
     * Calculates the distance between two SCNVector3. Pythagoras!
     */
    func cx_distance(vector: SCNVector3) -> SCNFloat {
        return (self - vector).cx_length
    }
    
    /**
     * Calculates the dot product between two SCNVector3.
     */
    func cx_dot(vector: SCNVector3) -> SCNFloat {
        return cx_fx * vector.cx_fx + cx_fy * vector.cx_fy + cx_fz * vector.cx_fz
    }
    
    /**
     * Calculates the cross product between two SCNVector3.
     */
    func cx_cross(vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(
            y * vector.z - z * vector.y,
            z * vector.x - x * vector.z,
            x * vector.y - y * vector.x
        )
    }
    
    func cx_flattened() -> SCNVector3 {
        return SCNVector3(self.x, 0, self.z)
    }
    
    /// Given a point and origin, rotate along X/Z plane by radian amount
    ///
    /// - parameter origin: Origin for the start point to be rotated about
    /// - parameter by: Value in radians for the point to be rotated by
    ///
    /// - returns: New SCNVector3 that has the rotation applied
    func cx_rotate(about origin: SCNVector3, by: SCNFloat) -> SCNVector3 {
        let pointRepositionedXY = [self.cx_fx - origin.cx_fx, self.cx_fz - origin.cx_fz]
        let sinAngle = sin(by)
        let cosAngle = cos(by)
        return SCNVector3(
            x: SCNFloat(pointRepositionedXY[0] * cosAngle - pointRepositionedXY[1] * sinAngle + origin.cx_fx),
            y: self.y,
            z: SCNFloat(pointRepositionedXY[0] * sinAngle + pointRepositionedXY[1] * cosAngle + origin.cx_fz)
        )
    }
    
}

public extension SCNVector3 {
    
    /**
     * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
     */
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    /**
     * Increments a SCNVector3 with the value of another.
     */
    static func += (left: inout SCNVector3, right: SCNVector3) {
        left = left + right
    }
    
    /**
     * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
     */
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    /**
     * Decrements a SCNVector3 with the value of another.
     */
    static func -= (left: inout  SCNVector3, right: SCNVector3) {
        left = left - right
    }
    
    /**
     * Multiplies the x, y and z fields of a SCNVector3 with the same scalar value and
     * returns the result as a new SCNVector3.
     */
    static func * (vector: SCNVector3, scalar: SCNFloat) -> SCNVector3 {
        return SCNVector3Make(SCNFloat(vector.cx_fx * scalar), SCNFloat(vector.cx_fy * scalar), SCNFloat(vector.cx_fz * scalar))
    }
    
    /**
     * Multiplies the x and y fields of a SCNVector3 with the same scalar value.
     */
    static func *= (vector: inout SCNVector3, scalar: SCNFloat) {
        vector = (vector * scalar)
    }
    
    /**
     * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
     */
    static func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
    }
    
    /**
     * Divides a SCNVector3 by another.
     */
    static func /= (left: inout  SCNVector3, right: SCNVector3) {
        left = left / right
    }
    
    /**
     * Divides the x, y and z fields of a SCNVector3 by the same scalar value and
     * returns the result as a new SCNVector3.
     */
    static func / (vector: SCNVector3, scalar: SCNFloat) -> SCNVector3 {
        return SCNVector3Make(SCNFloat(vector.cx_fx / scalar), SCNFloat(vector.cx_fy / scalar), SCNFloat(vector.cx_fz / scalar))
    }
    
    /**
     * Divides the x, y and z of a SCNVector3 by the same scalar value.
     */
    static func /= (vector: inout  SCNVector3, scalar: SCNFloat) {
        vector = vector / scalar
    }
    
}

internal func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

#endif
