# Venue Booking App

This is a Flutter-based mobile application for browsing and booking various venues like resorts, corporate halls, banquets, and marquees. It features separate interfaces for users and administrators, providing a seamless experience for both.

## Features

### For Users:

*   **Browse Venues:** View a comprehensive list of available venues with detailed descriptions, images, and categories.
*   **Filter by Category:** Easily filter venues by categories such as Resort, Corporate Hall, Banquet, and Marquee.
*   **Check Availability:** Select a date to see if a venue is available or already booked.
*   **Book a Venue:** Securely book a venue for a specific date. The booking is linked to the user's email.
*   **Instant WhatsApp Notification:** After a successful booking, the app automatically opens WhatsApp with a pre-filled message to the business, confirming the reservation details.

### For Administrators:

*   **Admin Panel:** A secure admin panel to manage the app's content.
*   **Add Venues:** Easily add new venues with details like name, description, image URL, and category through a user-friendly form.
*   **Manage Venues:** View a list of all existing venues. Admins can edit the details of a venue or delete it entirely.
*   **Import Venues:** Quickly populate the venue list by importing data from JSON or CSV files.
*   **Manage Bookings:** A dedicated screen to view all bookings made by users. Admins can see the venue, booking date, and user email for each reservation and have the option to cancel bookings if necessary.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
*   A code editor like VS Code or Android Studio.
*   A configured Firebase project.

### Installation

1.  **Clone the repo**

    ```sh
    git clone https://github.com/your_username/venue-booking-app.git
    ```

2.  **Navigate to the project directory**

    ```sh
    cd venue-booking-app
    ```

3.  **Install packages**

    ```sh
    flutter pub get
    ```

4.  **Set up Firebase**

    *   Follow the instructions to add Firebase to your Flutter app: [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup)
    *   Ensure you have Firestore and Firebase Authentication enabled in your Firebase console.

5.  **Run the app**

    ```sh
    flutter run
    ```

## Key Dependencies

*   **`firebase_core`**: For initializing the Firebase app.
*   **`firebase_auth`**: For handling user authentication (login, logout).
*   **`cloud_firestore`**: For interacting with the Firestore database to store and retrieve venue and booking data.
*   **`provider`**: For state management and dependency injection.
*   **`url_launcher`**: For opening external URLs, used here to launch WhatsApp.
*   **`file_picker` & `csv`**: For importing venue data from local files.
*   **`google_fonts`**: For custom typography and a polished UI.

## Project Structure

The project is organized into the following main directories:

*   `lib/models`: Contains the data models for `Venue` and `Booking`.
*   `lib/screens`: Includes all the UI screens for both the user and admin sections.
*   `lib/services`: Holds the `AuthService` and `FirestoreService` to handle business logic and backend communication.
*   `lib/widgets`: For reusable UI components.
