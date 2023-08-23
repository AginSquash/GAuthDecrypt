# GAuthDecrypt
[![Latest Release](https://img.shields.io/github/v/release/aginsquash/GAuthDecrypt)](https://github.com/AginSquash/GAuthDecrypt/releases)
![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Platform](https://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos-lightgrey)](http://cocoapods.org/pods/SwiftOTP)

GAuthDecrypt is Swift library for extraction two-factor authentication secret keys from export QR codes of Google Authenticator app. At the input is a string read from a qr code, at the output is an array of objects of the GAuthOTP type. 
I used it on my 2FA app check it [Open2FA](https://github.com/AginSquash/open2fa/)

## Installation
You can use Swift Package Manager and specify dependency in `Package.swift` by adding this:

```swift
dependencies: [
    .package(url: "https://github.com/AginSquash/GAuthDecrypt.git", .upToNextMinor(from: "2.0.0"))
]
```

Or click File -> Add Packages. In search form enter `https://github.com/AginSquash/GAuthDecrypt.git` and click "Copy Dependency" button.

## Usage
```swift
let stringFromGoogleAuthApp = "otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC"
let decrypted = GAuthDecryptFrom(input: stringFromGoogleAuthApp) // decrypted type is Optional<[GAuthOTP]>
print(decrypted![0]) 
/*
    type: .totp, 
    algorithm: .unspecified, 
    name: "Example:alice@google.com", 
    secret: "JBSWY3DPEHPK3PXP", 
    issuer: "Example", 
    counter: 0, 
    digitsRawValue: 0) 
*/
```
## Dependencies
All dependencies in this project are added through SPM. Links to them:
- https://github.com/apple/swift-protobuf
- https://github.com/norio-nomura/Base32

## License

Copyright (C) 2023 Vladislav Vrublevsky <agins.main@gmail.com>

This software is provided 'as-is', without any express or implied warranty.

In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

- The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
- Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
- This notice may not be removed or altered from any source or binary distribution.
- Redistributions of any form whatsoever must retain the following acknowledgment: 'This product includes software developed by the "Vladislav Vrublevsky" (AginSquash).'