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

The tip do not approve the signup. If a tip is already on the screen and the form is still empty, Sign Up still show the errors.

## 1. From the button tap to the tip text

When I tap "Get a signup tip", it call `_loadTip()` in the signup page state. That method do not read the name, the email, or the password. It call `SignupTipCoach.loadTip()` in `lib/signup_tip_coach.dart`.

The coach keep a fixed category, `password_help`, and a few short tips inside the app. It wait about 700 milliseconds, so there is a loading state. Then it return one tip, or it throw an error.

During the loading, `setState` change `_tipStatus` to loading. SignupPage rebuild because it is stateful. The button is disabled, and a `CircularProgressIndicator` show with the text "Loading tip...".

If the load work, `_tipStatus` become success. The page show the label "Preset demo tip" and the tip as plain text. Every sample tip is under 240 characters.

If I turn on "Make the tip fail", the coach still wait, then it throw `TipLoadException`. `_tipStatus` become error. I see "Tip did not load. Please retry." and the button text change to "Retry".

Retry call `_loadTip()` again. If the switch is still on, it fail again, so that is not enough by itself. I turn "Make the tip fail" off and tap Retry. Then the preset tip show.

## 2. One privacy boundary

The tip feature keep the password out. It also keep the name and the email out. `loadTip` do not take those values. It only know the category `password_help`, which tip number to show, and if the fail switch is on. I left the password out because this is only a preset demo. The tip should not see what the user typed, and it should not replace the validators.

## 3. One trade-off

Fixed tips are good for reliability. They stay the same every time, and the phone do not need internet. The trade-off is the tip is always general, so it is less clear for the user. It is not about the password they actually typed. A practical improvement is to let the user choose a category, like password help or email help, but still not read the text fields.

## 4. Which test changed the code

The first time I ran `flutter test`, the test named "app opens on the signup page" failed. Flutter said the Column overflowed by 98 pixels on the bottom. The body in that test was only 512 pixels tall, so the form and the tip section did not fit. I did not notice this just from looking at the code. On a phone the tip button can get cut off, and the keyboard make the space even smaller.

I put the form in a `SingleChildScrollView`, and I set the Column `mainAxisSize` to min so it can scroll instead of overflow. I ran `flutter test` again. All 13 tests passed, including the short screen test at 320 by 480.
