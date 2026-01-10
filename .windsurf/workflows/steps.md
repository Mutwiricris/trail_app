---
description: A detailed breakdown of the data structure and data collection flow in the multi-step signup process.
---

# ZuriTrails Multi-Step Signup: Data Structure and Flow

## 1. Overview

This document provides a detailed analysis of the data structure used in the multi-step signup process and maps each step to the specific data it collects. The central data model for this process is the `SignupData` class.

## 2. `SignupData` Class Definition

The `SignupData` class, located in `lib/models/signup_data.dart`, holds all the information collected from the user during the signup flow.

```dart
class SignupData {
  String? email;
  DateTime? dateOfBirth;
  String? referralCode;
  String? firstName;
  String? lastName;
  String? gender;
  String? country;
  String? travelStyle;
  List<String> interests = [];
  String? profilePhotoPath;
  bool? enableNotifications;
  List<String> activityPreferences = [];
  bool? enableLocation;
  bool? agreedToPrivacy;
}
```

## 3. Data Collection by Step (Summary)

Here is a breakdown of which file in the `/steps` directory is responsible for collecting each piece of data.

-   **`welcome_step.dart`**: None
-   **`birthday_step.dart`**: `dateOfBirth`
-   **`referral_step.dart`**: `referralCode`
-   **`name_step.dart`**: `firstName`, `lastName`
-   **`gender_step.dart`**: `gender`
-   **`country_step.dart`**: `country`
-   **`travel_style_step.dart`**: `travelStyle`
-   **`interests_step.dart`**: `interests`
-   **`profile_photo_step.dart`**: `profilePhotoPath`
-   **`notifications_step.dart`**: `enableNotifications`
-   **`activity_preferences_step.dart`**: `activityPreferences`
-   **`location_step.dart`**: `enableLocation`
-   **`privacy_step.dart`**: `agreedToPrivacy`

## 4. Available Options (Summary)

### `referral_step.dart`
- Instagram 📷, TikTok 🎵, YouTube ▶️, X (Twitter) 𝕏, Facebook 👥, A friend 👫, Google Search 🔍, Other 🌐

### `gender_step.dart`
- Male ♂️, Female ♀️, Non-binary ⚧️

### `country_step.dart`
- Kenya 🇰🇪, United States 🇺🇸, United Kingdom 🇬🇧, Canada 🇨🇦, Australia 🇦🇺, Germany 🇩🇪, France 🇫🇷, Spain 🇪🇸, Italy 🇮🇹, Netherlands 🇳🇱, South Africa 🇿🇦, Nigeria 🇳🇬, Ghana 🇬🇭, Uganda 🇺🇬, Tanzania 🇹🇿, India 🇮🇳, China 🇨🇳, Japan 🇯🇵, Brazil 🇧🇷, Mexico 🇲🇽

### `travel_style_step.dart`
- Safari Enthusiast 🦁, Beach Lover 🏖️, Cultural Explorer 🎨, Adventure Seeker 🏔️, Business Traveler 💼, Local Host 🏠

### `activity_preferences_step.dart`
- All activities ✨, Safari & Wildlife 🦁, Food & Drinks 🍽️, Nightlife 🎉, Outdoor & Active 🥾, Sightseeing 🗺️, Culture & Arts 🎨, Beach & Water 🏖️, Wellness 🧘

### `interests_step.dart`
- **Wildlife & Safari**: Game Drives 🚙, Wildlife Photography 📷, Bird Watching 🦅, Conservation 🌿
- **Culture & Arts**: Art & Museums 🎨, Local Culture 🌍, History 🏛️, Music & Dance 🎵, Food Tours 🍽️, Local Markets 🛍️
- **Outdoor & Adventure**: Hiking 🥾, Cycling 🚴, Running 🏃, Climbing 🧗, Camping ⛺, Water Sports 🏄, Diving 🤿
- **Beach & Coastal**: Beach 🏖️, Snorkeling 🤿, Sailing ⛵, Surfing 🏄
- **Wellness & Fitness**: Yoga 🧘, Meditation 🧘‍♀️, Fitness 💪, Spa 💆
- **Food & Social**: Coffee Tours ☕, Local Cuisine 🍲, Wine Tasting 🍷, Nightlife 🎉
- **Values & Beliefs**: Sustainability ♻️, Volunteering 🤝, Community Tourism 👥

