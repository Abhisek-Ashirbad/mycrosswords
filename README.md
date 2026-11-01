# Mini Crossword

A small Flutter crossword game for Android phones and Android TV, organized
into puzzle models, game state, persistence, and reusable UI components.

## Play

- Tap a square twice to switch between Across and Down.
- Select a clue to jump to its first square, then choose letters on the
  on-screen keyboard.
- On Android TV, navigate squares with the remote's directional pad and enter
  letters with a connected keyboard or the on-screen keyboard.
- Select **Check answers** to see whether the puzzle is complete and correct.
- Progress is saved on the device. Select **Clear** to start over.

The starter puzzle is a 4-by-4 word square with four Across and four Down clues.

## Set up Flutter for Android

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and
   add Flutter's `bin` directory to your `PATH`.
2. Install [Android Studio](https://developer.android.com/studio). In its SDK
   Manager, install an Android SDK platform and Android SDK Build-Tools. In
   Plugins, install the Flutter plugin (which also installs Dart).
3. From a terminal opened in this repository, check the setup:

   ```shell
   flutter doctor
   flutter doctor --android-licenses
   ```

   Accept the Android SDK licenses when prompted. Resolve any Android toolchain
   errors reported by `flutter doctor` before building.
4. Fetch the app dependencies:

   ```shell
   flutter pub get
   ```

## Run on a phone or Android TV

For a physical Android device, enable Developer options and USB debugging,
connect it to your computer, and accept the debugging prompt. Alternatively,
create and start a phone emulator in Android Studio's **Device Manager**.
For Android TV, create and start an Android TV emulator in Device Manager.

List the available targets and start the app:

```shell
flutter devices
flutter run
```

If more than one device is connected, select a target explicitly using its
device ID from `flutter devices`:

```shell
flutter run -d <device-id>
```

While the app is running, press `r` in the terminal for hot reload or `q` to
quit. You can also open the `android` directory in Android Studio to work with
the Android platform project.

To build a release APK for installation on a compatible device:

```shell
flutter build apk --release
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`.

## Run the behavior-driven tests

The feature scenarios in
[`test/features/crossword_game.feature`](test/features/crossword_game.feature)
document the expected behavior in Given/When/Then form. Their executable
Flutter widget tests are in
[`test/crossword_game_test.dart`](test/crossword_game_test.dart).

Run all tests from the repository root:

```shell
flutter test
```

Run just the crossword game scenarios:

```shell
flutter test test/crossword_game_test.dart
```

To see individual test names and results, use:

```shell
flutter test --reporter expanded
```
