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
    
    func testGAuthDecryptSingleAccount() {
        let input = "otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC"
        
        do {
            let gauth = try GAuthDecrypt.decrypt(input: input)
            XCTAssertEqual(gauth.count, 1, "Expected exactly one account to be decrypted")
            XCTAssertEqual(gauth.first?.name, "Example:alice@google.com", "Decrypted account name does not match")
        } catch {
            XCTFail("Decryption failed with error: \(error)")
        }
    }
    
    func testGAuthMultipleDecrypt() {
        let input = "otpauth-migration://offline?data=CiMKC5OYSRBRJMThkOSJEg5Tb21lIGNvZGUgd2l0aCABKAEwAgoZCgqHIGPETdC5oJg5EgV0ZXN0MSABKAEwAgoZCgqHIGPETdC5oJg5EgV0ZXN0MiABKAEwAhABGAEgAA%3D%3D"
        
        do {
            let gauth = try GAuthDecrypt.decrypt(input: input)
            XCTAssertEqual(gauth.count, 3, "Expected three accounts to be decrypted")
            
            let names = gauth.map { $0.name }
    
            XCTAssertTrue(names.contains("Some code with"), "Decrypted accounts should contain 'Some code with'")
            XCTAssertTrue(names.contains("test1"), "Decrypted accounts should contain 'test1'")
            XCTAssertTrue(names.contains("test2"), "Decrypted accounts should contain 'test2'")
        } catch {
            XCTFail("Decryption failed with error: \(error)")
        }
    }
    
    func testIncorrectGAuthDecrypt() {
        let input = "otpauth-migration://offline?data=cmFuZG9tdGV4dGhlcmVlbmNvZGVk"
        
        XCTAssertThrowsError(try GAuthDecrypt.decrypt(input: input)) { error in
            XCTAssertEqual(error as? GAuthError, .cannotDecrypt, "Expected .cannotDecrypt error type")
        }
    }
}
