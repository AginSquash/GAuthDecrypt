import SwiftProtobuf
import Foundation

class GAuthDecrypt {
    
    private static func parseInputString(input: String) throws -> Data {
        guard input.starts(with: "otpauth-migration://"),
              let url = URL(string: input),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            throw GAuthError.incorrectInput
        }
        
        guard let encodedData = queryItems.first?.value?
                .replacingOccurrences(of: " ", with: "+"),
              let decodedData = Data(base64Encoded: encodedData) else {
            throw GAuthError.incorrectInput
        }
        
        return decodedData
    }
    
    private static func decryptParsed(data: Data) throws -> [GAuthOTP] {
        do {
            let migrationPayload = try MigrationPayload(serializedData: data)
            return migrationPayload.otpParameters.map {
                GAuthOTP(
                    typeRawInt: $0.type.rawValue,
                    algorithmRawInt: $0.algorithm.rawValue,
                    name: $0.name,
                    secret: $0.secret,
                    issuer: $0.issuer,
                    counter: $0.counter,
                    digitsRawValue: Int($0.digits)
                )
            }
        } catch {
            print("GAuthDecrypt error: Cannot decrypt data in MigrationPayload")
            throw GAuthError.cannotDecrypt
        }
    }
        
    public static func decrypt(input: String) throws -> [GAuthOTP] {
        let data = try parseInputString(input: input)
        return try decryptParsed(data: data)
    }
}
