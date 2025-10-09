# poc_ios_modularization
POC iOS project showing a way of modularizing an iOS that use KMP

## Project Structure

This project demonstrates a modular architecture with:

### Kotlin Multiplatform Module (`shared/`)
- A KMP module that compiles to iOS frameworks
- Contains shared business logic in `commonMain`
- iOS-specific implementations in `iosMain`
- Configured to build static frameworks for iOS (arm64, x64, and simulator arm64)

### iOS Application (`iosApp/`)
- A SwiftUI-based iOS application
- Depends on the KMP `shared` framework
- Uses a build script to automatically build the KMP framework during Xcode builds

## Building the Project

### Build the KMP module:
```bash
./gradlew :shared:build
```

### Build iOS frameworks:
```bash
./gradlew :shared:linkDebugFrameworkIosSimulatorArm64
./gradlew :shared:linkReleaseFrameworkIosArm64
```

### Build the iOS app:
Open `iosApp/iosApp.xcodeproj` in Xcode and build the project. The build script will automatically compile the KMP framework.
