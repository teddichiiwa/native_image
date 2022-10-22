# Native image

A flutter plugin for handling images on iOS and Android

## Usage

```dart
final croppedImageData = await NativeImage().cropImage(
    bytes: originImageData,
    width: 1,
    height: 1,
);
```

<img src="https://github.com/teddichiiwa/native_image/blob/main/native_image/example/assets/demo_image.png" width="500" />

## Features

- [x] Crop image (by aspect ratio).
- [x] Can process image even the phone screen was locked.

## Todo

- [ ] Compress image.
- [ ] Merge multiple images.
