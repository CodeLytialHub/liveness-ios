# CodelyticalLivenessSDK

<p align="center">
  <img src="https://www.codelyticalhub.com/logo.png" alt="CodeLytical Logo" width="120" />
</p>

<p align="center">
  <strong>Face liveness detection for iOS — drop-in, automatic, on-device.</strong><br/>
  Powered by MTCNN face detection and a TFLite anti-spoofing model.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-15.0%2B-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square" />
  <img src="https://img.shields.io/badge/CocoaPods-1.0.2-red?style=flat-square" />
  <img src="https://img.shields.io/badge/License-Commercial-lightgrey?style=flat-square" />
</p>

---

## What It Does

CodelyticalLivenessSDK gives your iOS app a fully automatic face liveness screen. The user opens the screen, looks at the camera, and the SDK determines within seconds whether it is a real person or a spoof (photo, screen, mask).

- No capture button — fully automatic
- On-device detection — face data never leaves the phone until capture
- SwiftUI-native — one line to present
- Works with CocoaPods

> **Note:** Swift Package Manager (SPM) is not supported for this SDK because it depends on `TensorFlowLiteObjC` which Google has not released on SPM.

---

## Requirements

- iOS 15.0+
- Xcode 15+
- A CodeLytical API key (see below)

---

## Step 1 — Get Your API Key

1. Go to **[https://www.codelyticalhub.com](https://www.codelyticalhub.com)**
2. Create an account or sign in
3. Navigate to the **Dashboard → API Keys**
4. Click **Generate Key**
5. Copy your key — it starts with `fg_live_`

Keep your key private. Do not commit it to a public repository.

---

## Step 2 — Installation

### CocoaPods

Add this to your `Podfile`:

```ruby
pod 'CodelyticalLivenessSDK', '~> 1.0.2'
```

Then run:

```bash
pod install
```

Open your project using the `.xcworkspace` file from now on.

---

## Step 3 — Camera Permission

Add this to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app uses the camera to perform face liveness detection.</string>
```

Without this the app will crash when the SDK tries to access the camera.

---

## Step 4 — Integration

### Import the SDK

```swift
import CodelyticalLivenessSDK
```

---

### Initialize (validate your API key)

Call this **once on app launch** — for example in your root view's `onAppear` or in your `App` struct. It validates your key against the CodeLytical portal.

```swift
LivenessSdk.initialize(apiKey: "fg_live_YOUR_KEY_HERE") { success, error in
    if success {
        print("SDK ready")
    } else {
        print("Error: \(error ?? "Invalid key")")
    }
}
```

The callback is always called on the **main thread**.

---

### Present the Liveness Screen

Present it as a full-screen cover (recommended):

```swift
.fullScreenCover(isPresented: $showLiveness) {
    LivenessSdk.livenessView { result in
        showLiveness = false

        switch result {
        case .real(let image, let score):
            // Genuine live face detected
            print("Real face — score: \(score)")

        case .spoof:
            // Spoof detected or session timed out
            print("Spoof detected")

        case .cancelled:
            // User tapped the close button
            print("Cancelled")

        case .error(let message):
            // Camera unavailable, model failure, etc.
            print("Error: \(message)")
        }
    }
}
```

---

## Full Example

Here is a complete working screen you can copy directly:

```swift
import SwiftUI
import CodelyticalLivenessSDK

struct ContentView: View {

    private let apiKey = "fg_live_YOUR_KEY_HERE"

    @State private var sdkReady      = false
    @State private var statusText    = "Validating API key…"
    @State private var showLiveness  = false
    @State private var resultText: String?
    @State private var capturedImage: UIImage?

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.07, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                Text("Face Liveness")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)

                Text(statusText)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                if let img = capturedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                if let result = resultText {
                    Text(result)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }

                Button(action: { showLiveness = true }) {
                    Text("Start Liveness Check")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            sdkReady
                                ? Color(red: 0.133, green: 0.773, blue: 0.369)
                                : Color.gray.opacity(0.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!sdkReady)
                .padding(.horizontal, 32)
            }
        }
        .onAppear {
            LivenessSdk.initialize(apiKey: apiKey) { ok, error in
                sdkReady   = ok
                statusText = ok ? "SDK ready ✓" : (error ?? "Invalid API key")
            }
        }
        .fullScreenCover(isPresented: $showLiveness) {
            LivenessSdk.livenessView { result in
                showLiveness  = false
                capturedImage = nil
                resultText    = nil

                switch result {
                case .real(let image, let score):
                    capturedImage = image
                    resultText    = String(format: "✅ Genuine face (score %.3f)", score)

                case .spoof:
                    resultText = "⚠️ Spoof detected"

                case .cancelled:
                    resultText = "Cancelled"

                case .error(let msg):
                    resultText = "Error: \(msg)"
                }
            }
        }
    }
}
```

---

## Result Reference

| Case                  | When it fires                                               |
| --------------------- | ----------------------------------------------------------- |
| `.real(image, score)` | A genuine live face was confirmed and captured              |
| `.spoof`              | A spoof was detected, or no face appeared within 10 seconds |
| `.cancelled`          | The user tapped the ✕ close button                          |
| `.error(String)`      | Camera unavailable, model load failure, or capture error    |

---

## Privacy

All face detection and anti-spoofing runs **entirely on-device**. No video frames or biometric data are sent anywhere. Only the final captured JPEG is available to your app — and only if the result is `.real`.

---

## Support

- Website: [https://www.codelyticalhub.com](https://www.codelyticalhub.com)
- Email: codelyticalhub@gmail.com

---

## License

Commercial. Copyright © CodeLytical. All rights reserved.  
Redistribution, reverse engineering, or resale of this SDK is strictly prohibited.
