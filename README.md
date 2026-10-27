# Pet Pals Signup

My name is Abubeker Mohammed. I picked the Standard track, and I only did Task A, the local signup tip. I did not do Task B or Task C.

## Explanation of the local signup-tip simulation

The fixed category is password_help, and three short tips are saved in SignupTipCoach on the phone. There is no server and no login or API key, so the tip never reads the name, email, or password. The app waits a little, then shows one saved sentence with the label "Preset demo tip—not live AI.", or an error with Retry if "Make the tip fail" is on.

## Task A reflection

I ran flutter test and 13 tests passed. They covered an empty form, an email with no @, a short password, a valid signup, the tip success, the tip error with Retry, and a short screen.

### Question 1. From the button tap to the text

When I tap "Get a signup tip", _loadTip() calls SignupTipCoach.loadTip() and it does not read the name, email, or password. setState change _tipStatus to loading, so SignupPage builds again and I see a CircularProgressIndicator with "Loading tip...". If the fail switch is on, I turn it off and tap Retry, and then the preset tip shows.

### Question 2. The test that changed my code

The first flutter test, "app opens on the signup page", failed because the Column overflowed by 98 pixels on the bottom. I did not notice that from only reading the code, and on my phone the tip can get cut off when the keyboard is open. I put the form in a SingleChildScrollView, and after that all 13 tests passed.

## How to run

My laptop do not have enough RAM for the emulator, so I used my Android phone. Plug the phone in, turn on USB debugging, then run flutter devices and flutter run. The release apk is build/app/outputs/flutter-apk/app-release.apk.

## The form

MyApp is a StatelessWidget because it only keeps the theme. SignupPage is a StatefulWidget because the text boxes and the tip status change. Empty fields, an email with no @, and a password shorter than 6 characters show errors. The green snackbar only comes when validate() is true, and the tip cannot approve the signup.
