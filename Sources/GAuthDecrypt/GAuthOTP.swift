//
//  OTPStruct.swift
//  
//
//  Created by Vlad Vrublevsky on 14.09.2022.
//

import Foundation
import SwiftProtobuf

public struct GAuthOTP: Hashable, Codable {
    enum OTP_Type: Int, Codable {
        case unspecified //= 0
        case hotp //= 1
        case totp //= 2
    }
    
    enum Algorithm_Type: Int, Codable {
    case unspecified
    case sha1
    case sha256
    case sha512
    case md5
    }
    
    let type: OTP_Type
    let algorithm: Algorithm_Type
    let name: String
    let secret: Data
    let issuer: String
    let counter: Int64
    let digitsRawValue: Int
    
    init(typeRawInt: Int, algorithmRawInt: Int, name: String, secret: Data, issuer: String, counter: Int64, digitsRawValue: Int) {
        self.type = OTP_Type(rawValue: typeRawInt) ?? .unspecified
        self.algorithm = Algorithm_Type(rawValue: algorithmRawInt) ?? .unspecified
        self.name = name
        self.secret = secret
        self.issuer = issuer
        self.counter = counter
        self.digitsRawValue = digitsRawValue
    }
}