---

## 5. The Signup Steps: A Detailed Walkthrough

### Step 1: `welcome_step.dart`

*   **Purpose**: To provide a visually engaging introduction to the app.
*   **UI & Functionality**: This screen displays the ZuriTrails logo, a tagline, and a series of icons representing different activities. It's a purely informational step with a single call to action: an "i'm in!" button that moves the user to the next step.
*   **Data Collected**: None.

### Step 2: `birthday_step.dart`

*   **Purpose**: To collect the user's date of birth and verify they are over 18.
*   **UI & Functionality**: This step features a single button that, when tapped, displays a native date picker dialog. The selected date is validated to ensure the user meets the age requirement.
*   **Data Collected**: `dateOfBirth`

### Step 3: `referral_step.dart`

*   **Purpose**: To understand how the user discovered the app.
*   **UI & Functionality**: A list of referral sources is presented to the user. Each option is a `SelectionOption` widget, providing a clean and consistent UI.
*   **Data Collected**: `referralCode`

### Step 4: `name_step.dart`

*   **Purpose**: To collect the user's name.
*   **UI & Functionality**: This step contains two `TextField` widgets for the user's first and last name.
*   **Data Collected**: `firstName`, `lastName`

### Step 5: `gender_step.dart`

*   **Purpose**: To collect the user's gender.
*   **UI & Functionality**: A set of `SelectionOption` widgets allows the user to choose their gender.
*   **Data Collected**: `gender`

### Step 6: `country_step.dart`

*   **Purpose**: To collect the user's home country.
*   **UI & Functionality**: This step features a searchable list of countries, each displayed with its flag. A `TextField` at the top allows the user to filter the list in real-time.
*   **Data Collected**: `country`

### Step 7: `travel_style_step.dart`

*   **Purpose**: To understand the user's travel preferences.
*   **UI & Functionality**: The user can select up to two travel styles from a list of `SelectionOption` widgets.
*   **Data Collected**: `travelStyle`

### Step 8: `interests_step.dart`

*   **Purpose**: To personalize the user's profile and activity suggestions.
*   **UI & Functionality**: This step presents a comprehensive, categorized list of interests. Users can select up to 10 interests, which are displayed as `InterestChip` widgets.
*   **Data Collected**: `interests`

### Step 9: `profile_photo_step.dart`

*   **Purpose**: To allow the user to upload a profile photo.
*   **UI & Functionality**: This step provides a circular placeholder and a button to trigger the image picker. The photo is optional, and the user can skip this step.
*   **Data Collected**: `profilePhotoPath`

### Step 10: `notifications_step.dart`

*   **Purpose**: To request permission to send push notifications.
*   **UI & Functionality**: This screen explains the benefits of enabling notifications and provides two buttons: "continue" and "not now."
*   **Data Collected**: `enableNotifications`

### Step 11: `activity_preferences_step.dart`

*   **Purpose**: To gather the user's preferences for activity notifications.
*   **UI & Functionality**: The user can choose to be notified about "All activities" or select specific categories from a list of `SelectionOption` widgets.
*   **Data Collected**: `activityPreferences`

### Step 12: `location_step.dart`

*   **Purpose**: To request permission to access the user's location.
*   **UI & Functionality**: This screen explains the benefits of enabling location services and provides two buttons: "enable & continue" and "not now."
*   **Data Collected**: `enableLocation`

### Step 13: `privacy_step.dart`

*   **Purpose**: To allow the user to configure their privacy settings and complete the signup.
*   **UI & Functionality**: This final step includes a toggle switch to control whether the user's distance from others is displayed. A final "create your account" button completes the signup process.
*   **Data Collected**: `agreedToPrivacy`
