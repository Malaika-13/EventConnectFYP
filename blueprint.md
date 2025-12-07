# Project Blueprint

## Overview

This document outlines the design, features, and implementation of the Event Booking App. The app allows users to browse and book various venues, while providing a secure admin panel for managing the venue inventory.

## Style, Design, and Features

### Version 1.0 (Current)

**Theme and Styling:**

*   **Color Scheme:** A modern and professional navy blue theme is used throughout the app. The primary color is `Colors.indigo`, with complementary colors for light and dark modes.
*   **Typography:** The `google_fonts` package is used with the "Poppins" font to create a clean and elegant text style.
*   **UI Components:** The app uses modern Material Design 3 components, with customized styles for buttons, app bars, and cards to ensure a consistent and polished look.

**User Authentication:**

*   **Firebase Authentication:** Handles user sign-up and login with email and password.
*   **Role-Based Access Control:**
    *   An `AuthService` manages user roles, distinguishing between regular users and administrators.
    *   Admin access is restricted to a predefined list of user emails.

**Screens and Navigation:**

*   **Splash Screen:** A loading screen that directs users to the appropriate screen based on their authentication state and role (admin, user, or unauthenticated).
*   **Authentication Screen:** A redesigned login and sign-up screen with a modern layout, logo, and a user-friendly interface.
*   **Home Screen:**
    *   Displays a list of available venues with images, names, and categories.
    *   Users can tap on a venue to view its details.
    *   A floating action button to access the `AdminScreen` is visible only to admin users.
*   **Venue Detail Screen:**
    *   Provides detailed information about a selected venue, including its name, description, and image.
    *   Users can select a booking date and check for availability.
    *   A "Book Now" button allows users to book the venue for the selected date.
*   **Admin Screen:**
    *   A secure admin panel accessible only to administrators.
    *   Features a `TabBar` to separate the "Add Venue" and "Import Venues" functionalities.
    *   Includes a navigation drawer for easy access to other parts of the app.
    *   **Add Venue:** A form for manually adding new venues to the database.
    *   **Import Venues:** Functionality to bulk import venues from JSON or CSV files.

## Current Plan

**Implement Admin-Only Access and UI/UX Overhaul**

1.  **Restrict Admin Privileges:**
    *   Create an `AuthService` to manage user roles and identify administrators.
    *   Update the UI to conditionally show admin-only features (e.g., the "Admin Panel" button) based on the user's role.
2.  **Redesign the User Interface:**
    *   Implement a modern, elegant, and professional UI with a navy blue color scheme.
    *   Use the `google_fonts` package to apply the "Poppins" font throughout the app.
    *   Redesign the `AuthScreen` with a modern layout, logo, and improved aesthetics.
    *   Restructure the `AdminScreen` with a `TabBar` to improve navigation and usability.
    *   Enhance the `VenueDetailScreen` with a more visually appealing layout and a clear call-to-action.
3.  **Ensure Code Quality and Consistency:**
    *   Add all necessary dependencies (`google_fonts`, `provider`).
    *   Format the entire codebase to ensure it adheres to Dart conventions.
    *   Update the `pubspec.yaml` file to use the latest package versions.
