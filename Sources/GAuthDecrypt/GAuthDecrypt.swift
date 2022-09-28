import SwiftProtobuf
import Foundation

public enum GAuthErrorType: Error {
    case incorrectInput
    case cannotDecrypt
}
    
internal func parseInputString(input: String) -> Data? {
    if input.contains("otpauth-migration://offline?data=") {
        let parsedString = input.replacingOccurrences(of: "otpauth-migration://offline?data=", with: "")
        return Data(base64Encoded: parsedString)
    }
    return nil
}

internal func decryptParsed(data: Data) -> [GAuthOTP]? {
    guard let migrationPayload = try? MigrationPayload(serializedData: data) else {
        print("Cannot decrypt data in MigrationPayload")
        return nil
    }
    let otpParamaters = migrationPayload.otpParameters
    var decryptedAccounts = [GAuthOTP]()
    for account in otpParamaters {
        decryptedAccounts.append(GAuthOTP(typeRawInt: account.type.rawValue, algorithmRawInt: account.algorithm.rawValue, name: account.name, secret: account.secret, issuer: account.issuer, counter: account.counter, digitsRawValue: account.digits.rawValue))
    }
    guard decryptedAccounts.isEmpty == false else {
        print("Cannot decode or otpParamaters is empety")
        return nil
    }
    return decryptedAccounts
}
    

public func GAuthDecryptFrom(string input: String) -> [GAuthOTP]? { 
    guard let data = parseInputString(input: input) else {
        return nil
    }
    guard let decrypted = decryptParsed(data: data) else {
        return nil
    }
    return decrypted
}
