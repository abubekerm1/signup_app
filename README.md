# Pet Pals Signup

I made a signup page for a pretend app called Pet Pals. People can join if they want to help a pet find a home. I did the Standard level, the easy one. I only did Task A, the local signup tip. I did not do Task B or Task C.

The folder is signup_app on the Desktop. I ran flutter create, then I deleted the starter code in lib/main.dart and put the signup form in. After that I changed the color to green and added the tip section.

## How to run

My laptop do not have enough RAM for the emulator, so I used my Android phone.

Plug the phone in and turn on USB debugging. Then run flutter devices, and after that flutter run.

The apk command is flutter build apk --release. The file is build/app/outputs/flutter-apk/app-release.apk.

## The form

MyApp is a StatelessWidget. It only keeps the theme and opens SignupPage. SignupPage is a StatefulWidget because the person types in the boxes and the tip status change while the page is open. The name, email, and password sit in TextEditingControllers.

If the name is empty, it says "Please enter your name". If the email is empty, it says "Please enter your email". If the email has no @, it says "Please enter a valid email". If the password is empty, it says "Please enter a password". If the password is shorter than 6 characters, it says "Password must be at least 6 characters".

The green snackbar only comes when the form validate() is true. I tested this. If a tip is already showing and the boxes are still empty, Sign Up still shows the errors. The tip cannot decide that the account is ok.

## From the button to the text

When I tap "Get a signup tip", it calls _loadTip() in _SignupPageState. That method does not read _nameController, _emailController, or _passwordController. It calls SignupTipCoach.loadTip() in lib/signup_tip_coach.dart. The category in that file is password_help, and the tips are a short fixed list.

loadTip waits about 700 milliseconds. In that time setState changes _tipStatus to loading, so SignupPage builds again. The button is disabled. I see a CircularProgressIndicator and the words "Loading tip...".

If it works, _tipStatus becomes success. Then the page shows the words "Preset demo tip—not live AI." and the tip in a normal Text widget. The tips are all under 240 characters.

If I turn on "Make the tip fail", the coach still waits, then it throws TipLoadException. _tipStatus becomes error. I see "Tip did not load. Please retry." and the button says "Retry". Retry calls _loadTip() again. If the switch is still on, it fails again, so I turn the switch off and tap Retry. Then the preset tip shows.

## The test that changed my code

The first time I ran flutter test, the test "app opens on the signup page" failed. Flutter said the Column overflowed by 98 pixels on the bottom. The body in the test was only 512 pixels tall, so the form and the tip did not fit. I did not notice this when I was just looking at the code. On my phone the tip button can get cut off too, especially when the keyboard is open.

I put the form in a SingleChildScrollView and I set the Column mainAxisSize to min, so the page can scroll. I ran flutter test again and all 13 tests passed. That includes empty fields, a bad email, a short password, a good signup, the tip success, the tip error with Retry, and a short screen of 320 by 480.

## One limit

The fixed tips are safer because they do not need internet and they never see the password, the email, or the name. The limit is the tip is always general. It is not about the password the person really typed. Later I could let the user pick password help or email help, but I still would not read the text boxes.
