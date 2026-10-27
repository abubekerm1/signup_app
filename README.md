# Pet Pals Signup

This is my signup screen for a pretend app called Pet Pals. People can make an account if they want to help a pet find a home. I did the Standard challenge, so I only finished Task A (the local signup tip). I did not do Task B or Task C. Those are the advanced extras, and I picked the easier level.

I created the folder with `flutter create signup_app` on the Desktop. I kept the folder. I only deleted the starter code inside `lib/main.dart`, pasted the signup form, then I changed the theme to green for Pet Pals and added the tip section.

## How to run it

My laptop do not have enough RAM for the emulator, so I test on a real Android phone.

1. Plug the phone with a USB cable.
2. Turn on USB debugging.
3. In this folder run `flutter devices` and make sure the phone is on the list.
4. Run `flutter run`.

The release apk command is:

```
flutter build apk --release
```

When it finish, the file is `build/app/outputs/flutter-apk/app-release.apk`.

## The form

`MyApp` is a StatelessWidget. It only keep the theme and open `SignupPage`. `SignupPage` is a StatefulWidget because the name, email, and password controllers live there, and the tip status also change while the page is open.

If I leave the fields empty and press Sign Up, the errors are "Please enter your name", "Please enter your email", and "Please enter a password".

If the email has no @, it says "Please enter a valid email". If the password is shorter than 6 characters, it says "Password must be at least 6 characters". When the form is valid, a green snackbar says the demo signup passed validation.

The tip do not approve the signup. If a tip is already on the screen and the form is still empty, Sign Up still show the errors. The result label is "Preset demo tip—not live AI."

## Trace the tip from the button to the text

When I tap "Get a signup tip", the button call `_loadTip()` in `_SignupPageState`. That method do not read the name, the email, or the password. It call `SignupTipCoach.loadTip()` in `lib/signup_tip_coach.dart`. The coach use the fixed category `password_help` and return one short tip from the list in the app.

The coach wait about 700 milliseconds. While it wait, `setState` change `_tipStatus` from idle to loading. `SignupPage` is a StatefulWidget, so this rebuild the tip area. The button is disabled, and a `CircularProgressIndicator` show next to the words "Loading tip...".

If it work, `_tipStatus` change to success. The same page then show the label "Preset demo tip—not live AI." and the tip as plain text. The tip is under 240 characters.

If "Make the tip fail" is on, the coach throw `TipLoadException` after the wait. `_tipStatus` change to error. I see "Tip did not load. Please retry." and the button text change to "Retry". Retry call `_loadTip()` again. If the switch is still on, it fail again. I turn the switch off and tap Retry, then the preset tip show.

## Which test changed what I built

The first time I ran `flutter test`, the test "app opens on the signup page" failed. Flutter said the Column overflowed by 98 pixels on the bottom. The test body was only 512 pixels tall, so the form and the tip section did not fit. I did not see this just from reading the code. On the phone the tip button can be cut off, and the keyboard make it worse.

I put the form inside a `SingleChildScrollView` and set the Column `mainAxisSize` to min so the page can scroll. I ran the tests again and all 13 passed, including a short screen of 320 by 480.
