# ZuriTrails Multi-Step Signup: A Deep Dive into Each Step

## 1. Overview

This document provides a detailed analysis of each step in the multi-step signup process. Each step is a self-contained widget responsible for a specific piece of the user onboarding experience, from collecting basic information to personalizing the user's profile.

## 2. Breakdown of Each Step

### `welcome_step.dart`

-   **Purpose**: To provide a visually engaging and welcoming introduction to the ZuriTrails app and the signup process.
-   **Functionality**: This step is purely informational and does not collect any data. It features the app's logo, a catchy tagline, and a grid of activity icons to give users a glimpse of what the app offers. A prominent "i'm in!" button, implemented with the `SignupButton` widget, triggers the `onNext` callback to move to the next step.

### `birthday_step.dart`

-   **Purpose**: To collect the user's date of birth and ensure they meet the minimum age requirement.
-   **Functionality**: This step uses the `showDatePicker` dialog to allow users to select their birthdate. It includes validation to ensure the user is at least 18 years old. The selected date is stored in the `SignupData` object. The "next" button is disabled until a valid date is selected.

### `referral_step.dart`

-   **Purpose**: To gather information about how the user discovered the app.
-   **Functionality**: This step presents a list of referral sources (e.g., Instagram, TikTok, a friend). The `SelectionOption` widget is used to create a visually appealing and interactive list. The user's selection is stored in the `SignupData` object, and the "next" button is enabled once a selection is made.

### `name_step.dart`

-   **Purpose**: To collect the user's first name.
-   **Functionality**: This step provides a simple text input field for the user to enter their name. The input is stored in the `SignupData` object, and the "next" button is enabled once the field is filled.

### `gender_step.dart`

-   **Purpose**: To collect the user's gender for their profile.
-   **Functionality**: This step displays a list of gender options (Male, Female, Non-binary), each with a corresponding icon. The `SelectionOption` widget is used to create the list. The selected gender is stored in the `SignupData` object.

### `country_step.dart`

-   **Purpose**: To collect the user's country of residence.
-   **Functionality**: This step features a searchable list of countries. A `TextField` is used for the search functionality, which filters the list of countries in real-time. The selected country is highlighted, and the choice is stored in the `SignupData` object.

### `travel_style_step.dart`

-   **Purpose**: To understand the user's travel preferences.
-   **Functionality**: This step allows the user to select up to two travel styles from a predefined list (e.g., Safari Enthusiast, Beach Lover). The `SelectionOption` widget is used to display the options, and the selections are stored in the `SignupData` object.

### `interests_step.dart`

-   **Purpose**: To personalize the user's experience by gathering their interests.
-   **Functionality**: This step presents a categorized list of interests (e.g., Wildlife & Safari, Culture & Arts). Users can select up to 10 interests, which are displayed as chips using the `InterestChip` widget. The selected interests are stored in the `SignupData` object.

### `profile_photo_step.dart`

-   **Purpose**: To allow the user to upload a profile photo.
-   **Functionality**: This step provides an option to add a profile photo. The photo is optional, and the user can choose to skip this step. The UI includes a placeholder for the photo and a button to trigger the (currently placeholder) image picker.

### `notifications_step.dart`

-   **Purpose**: To ask for permission to send push notifications.
-   **Functionality**: This step explains the benefits of enabling notifications and provides two options: "allow notifications" and "not now." The user's choice is stored in the `SignupData` object.

### `activity_preferences_step.dart`

-   **Purpose**: To gather the user's preferences for activities they want to be notified about.
-   **Functionality**: This step allows the user to select either "All activities" or specific activity types (e.g., Safari & Wildlife, Food & Drinks). The `SelectionOption` widget is used to display the choices, which are then stored in the `SignupData` object.

### `location_step.dart`

-   **Purpose**: To ask for permission to access the user's location.
-   **Functionality**: This step explains why location access is needed (to connect with nearby travelers and find activities). It provides two buttons: "allow location access" and "not now." The user's choice is stored in the `SignupData` object.

### `privacy_step.dart`

-   **Purpose**: To allow the user to configure their privacy settings and complete the signup process.
-   **Functionality**: This is the final step. It includes a toggle switch for the user to control whether their distance from other users is displayed. A prominent "create your account" button triggers the `onComplete` callback, finalizing the signup flow.
