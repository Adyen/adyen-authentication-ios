# AdyenAuthentication iOS SDK

AdyenAuthentication SDK Provides reusable and easy to use two factor authentication for security sensitive use cases like banking, issuing and PSD2 strong customer authentication.

## Installation

The SDK is available via [CocoaPods](http://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage), [Swift Package Manager](https://www.swift.org/package-manager/) or via manual installation.

### CocoaPods

1. Add `pod 'AdyenAuthentication'` to your `Podfile`.
2. Run `pod install`.

### Carthage

1. Add `github "adyen/adyen-authentication-ios"` to your `Cartfile`.
2. Run `carthage update`.
3. Link the framework with your target as described in [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### Dynamic xcFramework

Drag the dynamic `XCFramework/Dynamic/AdyenAuthentication.xcframework` to the `Frameworks, Libraries, and Embedded Content` section in your general target settings. Select "Copy items if needed" when asked.

### Static xcFramework

1. Drag the static `XCFramework/Static/AdyenAuthentication.xcframework` to the `Frameworks, Libraries, and Embedded Content` section in your general target settings.
2. Make sure the static `AdyenAuthentication.xcframework` is not embedded.

### Swift Package Manager

1. Follow Apple's [Adding Package Dependencies to Your App](
https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app
) guide on how to add a Swift Package dependency.
2. Use `https://github.com/Adyen/adyen-authentication-ios` as the repository URL.
3. Specify the version to be at least `1.0.0`.

## Usage

### Initialization

There are two configuration options. 

1. Using device check apis

```Swift
let configuration = AuthenticationService.Configuration(localizedRegistrationReason: // Text explaining to the user why we need their biometrics while registration,
                                                        localizedAuthenticationReason: // Text explaining to the user why we need their biometrics while authentication.
                                                        appleTeamIdentifier: // The Apple registered development team identifier.)
self.authenticationService =  AuthenticationService(configuration: configuration)
```

2. Using Apple passkeys

```Swift
let configuration = AuthenticationService.PassKeyConfiguration(
                    relyingPartyIdentifier: "com.example.com",
                    displayName: "App name",
                    consecutiveApprovalCancellationsLimit: Int?
                )
self.authenticationService = AuthenticationService(configuration: configuration)
```


### Check Device support

```Swift
let deviceSupport: String = try authenticationService.checkSupport()
```

This call will throw an error in case the current device is not supported, otherwise returns an opaque string payload that needs to be sent to backend API depending on the use case.

### Check whether Device is registered

```Swift
authenticationService.isDeviceRegistered(withAuthenticationInput: input /*The opaque string sdk input*/) { [weak self] result in
    switch result {
    case let .success(isRegistered):
        /// output is a Boolean indicating whether the current device is registered,
        /// then you can call `authenticate` function below.
    case let .failure(error):
        /// Error raised,
        /// for example if the device is not protected by either pass code, face Id, or fingerprint, or if device is not registered,
        /// then you can call `register` function below.
    }
}

// OR you can also use the async version of this function:

let isDeviceRegistered = try await authenticationService.isDeviceRegistered(withAuthenticationInput: input /*The opaque string sdk input*/)
```

### For first time registration:

```Swift
authenticationService.register(withRegistrationInput: input /*The opaque string sdk input*/) { [weak self] result in
    switch result {
    case let .success(output):
        /// output is an opaque string that should be sent to Adyen backend API (depending on the use case) to be validated for registration to be finalized.
    case let .failure(error):
        /// Failure to register the device, for example if the device is not protected by either pass code, face Id, or fingerprint.
    }
}

// OR you can also use the async version of this function:

let sdkOutput = try await authenticationService.register(withRegistrationInput: input /*The opaque string sdk input*/)
```

### For authentication:

```Swift
authenticationService.authenticate(withAuthenticationInput: input /*The opaque string sdk input*/) { result in
    switch result {
    case let .success(output):
        /// output is an opaque string that should be sent to Adyen backend API (depending on the use case) to be validated for authentication to be finalized.
    case let .failure(error):
        /// Failure to authenticate, which usually means that the current account is not registered.
    }
}

// OR you can also use the async version of this function:

let sdkOutput = try await authenticationService.authenticate(withAuthenticationInput: input /*The opaque string sdk input*/)
```

## Support

If you have a feature request, or spotted a bug or a technical problem, [create an issue here](https://github.com/Adyen/adyen-authentication-ios/issues/new/choose).

For other questions, [contact our support team](https://support.adyen.com/hc/en-us/requests/new?ticket_form_id=360000705420).

## See also

 * [Reporting security issues](https://www.adyen.help/hc/en-us/articles/115001187330-How-do-I-report-a-possible-security-issue-to-Adyen-).
 * [Security best practices](https://docs.adyen.com/online-payments/classic-integrations/api-integration-ecommerce/3d-secure/native-3ds2/ios-sdk-integration/security-best-practices).
 * [Data security at Adyen](https://docs.adyen.com/development-resources/adyen-data-security).

## License

This SDK is available under the Apache License, Version 2.0. For more information, see the [LICENSE](https://github.com/Adyen/adyen-3ds2-ios/blob/master/LICENSE) file.
