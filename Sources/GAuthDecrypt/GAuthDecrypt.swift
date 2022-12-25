import SwiftProtobuf
import Foundation

public enum GAuthErrorType: Error {
    case incorrectInput
    case cannotDecrypt
}
    
internal func parseInputString(input: String) -> Data? {
    if input.contains("otpauth-migration://") {
        guard let urlFromInput = URL(string: input) else { return nil }
        var dict = [String:String]()
        let components = URLComponents(url: urlFromInput, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                dict[item.name] = item.value!
            }
        }
        let data_parsed = dict.first!.value
        let data_fixed = data_parsed.replacingOccurrences(of: " ", with: "+") // а зочем?
        let data_b64 = Data(base64Encoded: data_fixed)
        
        return data_b64
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
        decryptedAccounts.append(GAuthOTP(typeRawInt: account.type.rawValue, algorithmRawInt: account.algorithm.rawValue, name: account.name, secret: account.secret, issuer: account.issuer, counter: account.counter, digitsRawValue: Int(account.digits)))
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
