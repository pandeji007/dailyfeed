# Daily Feed (ImmverseAI Assignment)

## Project Setup

1. **Prerequisites**
   - Flutter SDK (stable) installed.
   - Dart SDK 2.19+.
   - NewsData.io API key (see below).

2. **Clone / copy the project**

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure the API key**
   See the *App Configuration* section.
## App Configuration (`lib/app_config.dart`)

```dart
class ApiKey {
  // Replace the placeholder with your NewsData.io API key.
  static const String newsApiKey = 'YOUR_NEWSDATA_IO_API_KEY';
}
```

1. Open `lib/app_config.dart`.
2. Replace `YOUR_NEWSDATA_IO_API_KEY` with the key you obtain from NewsData.io.
3. Do **not** commit the real key to version control.

## How to Generate an API Key from NewsData.io

1. Visit **https://newsdata.io/** and sign up / log in.
2. After confirming your email, go to the **Dashboard**.
3. In the **API Keys** section, click **Create New Key**.
4. Copy the generated key (e.g., `pub_XXXXXXXXXXXXXXXXXXXXX`).
5. Paste it into `lib/app_config.dart` as shown above.

5. **Run the app**
   ```bash
   flutter run
   ```

## Folder Structure

```
dailyfeed/
├─ lib/
│  ├─ main.dart
│  ├─ app_config.dart   # Holds the NewsData.io API key
│  └─ … (other source files)
├─ assets/
├─ test/
├─ pubspec.yaml
└─ README.md
```

## Architecture Overview

- **Presentation** – Flutter widgets in `lib/` display the UI.
- **Data** – `NewsService` (uses `http`) fetches articles from NewsData.io, reading the API key from `AppConfig`.
- **Configuration** – `AppConfig` centralises constants.
- **State Management** – `provider` package supplies news data to the UI.

## Packages Used

| Package | Purpose |
|---|---|
| `flutter` | UI framework |
| `cupertino_icons` | iOS icons |
| `http` | HTTP client for NewsData.io |
| `provider` | Simple state‑management |
| `intl` *(optional)* | Date‑time formatting |


## Assumptions

- The project is a Flutter mobile/web app.
- Network connectivity to `newsdata.io` is available.
- No additional backend services are required.
- Provider is sufficient for state management.

*Happy coding!*