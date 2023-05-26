#!/bin/bash

function print_help {
  echo "Test CocoaPods Integration"
}

set -e # Any subsequent(*) commands which fail will cause the shell script to exit immediately

PROJECT_NAME=TempProject

function clean_up {
  cd ../
  rm -rf $PROJECT_NAME
  echo "exited"
}

# Delete the temp folder if the script exited with error.
trap "clean_up" 0 1 2 3 6

rm -rf $PROJECT_NAME

mkdir -p $PROJECT_NAME && cd $PROJECT_NAME

# Create a new Xcode project.
swift package init

# Create the Package.swift.
echo "// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: \"TempProject\",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: \"TempProject\",
            targets: [\"TempProject\"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: \"TempProject\",
            dependencies: []),
        .testTarget(
            name: \"TempProjectTests\",
            dependencies: [\"TempProject\"]),
    ]
)

" > Package.swift

swift package update

swift package generate-xcodeproj

# Create a Podfile with our pod as dependency.

echo "platform :ios, '11.0'

target '$PROJECT_NAME' do
use_frameworks!

pod 'AdyenAuthentication', :path => '../'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = \"\"
      config.build_settings['CODE_SIGNING_REQUIRED'] = \"NO\"
      config.build_settings['CODE_SIGNING_ALLOWED'] = \"NO\"
    end
  end
end
  " >> Podfile

# Install the pods.
pod install

# Archive for generic iOS device
echo '############# Archive for generic iOS device ###############'
xcodebuild archive -scheme TempProject-Package -workspace TempProject.xcworkspace -destination 'generic/platform=iOS'

# Build for generic iOS device
echo '############# Build for generic iOS device ###############'
xcodebuild clean build -scheme TempProject-Package -workspace TempProject.xcworkspace -destination 'generic/platform=iOS'

# Archive for x86_64 simulator
echo '############# Archive for simulator ###############'
xcodebuild archive -scheme TempProject-Package -workspace TempProject.xcworkspace -destination 'generic/platform=iOS Simulator'

# Build for x86_64 simulator
echo '############# Build for simulator ###############'
xcodebuild clean build -scheme TempProject-Package -workspace TempProject.xcworkspace -destination 'generic/platform=iOS Simulator'
