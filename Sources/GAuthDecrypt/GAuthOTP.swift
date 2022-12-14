//
//  OTPStruct.swift
//  
//
//  Created by Vlad Vrublevsky on 14.09.2022.
//

import Foundation
import SwiftProtobuf
import Base32

public struct GAuthOTP: Hashable, Codable {
    public enum OTP_Type: Int, Codable {
        case unspecified //= 0
        case hotp //= 1
        case totp //= 2
    }
    
    public enum Algorithm_Type: Int, Codable {
        case unspecified
        case sha1
        case sha256
        case sha512
        case md5
    }
    
    public let type: OTP_Type
    public let algorithm: Algorithm_Type
    public let name: String
    public let secret: String
    public let issuer: String
    public let counter: Int64
    public let digitsRawValue: Int
    
    init(typeRawInt: Int, algorithmRawInt: Int, name: String, secret: Data, issuer: String, counter: Int64, digitsRawValue: Int) {
        self.type = OTP_Type(rawValue: typeRawInt) ?? .unspecified
        self.algorithm = Algorithm_Type(rawValue: algorithmRawInt) ?? .unspecified
        self.name = name
        self.secret = base32Encode(secret)
        self.issuer = issuer
        self.counter = counter
        self.digitsRawValue = digitsRawValue
    }
}
