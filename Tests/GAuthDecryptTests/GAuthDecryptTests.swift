import XCTest
@testable import GAuthDecrypt

final class GAuthDecryptTests: XCTestCase {
    
    func testParsingIncorrectHeader() {
        XCTAssertThrowsError(try GAuthDecrypt.decrypt(input: "otp://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC")) { error in
            XCTAssertEqual(error as? GAuthError, .incorrectInput)
        }
    }
    
    func testParsingIncorrectData() {
        XCTAssertThrowsError(try GAuthDecrypt.decrypt(input: "otpauth-migration://offline?data=CjEKCkhlbGxvId6t8SGEV4YW1wbGU6YWxpY2VA")) { error in
            XCTAssertEqual(error as? GAuthError, .incorrectInput)
        }
    }
    
    func testParsingCorrect() {
        XCTAssertNoThrow(try GAuthDecrypt.decrypt(input: "otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC"))
    }
    
    func testGAuthDecryptFrom() {
        let input = "otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC"
        
        XCTAssertNoThrow({
            let gauth = try GAuthDecrypt.decrypt(input: input)
            XCTAssertEqual(gauth.count, 1, "Decryption did not return expected number of accounts.")
            XCTAssertEqual(gauth.first?.name, "Example:alice@google.com", "Account name does not match expected value.")
            XCTAssertEqual(gauth.first?.issuer, "Example", "Issuer does not match expected value.")
        }, "Decryption threw an unexpected error.")
    }
    
    func testGAuthMultipleDecrypt() {
        let input = "otpauth-migration://offline?data=CiMKC5OYSRBRJMThkOSJEg5Tb21lIGNvZGUgd2l0aCABKAEwAgoZCgqHIGPETdC5oJg5EgV0ZXN0MSABKAEwAgoZCgqHIGPETdC5oJg5EgV0ZXN0MiABKAEwAhABGAEgAA%3D%3D"
        
        XCTAssertNoThrow({
            let gauth = try GAuthDecrypt.decrypt(input: input)
            XCTAssertEqual(gauth.count, 3, "Decryption did not return expected number of accounts.")
            
            XCTAssertEqual(gauth[0].name, "Some code with a", "First account name does not match.")
            XCTAssertEqual(gauth[0].issuer, "Test1", "First account issuer does not match.")
            
            XCTAssertEqual(gauth[1].name, "Some code with a", "Second account name does not match.")
            XCTAssertEqual(gauth[1].issuer, "Test2", "Second account issuer does not match.")
        }, "Decryption threw an unexpected error for multiple accounts.")
    }
    
    func testIncorrectGAuthDecryptFrom() {
        let input = "otpauth-migration://offline?data=cmFuZG9tdGV4dGhlcmVlbmNvZGVk"
        
        XCTAssertThrowsError(try GAuthDecrypt.decrypt(input: input), "Expected decryption to throw an error for invalid input.") { error in
            XCTAssertEqual(error as? GAuthError, .cannotDecrypt, "Error type does not match expected `cannotDecrypt`.")
        }
    }
}
