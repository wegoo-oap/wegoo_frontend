# Wegoo - Social Travel Companion App

A Flutter-based social travel companion application that helps travelers find their tribe and live their "Wejha" (destination). The app enables users to discover fellow travelers, create and join trips, and connect with like-minded adventurers.

## Project Overview

- **Name**: Wegoo
- **Description**: Social travel companion app
- **Version**: 1.0.0+1
- **Platform**: Flutter (iOS, Android, Web)
- **Language**: Dart (SDK >=3.0.0 <4.0.0)

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Backend**: Firebase (Auth, Firestore, Storage, Messaging)
- **UI Components**: Custom widgets with Plus Jakarta Sans font
- **Key Dependencies**:
  - firebase_core, firebase_auth, cloud_firestore, firebase_storage, firebase_messaging
  - flutter_riverpod, go_router
  - cached_network_image, flutter_animate
  - image_picker, country_picker, table_calendar
  - pin_code_fields

## Screen Overview

**Total Screens: 24**

The application is organized into 5 main feature modules, each containing multiple screens:

---

## 1. Authentication Module (6 screens)
**Folder**: `lib/features/auth/screens/`

| Screen | File | Functionality |
|--------|------|---------------|
| **Splash Screen** | `splash_screen.dart` | Initial loading screen with animated logo and illustration. Auto-redirects to home if user is already logged in, or to phone entry for new users. Features parallax hover effects and staggered animations. |
| **Onboarding Screen** | `onboarding_screen.dart` | Welcome/onboarding screen for first-time users introducing the app concept. |
| **Phone Entry Screen** | `phone_entry_screen.dart` | Phone number input with country code picker. Supports multiple countries (Tunisia, France, Algeria, Morocco, Spain, Italy, Germany, UK, USA, Saudi Arabia, UAE, Turkey). Initiates Firebase phone authentication with OTP. |
| **OTP Screen** | `otp_screen.dart` | OTP verification screen using pin_code_fields. Validates the code sent via SMS and completes authentication flow. |
| **Profile Setup Step 1** | `profile_setup_step1_screen.dart` | First step of profile creation. Collects user's photo (via image picker), full name, age, and nationality. Features animated progress bar (50% complete). Saves data to Firestore. |
| **Profile Setup Step 2** | `profile_setup_step2_screen.dart` | Second step of profile setup. Collects additional profile information (travel style, budget, university, etc.). Completes profile creation and redirects to home. |

---

## 2. Home Module (2 screens)
**Folder**: `lib/features/home/screens/`

| Screen | File | Functionality |
|--------|------|---------------|
| **Discovery Feed Screen** | `discovery_feed_screen.dart` | Tinder-style swipeable card interface for discovering fellow travelers. Displays traveler cards with photo, name, age, location, travel style, budget, and travel date. Features swipe animations (left/right), filter chips (FILTERS, NEAR ME, SOLO ONLY, NEXT 30 DAYS), and parallax hover effects. |
| **Map Screen** | `map_screen.dart` | Map-based view showing traveler locations and trip destinations. |

---

## 3. Profile Module (2 screens)
**Folder**: `lib/features/profile/screens/`

| Screen | File | Functionality |
|--------|------|---------------|
| **My Profile Screen** | `my_profile_screen.dart` | User's own profile page displaying avatar, name, bio, and stats (trips, links, rating). Includes account preferences section with links to Settings, Help & Support, Privacy Policy, and Log Out functionality. |
| **Settings Screen** | `settings_screen.dart` | App settings screen for managing account preferences, notifications, privacy settings, and other configuration options. |

---

## 4. Social Module (7 screens)
**Folder**: `lib/features/social/screens/`

| Screen | File | Functionality |
|--------|------|---------------|
| **Messages Screen** | `messages_screen.dart` | Main messaging hub showing all conversations (direct messages and group chats). Features search functionality, unread message badges, and "mark all read" option. Distinguishes between individual chats and group chats with different avatar styles. |
| **Direct Chat Screen** | `direct_chat_screen.dart` | One-on-one messaging interface for private conversations with individual travelers. |
| **Group Chat Screen** | `group_chat_screen.dart` | Group messaging interface for trip groups and travel communities. |
| **Create Group Screen** | `create_group_screen.dart` | Screen for creating new travel groups. Allows selecting members, setting group name, and configuring group settings. |
| **Group Members Screen** | `group_members_screen.dart` | Displays list of group members with options to manage membership (add/remove members, assign roles). |
| **Connection Requests Screen** | `connection_requests_screen.dart` | Shows pending friend/connection requests from other travelers. Users can accept or decline requests. |
| **Traveler Profile Screen** | `traveler_profile_screen.dart` | Public profile view of other travelers. Displays cover photo, avatar, name, location, verification badge, stats (trips, countries, tribes), about section, interests tags, and recent adventures gallery. Features "Send Message" and "Connect" buttons. |

