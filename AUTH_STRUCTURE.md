# ZuriTrails Registration and Authentication Structure

## 1. Overview

The authentication system in ZuriTrails is designed to provide a comprehensive and user-friendly registration experience. It supports multiple authentication methods, including email, phone, and social media providers. The UI is well-defined, but the underlying business logic is currently in a placeholder state and requires backend integration to become fully functional.

This document outlines the complete structure of the registration and authentication flow, from the user interface to the proposed business logic and data models.

## 2. User Interface (UI) Flow

The registration and authentication UI is located in the `lib/screens/auth/` directory. The flow is designed to be intuitive and flexible, accommodating different user preferences.

### Key Screens:

-   **`welcome_screen.dart`**: The initial screen that introduces the app and directs users to the authentication flow.

-   **`auth_entry_screen.dart`**: The central hub for authentication. From here, users can choose to:
    -   Sign up with an email address.
    -   Sign up with a phone number.
    -   Sign up using social media (Facebook, Google, Apple).
    -   Navigate to the login screen if they already have an account.

-   **`signup_screen.dart`**: A comprehensive form for users who choose to sign up with their email. It collects essential information, including:
    -   First and last name.
    -   Date of birth.
    -   Email address.
    -   Password.

-   **`multi_step_signup/`**: This directory contains the components for a guided, multi-step signup process. This flow improves the user experience by breaking down the registration process into smaller, more manageable steps, such as:
    -   Entering personal details.
    -   Setting a password.
    -   Agreeing to terms and conditions.

-   **`phone_auth_screen.dart`**: This screen manages the process of signing up or logging in with a phone number. It prompts the user to enter their phone number to receive a verification code.

-   **`verification_code_screen.dart`**: Here, users enter the verification code they received via SMS to complete the phone authentication process.

-   **`login_screen.dart`**: A standard login screen for existing users, with fields for email and password, as well as options for social media logins.

## 3. Business Logic (Proposed Structure)

To make the authentication system functional, a dedicated service should be created to handle all business logic. This service will act as an intermediary between the UI and the backend.

### Proposed File:

-   **`lib/services/auth_service.dart`**

### Proposed `AuthService` Structure:

```dart
class AuthService {
  // Method to sign up with email and password
  Future<void> signUpWithEmail(String email, String password, String firstName, String lastName, DateTime dateOfBirth);

  // Method to sign in with email and password
  Future<void> signInWithEmail(String email, String password);

  // Method to initiate phone number verification
  Future<void> verifyPhoneNumber(String phoneNumber);

  // Method to sign in with a phone credential
  Future<void> signInWithPhone(String verificationId, String smsCode);

  // Methods for social media sign-in (Google, Apple, Facebook)
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signInWithFacebook();

  // Method to sign out the current user
  Future<void> signOut();

  // Stream to listen for authentication state changes
  Stream<User?> get authStateChanges;
}
```

## 4. Data Models

-   **`user_profile.dart`**: This model will represent the user's profile data, including their name, email, and other relevant information.

-   **`signup_data.dart`**: A model to manage the data collected during the multi-step signup process, ensuring a smooth and error-free registration experience.

## 5. Implementation Plan

To build a fully functional authentication system, the following steps are recommended:

1.  **Create `AuthService`**: Implement the `AuthService` class as outlined above, centralizing all authentication logic.

2.  **Integrate a Backend**: Choose and integrate a backend service, such as **Firebase Authentication**, to handle user management, session control, and secure data storage.

3.  **Connect UI to `AuthService`**: Update the auth screens (`signup_screen.dart`, `login_screen.dart`, etc.) to call the methods in `AuthService` instead of using simulated logic.

4.  **Implement Social Logins**: Integrate the necessary SDKs for Google, Apple, and Facebook to enable social media authentication.

5.  **Manage User State**: Create a system to manage the user's authentication state throughout the app, ensuring that users are automatically redirected to the appropriate screen (e.g., home or login) based on their login status.
