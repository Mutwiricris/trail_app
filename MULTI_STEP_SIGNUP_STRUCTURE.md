# ZuriTrails Multi-Step Signup Structure

## 1. Overview

The multi-step signup process in ZuriTrails is designed to provide a seamless and engaging onboarding experience for new users. It breaks down the registration process into a series of smaller, more manageable steps, guiding the user through the collection of essential information in a logical and intuitive manner.

This document provides a detailed breakdown of the structure of the multi-step signup flow, from the high-level coordinator to the individual steps and reusable widgets.

## 2. Core Components

The multi-step signup is orchestrated by a central coordinator that manages the flow and state of the registration process. The UI is composed of a series of distinct steps, each with its own dedicated screen and purpose.

### Key Files and Directories:

-   **`lib/screens/auth/multi_step_signup/signup_flow_coordinator.dart`**: This is the heart of the multi-step signup. It uses a `PageView` to manage the sequence of steps and a `SignupData` model to maintain the user's information throughout the process.

-   **`lib/screens/auth/multi_step_signup/steps/`**: This directory contains all the individual screens that make up the signup flow. Each screen is a self-contained widget responsible for its own UI and logic.

-   **`lib/screens/auth/multi_step_signup/widgets/`**: This directory holds reusable UI components that are shared across the different signup steps, ensuring a consistent and polished user experience.

-   **`lib/models/signup_data.dart`**: This data model is used to store the user's information as they progress through the signup flow. It is passed to each step to be populated with the relevant data.

## 3. The Signup Flow and Data Collection

The `SignupFlowCoordinator` defines the sequence of steps in the registration process. As the user progresses, the `SignupData` object is populated. Here is a step-by-step breakdown of the data collection process using the mock data as an example.

### `SignupData` Class Definition:

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

### Data Collection Flow:

**Initial Data:** The `email` is passed from the `AuthEntryScreen`.
- `email`: "cris.tourist@example.com"

**1. `WelcomeStep`**: A welcoming screen that introduces the user to the signup process.
- **Data Collected**: None.

**2. `BirthdayStep`**: Collects the user's date of birth.
- **Data Collected**: `dateOfBirth: "1995-08-15T00:00:00.000Z"`

**3. `ReferralStep`**: Asks if the user was referred by someone.
- **Data Collected**: `referralCode: "FRIEND2024"`

**4. `NameStep`**: Prompts the user to enter their first and last name.
- **Data Collected**: `firstName: "Cris"`, `lastName: "Tourist"`

**5. `GenderStep`**: Asks the user to select their gender.
- **Data Collected**: `gender: "Female"`

**6. `CountryStep`**: Collects the user's country of residence.
- **Data Collected**: `country: "Kenya"`

**7. `TravelStyleStep`**: Gathers information about the user's travel preferences.
- **Data Collected**: `travelStyle: "Adventure"`

**8. `InterestsStep`**: Allows the user to select their interests.
- **Data Collected**: `interests: ["Hiking", "Photography", "Food"]`

**9. `ProfilePhotoStep`**: Prompts the user to upload a profile photo.
- **Data Collected**: `profilePhotoPath: "/path/to/profile/photo.jpg"`

**10. `NotificationsStep`**: Asks for permission to send notifications.
- **Data Collected**: `enableNotifications: true`

**11. `ActivityPreferencesStep`**: Gathers the user's preferred activities.
- **Data Collected**: `activityPreferences: ["Wildlife Safari", "Cultural Tours"]`

**12. `LocationStep`**: Asks for permission to access the user's location.
- **Data Collected**: `enableLocation: true`

**13. `PrivacyStep`**: Asks the user to agree to the terms.
- **Data Collected**: `agreedToPrivacy: true`

### Final Mock Data Object:

After completing all the steps, the final `SignupData` object would look like this:

```json
{
  "email": "cris.tourist@example.com",
  "dateOfBirth": "1995-08-15T00:00:00.000Z",
  "referralCode": "FRIEND2024",
  "firstName": "Cris",
  "lastName": "Tourist",
  "gender": "Female",
  "country": "Kenya",
  "travelStyle": "Adventure",
  "interests": ["Hiking", "Photography", "Food"],
  "profilePhotoPath": "/path/to/profile/photo.jpg",
  "enableNotifications": true,
  "activityPreferences": ["Wildlife Safari", "Cultural Tours"],
  "enableLocation": true,
  "agreedToPrivacy": true
}
```

## 5. Conclusion

The multi-step signup structure is well-designed and highly modular. The separation of concerns between the coordinator, the individual steps, and the reusable widgets makes the code easy to understand, maintain, and extend. The use of a shared data model ensures that the state of the signup process is managed efficiently and reliably.
