//
//  CXResponseResult.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

import Foundation

/// Error Enum
///
/// - deserializeFailed: Parsing Error
/// - requestFailed: Request Error
public enum CXResponseError: Error {
    case deserializeFailed
    case requestFailed(Error)
    case innerError(String)
}

/// Response Result
///
/// - success: Success Return Data
/// - failure: Failure<Error Enum>
public enum CXResponseResult<Value> {
    case success(Value)
    case failure(CXResponseError)
    
    /// The success of Request
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: CXResponseError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
}