---

## 5. Trips Module (7 screens)
**Folder**: `lib/features/trips/screens/`

| Screen | File | Functionality |
|--------|------|---------------|
| **My Trips Screen** | `my_trips_screen.dart` | User's personal trip management screen. Shows active trips (with member avatars and details) and past trips (with thumbnails). Features filter tabs (All/Active) and empty state with CTA to create new trip. |
| **Trip Details Screen** | `trip_details_screen.dart` | Detailed view of a specific trip including itinerary, participants, dates, location, and trip-specific information. |
| **Destination Picker Screen** | `destination_picker_screen.dart` | Step 1 of trip creation flow. Searchable destination selector with recent destinations and popular destinations (with badges like "Trending", "Highly Rated"). Features search overlay with suggestions and step indicator (Step 1 of 4). |
| **Date Picker Screen** | `date_picker_screen.dart` | Step 2 of trip creation. Calendar interface for selecting trip start and end dates using table_calendar widget. |
| **Shared Itinerary Screen** | `shared_itinerary_screen.dart` | Collaborative itinerary planning screen where trip members can add, edit, and view trip activities and schedule. |
| **Trip Success Screen** | `trip_success_screen.dart` | Confirmation screen displayed after successfully creating a new trip. Shows trip summary and options to share or start planning. |
| **Post Trip Rating Screen** | `post_trip_rating_screen.dart` | Post-trip feedback screen for rating trip members and the overall trip experience. |

---

## Project Structure

```
lib/
├── main.dart                          # App entry point with Firebase initialization
├── app.dart                           # Root app widget
├── firebase_options.dart              # Firebase configuration
├── core/                              # Core functionality (providers, utilities)
│   └── providers/
│       └── auth_providers.dart         # Riverpod providers for authentication
└── features/                          # Feature-based architecture
    ├── auth/                          # Authentication module
    │   └── screens/                   # 6 authentication screens
    ├── home/                          # Home/discovery module
    │   ├── screens/                   # 2 home screens
    │   └── widgets/                   # Home-specific widgets
    ├── profile/                       # Profile module
    │   └── screens/                   # 2 profile screens
    ├── social/                        # Social/messaging module
    │   └── screens/                   # 7 social screens
    ├── trips/                         # Trip management module
    │   └── screens/                   # 7 trip screens
    └── messages/                      # Messages module (placeholder)
```

## Design System

The app uses a custom design system with the following characteristics:

- **Primary Color**: Blue (#0058BC)
- **Secondary Color**: Orange (#FE9400)
- **Surface Color**: Off-white (#FCF9F8)
- **Font**: Plus Jakarta Sans (variable weight)
- **Border Radius**: Rounded corners (12-24px typical)
- **Animations**: Smooth transitions using flutter_animate and custom animation controllers
- **Shadows**: Subtle, layered shadows for depth

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase project configured
- Valid Firebase configuration files (firebase_options.dart)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Add your firebase_options.dart file
   - Set up Firebase Auth, Firestore, and Storage
4. Run the app:
   ```bash
   flutter run
   ```

## Firebase Configuration

The app requires the following Firebase services:
- **Authentication**: Phone number authentication
- **Firestore**: User profiles, trips, messages
- **Storage**: Profile photos and trip images
- **Messaging**: Push notifications

## Key Features

- **Phone-based Authentication**: Secure login via Firebase Phone Auth
- **Traveler Discovery**: Swipeable card interface to find compatible travel companions
- **Trip Planning**: Create trips with destination selection, date picking, and itinerary sharing
- **Social Features**: Direct messaging, group chats, connection requests
- **Profile Management**: Rich user profiles with photos, stats, and travel preferences
- **Real-time Updates**: Firestore integration for live data synchronization

## Development Notes

- The app uses a feature-based architecture for better scalability
- State management is handled by Riverpod providers
- Navigation uses GoRouter for type-safe routing
- All screens follow consistent design patterns and animations
- Firebase Storage photo upload is temporarily disabled (requires Blaze plan)

## License

This project is proprietary software.
