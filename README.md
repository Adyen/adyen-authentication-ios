# AdyenAuthentication iOS SDK

Adyen passwordless Authentication SDK.

## Installation

The SDK is available via [CocoaPods](http://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage), [Swift Package Manager](https://www.swift.org/package-manager/) or via manual installation.

### CocoaPods

1. Add `pod 'AdyenAuthentication'` to your `Podfile`.
2. Run `pod install`.

### Carthage

1. Add `github "adyen/adyen-authentication-ios"` to your `Cartfile`.
2. Run `carthage update`.
3. Link the framework with your target as described in [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### Dynamic Framework

Drag the dynamic `AdyenAuthentication.xcframework` to the `Embedded Binaries` section in your general target settings. Select "Copy items if needed" when asked.

### Static Framework

1. In Xcode, select "File" and then "Add Files to...".
2. Select the static `AdyenAuthentication.framework` and check "Copy items if needed", then select "Add".

### Swift Package Manager

1. Follow Apple's [Adding Package Dependencies to Your App](
https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app
) guide on how to add a Swift Package dependency.
2. Use `https://github.com/Adyen/adyen-authentication-ios` as the repository URL.
3. Specify the version to be at least `1.0.0`.

## Usage

### Initialization

```Swift
let configuration = AuthenticationService.Configuration(localizedRegistrationReason: // Text explaining to the user why we need their biometrics while registration,
                                                        localizedAuthenticationReason: // Text explaining to the user why we need their biometrics while authentication.
                                                        appleTeamIdendtifier: // The Apple registered development team identifier.)
self.authenticationService = try? AuthenticationService(configuration: configuration)
```

### For first time registration:

```Swift
let input = RegistrationInput(serverChallenge: /// Server Challenge)
authenticationService.register(withInput: input) { [weak self] result in
    switch result {
    case let .success(output):
        /// output is a `RegistrationOutput`, the `RegistrationOutput.attestationObject` should be sent to a FIDO compliant backend to be validated.
    case let .failure(error):
        /// Error raised, for example if the device is not protected by either pass code, face Id, or fingerprint.
    }
}
```
You can also use the async version of this function:

```Swift
do {
    let input = RegistrationInput(serverChallenge: /// Server Challenge)
    async let output = try await authenticationService.register(with: input)
    /// output is a `RegistrationOutput`, the `RegistrationOutput.attestationObject` should be sent to a FIDO compliant backend to be validated.
} catch {
    /// Error raised, for example if the device is not protected by either pass code, face Id, or fingerprint.
}
```

### For authentication:

```Swift
let input = AuthenticationInput(candidateCredentialIdentifiers: /// credentials list obtained from a FIDO compliant backend tied to the current account/device,
                                serverChallenge: /// Server challenge in the form of opaque binary data)
authenticationService.authenticate(withInput: input) { result in
    switch result {
    case let .success(output):
        /// Authentication went through, then the `AuthenticationOutput.assertionObject` and `AuthenticationOutput.resolvedCredentialIdentifier` should be sent back to a `FIDO` compliant server to validate them both.
    case let .failure(error):
        /// Failure to authenticate, which usually means that the current account is not registered (i.e non of the store credentials match the `AuthenticationInput.candidateCredentialIdentifiers`).
    }
}
```

You can also use the async version of this function:

```Swift
do {
    let input = AuthenticationInput(candidateCredentialIdentifiers: /// credentials list obtained from a FIDO compliant backend tied to the current account/device,
                                serverChallenge: /// Server challenge in the form of opaque binary data)
    async let output = try await authenticationService.authenticate(with: input)
    /// Authentication went through, then the `AuthenticationOutput.assertionObject` and `AuthenticationOutput.resolvedCredentialIdentifier` should be sent back to a `FIDO` compliant server to validate them both.
} catch {
    /// Failure to authenticate, which usually means that the current account is not registered (i.e non of the store credentials match the `AuthenticationInput.candidateCredentialIdentifiers`).
}
```

## See also

 * [Reporting security issues](https://www.adyen.help/hc/en-us/articles/115001187330-How-do-I-report-a-possible-security-issue-to-Adyen-).
 * [Security best practices](https://docs.adyen.com/online-payments/classic-integrations/api-integration-ecommerce/3d-secure/native-3ds2/ios-sdk-integration/security-best-practices).
 * [Data security at Adyen](https://docs.adyen.com/development-resources/adyen-data-security).

## License

This SDK is available under the Apache License, Version 2.0. For more information, see the [LICENSE](https://github.com/Adyen/adyen-3ds2-ios/blob/master/LICENSE) file.
