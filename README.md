# Dcrap

Dcrap is a Flutter-based application designed to provide a seamless and rewarding user experience. The app integrates features like location services, user authentication, and a visually appealing UI to deliver value beyond waste.

---

## Table of Contents

- [Features](#features)
- [Demo Video](#demo-video)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Contributing](#contributing)

---

## Features

- **User Authentication**: Secure login/logout functionality using Riverpod state management.
- **Location Services**: Fetch and display the user's current location.
- **Dynamic UI**: Animated headlines and Lottie animations for an engaging user experience.
- **Cross-Platform Support**: Runs on Android, iOS, Windows, Linux, macOS, and web.
- **VIP Progress Tracking**: Track user progress with a visually appealing progress bar.

---

## Demo Video

[Watch the demo video here](https://drive.google.com/file/d/1eeRP_EpNa2AzXLpE2rKfKbDNk0wEDNcS/view?usp=drivesdk)

---

## Getting Started

### Prerequisites

Ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio or Xcode (for mobile development)
- Visual Studio (for Windows development)
- CMake (for Linux/macOS development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/dcrap.git
   cd dcrap
   ```
2. Install the dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

---

## Project Structure

```
.
├── lib/
│   ├── main.dart                     # Entry point of the application
│   ├── core/                         # Core functionality
│   │   ├── config/                   # Configuration files
│   │   │   └── firebase_options.dart # Firebase configuration
│   │   ├── constants/                # App constants
│   │   └── services/                 # Core services
│   └── features/                     # Feature modules
│       ├── addresses/                # Address management
│       ├── auth/                     # Authentication
│       │   ├── providers/            # Auth state providers
│       │   └── screens/              # Login/signup screens
│       ├── explore/                  # Explore feature
│       ├── home/                     # Home screen
│       │   └── screens/
│       ├── orders/                   # Order management
│       ├── profile/                  # User profile
│       ├── rates/                    # Rates feature
│       ├── sell_scrap/               # Sell scrap feature
│       └── wallet/                   # Wallet feature
├── assets/                           # Static assets
│   ├── delivery_animation.json       # Lottie animations
│   ├── lottie_machine.json
│   └── money_machine_lottie.json
├── android/                          # Android-specific files
├── ios/                              # iOS-specific files
├── pubspec.yaml                      # Dependencies
└── README.md                         # Project documentation
```

---

## Usage

1. **User Authentication**:
   - Navigate to the login or register view.
   - Enter your credentials and submit the form.
   - On successful authentication, you will be redirected to the home view.

2. **Location Services**:
   - Ensure location services are enabled on your device.
   - The app will automatically fetch and display your current location.

3. **VIP Progress Tracking**:
   - Complete tasks and activities within the app to earn VIP points.
   - Your progress will be displayed on the home view.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature`
3. Make your changes.
4. Commit your changes: `git commit -m 'Add your feature'`
5. Push to the branch: `git push origin feature/your-feature`
6. Submit a pull request.

---