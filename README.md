# Yummy v1.6.3

## Need to fix:
    - Login with google ⚠️✅
        - SOLUTION: fixed with sha1 ⚠️
    - Stream update page when login ⚠️✅
        - SOLUTION: notifyListeners() on SignIn(); ⚠️
    - .then(): ⚠️⭕
        - fix with notifyListeners(); ⚠️⭕
    - Cart insert new item on details navigation return and not push logic when start from cart page ⚠️⭕
        - navigation ⚠️✅
        - item name: The getter 'name' was called on null. ⚠️⭕
        - SOLUTION: maybe set a loading to wait the progress to finish
    - Image profile not uppdate uin real time ⚠️✅
## Desirable:
    - Internationalization ⭕
    - Add recipe image on recipe ingredients page ⭕

# Getting Started

### execute on mobile
flutter run
### execute on web
flutter run -d chrome --web-port 8080 --web-renderer html

# important provider
https://github.com/rrousselGit/provider/issues/168

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.