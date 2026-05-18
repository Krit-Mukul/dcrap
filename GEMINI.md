# DCrap - Smart Scrap Selling Platform

## Project Overview

DCrap is a platform for selling scrap, facilitating eco-friendly recycling. It allows users to schedule pickups, get price estimates for various types of scrap (Newspaper, Cardboard, Plastic, Metal, E-waste), and manage their scrap selling process. 

The project is structured as a monorepo containing multiple components:
1.  **Frontend Application:** A multi-platform mobile and web application built with Flutter and Dart.
2.  **Backend API:** A RESTful API built with Node.js, Express, and MongoDB.
3.  **Landing Page:** A static informational website for the product.

### Key Technologies

*   **Frontend (Flutter):**
    *   **Language:** Dart
    *   **State Management:** Riverpod (`flutter_riverpod`)
    *   **Backend as a Service (BaaS):** Firebase (Auth, Firestore, Storage)
    *   **Environment Variables:** `flutter_dotenv`
    *   **UI/UX:** Material Design 3, Lottie animations, `fl_chart` for charts.
*   **Backend (`dcrap_backend/`):**
    *   **Runtime:** Node.js
    *   **Framework:** Express.js
    *   **Database:** MongoDB (via Mongoose)
    *   **Authentication:** Firebase Admin SDK
*   **Landing Page (`landing_page/`):**
    *   HTML5, CSS3, Vanilla JavaScript.

## Directory Structure

*   **`/lib`**: The core Flutter application source code. It follows a feature-based architecture (e.g., `features/auth`, `features/home`, `features/orders`). The entry point is `lib/main.dart`.
*   **`/dcrap_backend`**: The Node.js API server. Contains routes, controllers, and models (Mongoose schemas) for users, orders, and rates. The main entry point is `server.js`.
*   **`/landing_page`**: The static website code.
*   **`/assets`**: Contains Lottie animations and other static assets used by the Flutter app.
*   **`/android`, `/ios`**: Platform-specific configuration for the Flutter application.

## Building and Running

### Frontend (Flutter)

1.  Ensure you have Flutter SDK installed and environment variables configured (`.env`).
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    ```bash
    flutter run
    ```

### Backend (Node.js)

1.  Navigate to the backend directory:
    ```bash
    cd dcrap_backend
    ```
2.  Install Node dependencies:
    ```bash
    npm install
    ```
3.  Ensure your environment variables (`.env`) are configured for MongoDB and Firebase.
4.  Run the development server (uses `nodemon`):
    ```bash
    npm run dev
    ```
    *Alternatively, for production:* `npm start`

## Development Conventions

*   **Architecture (Frontend):** The Flutter app utilizes a feature-driven folder structure (`core` for shared utilities and services, `features` for isolated modules). Riverpod is used for state management.
*   **Architecture (Backend):** The Node.js app uses an MVC-like pattern with isolated `routes`, `controllers`, and Mongoose `models`. Authentication is handled via Firebase middleware (`middleware/auth.js`).
*   **Environment Management:** Both the Flutter app and Node.js backend rely on `.env` files for sensitive configuration (ensure these are not committed to source control).
