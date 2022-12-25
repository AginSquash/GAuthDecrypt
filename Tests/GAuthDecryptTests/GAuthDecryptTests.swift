import XCTest
@testable import GAuthDecrypt

final class GAuthDecryptTests: XCTestCase {
    
    func testParsingIncorrectHeader() throws {
        XCTAssert((parseInputString(input: "otp://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC") == nil))
    }
    
    func testParsingIncorrectData() throws {
        XCTAssert((parseInputString(input: "otpauth-migration://offline?data=CjEKCkhlbGxvId6t8SGEV4YW1wbGU6YWxpY2VA") == nil))
    }
    
    func testParsingCorrect() throws {
        XCTAssert((parseInputString(input: "otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC") != nil))
    }
    
    func testGAuthDecryptFrom() throws {
        let gauth = GAuthDecryptFrom(string: "otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC")
        XCTAssert(gauth?.first?.name == "Example:alice@google.com")
    }

    func testGAuthMultipleDecrypt() throws {
        let gauth = GAuthDecryptFrom(string: "otpauth-migration://offline?data=CiMKC5OYSRBRJMThkOSJEg5Tb21lIGNvZGUgd2l0aCABKAEwAgoZCgqHIGPETdC5oJg5EgV0ZXN0MSABKAEwAgoZCgqHIGPETdC5oJg5EgV0ZXN0MiABKAEwAhABGAEgAA%3D%3D")
        if (gauth == nil) {
            XCTFail("Cannot decrypt from multiple import")
            return
        }
        XCTAssert(gauth!.count == 3)
    }
    
    func testIncorrectGAuthDecryptFrom() throws {
        let gauth = GAuthDecryptFrom(string: "otpauth-migration://offline?data=CjEKCkhlbdsdGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC")
        XCTAssert(gauth == nil)
    }
}
