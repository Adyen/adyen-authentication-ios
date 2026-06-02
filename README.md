# AdyenAuthentication iOS SDK

The **AdyenAuthentication SDK** provides reusable, secure, and easy-to-integrate two-factor authentication for sensitive use cases such as banking, issuing, and PSD2 strong customer authentication.


## ⚙️ Installation

The SDK can be integrated via [CocoaPods](http://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage), [Swift Package Manager](https://www.swift.org/package-manager/), or manual installation.

### CocoaPods

1. Add the following line to your `Podfile`:
   ```ruby
   pod 'AdyenAuthentication'
   ```

### Carthage

> **Note:** Carthage is no longer actively maintained and is not recommended for new projects. Prefer Swift Package Manager if possible.

1. Add the following to your `Cartfile`:
   ```text
   github "adyen/adyen-authentication-ios"
   ```
2. Link the generated framework with your target as described in [Carthage’s guide](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### Swift Package Manager (Recommended)

1. Follow Apple’s guide on [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
2. Use the repository URL:  
   `https://github.com/Adyen/adyen-authentication-ios`

**Requirements:**  
- Swift 5.7+  
- Xcode 16+  
- iOS 14 or later for DeviceCheck
- iOS 16 or later for passkeys.

### XCFramework Installation

#### Dynamic xcFramework
1. Drag `XCFramework/Dynamic/AdyenAuthentication.xcframework` into the **Frameworks, Libraries, and Embedded Content** section of your app target.
2. Choose **“Copy items if needed.”**

#### Static xcFramework
1. Drag `XCFramework/Static/AdyenAuthentication.xcframework` into the **Frameworks, Libraries, and Embedded Content** section.
2. Ensure the framework is **not embedded**.

## 📱 Supported App Targets

| Authentication Method | iOS App | App Extension | Documentation |
| :--- | :---: | :---: | :--- |
| **DeviceCheck** | ✅ Supported | ❌ Not Supported | [App Attest](https://developer.apple.com/documentation/devicecheck/) |
| **Passkeys** | ✅ Supported | ⚠️ Conditional | [ASAuthorizationController](https://developer.apple.com/documentation/authenticationservices/asauthorizationcontroller) |

For App Extensions, Passkeys require [ASAuthorizationControllerPresentationContextProviding](https://developer.apple.com/documentation/authenticationservices/asauthorizationcontrollerpresentationcontextproviding).

## 🔑 Prerequisites

Before using the AdyenAuthentication SDK, configure your Xcode project with the required Apple capabilities.

| Authentication Method | Required Capability | Documentation |
|-----------------------|---------------------|---------------|
| DeviceCheck | DeviceCheck + App Attest | [Preparing to Use the App Attest Service](https://developer.apple.com/documentation/devicecheck/preparing-to-use-the-app-attest-service) |
| Passkeys | Associated Domains | [Supporting Passkeys](https://developer.apple.com/documentation/authenticationservices/supporting-passkeys) |


### DeviceCheck

1. Enable **App Attest** capability in your app target.
2. Add the following to your `.entitlements` file:

   ```xml
   <key>com.apple.developer.devicecheck.appattest-environment</key>
   <string>production</string>
   ```

> Use `production` for live environments. For sandbox testing, configure appropriately.

### Passkeys

1. Enable **Associated Domains** capability.
2. Add your domain using the `webcredentials` service:

   ```
   webcredentials:your-domain.com
   ```

> Ensure your `relyingPartyIdentifier` in code **matches the associated domain** declared here.

---

## 🧩 Usage

### Initialization Options

You can initialize the SDK in one of two mutually exclusive ways:

#### 1. Using DeviceCheck APIs

```swift
let configuration = AuthenticationService.Configuration(
    localizedRegistrationReason: "Biometric use explanation for registration.",
    localizedAuthenticationReason: "Biometric use explanation for authentication.",
    appleTeamIdentifier: "YOUR_APPLE_TEAM_ID"
)
let authenticationService = AuthenticationService(configuration: configuration)
```

Ensure the **App Attest** capability and **App Attest entitlement** are configured.

#### 2. Using Apple Passkeys

```swift
let configuration = AuthenticationService.PassKeyConfiguration(
    relyingPartyIdentifier: "your-domain.com",
    displayName: "Your App Name",
    consecutiveApprovalCancellationsLimit: 3 // Optional: refer AdyenAuthenticationError.consecutiveCancellationOnApproval
)
let authenticationService = AuthenticationService(passKeyConfiguration: configuration)
```

Ensure the **Associated Domains** capability is enabled and your `webcredentials` entry matches the relying party domain.

---

### Checking Device Support

```swift
do {
    let deviceSupportPayload = try authenticationService.checkSupport()
    // Send this payload to your backend for validation.
} catch {
    print("Device not supported: \(error)") // `AdyenAuthenticationError` if not supported.  
}
```

If successful, `checkSupport()` returns a Base64 URL-encoded payload describing device capabilities.

---

### Registering and Authenticating

#### Check Registration Status

```swift
do {
    let isDeviceRegistered = try await authenticationService.isDeviceRegistered(withAuthenticationInput: backendInput) /*The opaque string sdk input*/
} catch error {
    // refer: `AdyenAuthenticationError` for the type of errors.
}
```

#### Register Device

```swift
do {
    let sdkOutput = try await authenticationService.register(withRegistrationInput: backendInput) /*The opaque string sdk input*/
} catch error {
    // refer: `AdyenAuthenticationError` for the type of errors.
}
```

#### Authenticate User


```swift
do {
    let sdkOutput = try await authenticationService.authenticate(withAuthenticationInput: backendInput) /*The opaque string sdk input*/
} catch error {
    // refer: `AdyenAuthenticationError` for the type of errors.
}
```

## 🧠 Error Handling

Common `AuthenticationService.Error` cases includes:
- `.userCancelled` // User cancelled authentication
- `.deviceOwnerAuthenticationFailure` // Indicates that device owner authentication failed.


For more such errors refer to the [source documentation](https://adyen.github.io/adyen-authentication-ios/).

---

## 🧩 Support

If you encounter a bug or have a feature request, [open an issue](https://github.com/Adyen/adyen-authentication-ios/issues/new/choose).  
For other questions, [contact Adyen Support](https://support.adyen.com/hc/en-us/requests/new?ticket_form_id=360000705420).

---

## 🔒 See Also

- [Reporting security issues](https://www.adyen.help/hc/en-us/articles/115001187330-How-do-I-report-a-possible-security-issue-to-Adyen-)  
- [Security best practices](https://docs.adyen.com/online-payments/classic-integrations/api-integration-ecommerce/3d-secure/native-3ds2/ios-sdk-integration/security-best-practices)  
- [Data security at Adyen](https://docs.adyen.com/development-resources/adyen-data-security)

---

## 📜 License

This SDK is available under the **Apache License, Version 2.0**.  
See the [LICENSE](https://github.com/Adyen/adyen-authentication-ios/blob/master/LICENSE) file for details.
