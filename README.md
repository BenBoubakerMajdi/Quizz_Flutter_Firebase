# TP3: Flutter & Firebase - Interactive Quiz Application

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)](https://firebase.google.com/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-brightgreen.svg)](https://dart.dev/)
[![BLoC](https://img.shields.io/badge/BLoC-9.1.1-purple.svg)](https://bloclibrary.dev/)

> A full-stack mobile quiz application with Firebase integration, featuring authentication, real-time database, cloud storage, and state management with BLoC pattern

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Firebase Setup](#firebase-setup)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [State Management](#state-management)
- [Firebase Integration](#firebase-integration)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project is a comprehensive mobile quiz application built with Flutter and Firebase. It demonstrates the integration of Firebase services with Flutter, implementing best practices for mobile development including clean architecture, state management, and user experience design.

### What Makes This Special?

- 🔥 **Full Firebase Integration** - Authentication, Firestore, Storage, and Analytics
- 🎨 **Modern UI/UX** - Beautiful, intuitive interface with smooth animations
- 🏗️ **Clean Architecture** - Separation of concerns with presentation, business logic, and data layers
- 🎵 **Rich Feedback** - Sound effects and Lottie animations for engaging user experience
- 📱 **Real-time Updates** - StreamBuilder for live data synchronization
- 🔐 **Secure Authentication** - Firebase Auth with email/password

### Quiz Categories

- 💪 **Fitness** - Test your knowledge about exercise and training
- 🥗 **Nutrition** - Learn about healthy eating habits
- 🧬 **Anatomie** - Explore human anatomy facts
- 🎲 **Aléatoire** - Random questions from all categories

## ✨ Features

### Core Functionality

#### 🔐 Authentication System
- **Sign Up** - Create new account with email and password validation
- **Sign In** - Secure login with Firebase Authentication
- **Session Management** - Persistent login state
- **Profile Management** - View and update user information
- **Password Reset** - Change password functionality
- **Logout** - Secure session termination

#### 📝 Quiz System
- **Category Selection** - Choose from 4 different quiz categories
- **Flexible Quiz Length** - Select 5, 10, 15, 20, or 25 questions
- **True/False Questions** - Simple, engaging question format
- **Visual Questions** - Each question includes an illustrative image
- **Immediate Feedback** - Visual indicators (✓/✗) for correct/incorrect answers
- **Score Tracking** - Real-time score display with icon indicators
- **Automatic Progression** - Smooth transition between questions
- **Final Score Screen** - Animated results with sound effects

#### 👤 User Profile
- **Avatar Upload** - Select and upload profile pictures from gallery
- **Avatar Display** - Profile picture visible in app bar with real-time updates
- **Image Compression** - Optimized storage with Base64 encoding
- **Profile Information** - Display user email and details
- **Account Settings** - Update password and preferences

#### ➕ Content Management
- **Add Questions** - Create new quiz questions with custom content
- **Image Selection** - Pick images from device gallery for questions
- **Category Management** - Add questions to existing or new categories
- **Dynamic Categories** - Automatically display new categories in selection
- **Question Validation** - Form validation for required fields
- **Real-time Updates** - New questions immediately available in quizzes

#### 🎮 User Experience
- **Smooth Animations** - Lottie animations for victory/defeat screens
- **Sound Effects** - Audio feedback for quiz completion
  - `win.mp3` - Victory sound for scores ≥ 50%
  - `loss.mp3` - Defeat sound for scores < 50%
- **Loading States** - Progress indicators during data fetching
- **Error Handling** - User-friendly error messages
- **Responsive UI** - Adapts to different screen sizes
- **Intuitive Navigation** - Clear flow between screens

## 🏗️ Architecture

The application follows **Clean Architecture** principles with separation into three main layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Pages (UI Components)                                 │  │
│  │ • home_page.dart          • quizz_page.dart          │  │
│  │ • category_selection.dart • score_page.dart          │  │
│  │ • add_question_page.dart  • user_profile_page.dart   │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  BUSINESS LOGIC LAYER                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ BLoC/Cubit (State Management)                         │  │
│  │ • QuizCubit - Manages quiz flow and state            │  │
│  │ • QuizState - Defines application states             │  │
│  │   - QuizLoading, QuizQuestionLoaded                  │  │
│  │   - QuizFinished, QuizError                          │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Repositories (Data Abstraction)                       │  │
│  │ • QuizRepository - Firestore operations              │  │
│  │                                                        │  │
│  │ Models (Data Entities)                                │  │
│  │ • Question - Quiz question entity                     │  │
│  │   - Firestore conversion methods                     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   FIREBASE SERVICES                          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ • Firebase Authentication - User management          │  │
│  │ • Cloud Firestore - Real-time database              │  │
│  │ • Firebase Storage - File storage (images/audio)     │  │
│  │ • Firebase Analytics - Usage tracking                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### Presentation Layer
- **Responsibility:** UI components and user interactions
- **Contains:** Screens, widgets, forms, and navigation logic
- **Communication:** Uses BlocBuilder/BlocListener to react to state changes

#### Business Logic Layer
- **Responsibility:** Application logic and state management
- **Contains:** Cubits/BLoCs that handle business rules
- **Communication:** Receives events from UI, emits states, calls repositories

#### Data Layer
- **Responsibility:** Data access and external service integration
- **Contains:** Repositories, models, data sources
- **Communication:** Abstracts Firebase operations, provides clean data interfaces

## 🛠️ Tech Stack

### Mobile Framework
- **Framework:** Flutter SDK 3.10+
- **Language:** Dart 3.0+
- **Platform:** Android (iOS support ready)

### State Management
- **Pattern:** BLoC (Business Logic Component)
- **Library:** `flutter_bloc: 9.1.1`
- **Provider:** `provider: ^6.1.5` (for dependency injection)

### Firebase Services
- **Core:** `firebase_core: ^4.3.0`
- **Authentication:** `firebase_auth: ^6.1.3`
- **Database:** `cloud_firestore: ^6.1.1`
- **Storage:** `firebase_storage: ^13.0.5`
- **Analytics:** `firebase_analytics: ^12.1.0`

### UI & Multimedia
- **Image Picker:** `image_picker: ^1.2.1` (Gallery access)
- **Audio Player:** `audioplayers: ^6.5.1` (Sound effects)
- **Animations:** `lottie: ^3.3.2` (Victory/defeat animations)
- **Icons:** Cupertino & Material Icons

### Utilities
- **HTTP Client:** `http: ^1.6.0`
- **Equatable:** `equatable: ^2.0.7` (Value equality)
- **Intl:** `intl: ^0.20.2` (Date formatting)

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

- **Flutter SDK 3.10+** - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK 3.0+** - Comes with Flutter
- **Android Studio** or **VS Code** with Flutter extensions
- **Java Development Kit (JDK) 17+** - For Android builds
- **Git** - For version control

### Firebase Account

- **Google Account** - For Firebase Console access
- **Firebase Project** - Create a new project at [Firebase Console](https://console.firebase.google.com/)

### Verify Installation

```bash
# Check Flutter installation
flutter --version
# Output: Flutter 3.10.x • Dart 3.0.x

# Check if Flutter is ready
flutter doctor
# Should show ✓ for Flutter, Android toolchain, and VS Code/Android Studio

# Check Dart installation
dart --version
# Output: Dart SDK version: 3.0.x

# Check connected devices
flutter devices
# Should show available emulators or connected phones
```

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/BenBoubakerMajdi/Quizz_Flutter_Firebase
cd tp3-flutter-firebase-quiz
```

### 2. Install Dependencies

```bash
# Install Flutter packages
flutter pub get

# If you encounter any issues, try:
flutter clean
flutter pub get
```

### 3. Configure Android Permissions

The app requires certain permissions that are already configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

### 4. Add Assets

Ensure the following asset directories exist and contain the necessary files:

```
assets/
├── images/
│   ├── profile_img.png
│   ├── logo_montpellier.png
│   ├── cardio.jpeg
│   ├── proteine.jpg
│   ├── devloppe_couche.png
│   ├── eau.png
│   └── etirement.png
├── animations/
│   ├── win.json
│   └── loss.json
└── sounds/
    ├── win.mp3
    └── loss.mp3
```

**Note:** You'll need to add your own Lottie animation files and sound effects.

## 🔥 Firebase Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project**
3. Enter project name: `flutter-quizz-app` (or your preferred name)
4. Disable Google Analytics (optional for this TP)
5. Click **Create Project**

### Step 2: Add Android App to Firebase

1. In Firebase Console, click the Android icon
2. Enter your package name: `com.example.tp1_quizz_app`
   ```bash
   # Find your package name in:
   # android/app/src/main/AndroidManifest.xml
   # Look for: package="com.example.tp1_quizz_app"
   ```
3. Download `google-services.json`
4. Place it in `android/app/` directory

### Step 3: Configure Firebase in Android

#### Update `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

#### Update `android/app/build.gradle`:

```gradle
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'dev.flutter.flutter-gradle-plugin'
    id 'com.google.gms.google-services'  // Add this line
}

android {
    compileSdk 34  // Ensure this is 34 or higher
    
    defaultConfig {
        minSdk 21  // Minimum Android version
        targetSdk 34
    }
}
```

### Step 4: Enable Firebase Services

#### Enable Authentication

1. In Firebase Console → **Authentication** → **Get Started**
2. Click **Sign-in method** tab
3. Enable **Email/Password** provider
4. Click **Save**

#### Enable Firestore Database

1. Go to **Firestore Database** → **Create Database**
2. Choose **Start in test mode** (for development)
3. Select your region (e.g., `europe-west1`)
4. Click **Enable**

#### Enable Firebase Storage

1. Go to **Storage** → **Get Started**
2. Choose **Start in test mode**
3. Click **Done**

### Step 5: Configure Firestore Security Rules

In Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Questions: Read for everyone, write for authenticated users
    match /questions/{questionId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Users: Users can only access their own documents
    match /users/{userId} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
    }
  }
}
```

### Step 6: Initialize Firebase in Flutter

The app already includes Firebase initialization in `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### Step 7: Populate Firestore with Sample Data

You can manually add sample questions via Firebase Console:

1. Go to **Firestore Database** → **Data** tab
2. Click **Start collection**
3. Collection ID: `questions`
4. Add documents with fields:
  - `text` (string): "Le squat travaille les quadriceps ?"
  - `isCorrect` (boolean): `true`
  - `imageUrl` (string): "https://example.com/image.jpg"
  - `category` (string): "Fitness"

Or use the app's "Add Question" feature after logging in!

## 📖 Usage

### Running the Application

```bash
# Run on connected device or emulator
flutter run

# Run in release mode (better performance)
flutter run --release

# Run with specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

### Basic Workflow

#### 1. Authentication

**First Time Users:**
1. Launch the app
2. Click **"Nouveau ici ? Inscrivez-vous !"**
3. Enter email and password (min 6 characters)
4. Click **CRÉER MON COMPTE**

**Existing Users:**
1. Enter your email and password
2. Click **SE CONNECTER**

#### 2. Take a Quiz

1. **Select Category** - Choose from Fitness, Nutrition, Anatomie, or Aléatoire
2. **Choose Quiz Length** - Select 5, 10, 15, 20, or 25 questions
3. **Answer Questions** - Tap VRAI or FAUX
4. **View Feedback** - See ✓ (green) or ✗ (red) instantly
5. **Automatic Progression** - App advances after 800ms
6. **View Results** - See your final score with animation and sound

#### 3. Manage Profile

1. Tap the **profile icon** in the app bar (category selection page)
2. **Upload Avatar:**
  - Tap the camera icon
  - Select image from gallery
  - Image is automatically compressed and uploaded
3. **Change Password:**
  - Enter new password (min 6 characters)
  - Click **CHANGER LE MOT DE PASSE**
4. **Logout:**
  - Click **SE DÉCONNECTER**

#### 4. Add New Questions

1. On the category selection page, tap the **+ button** (Floating Action Button)
2. Fill in the form:
  - **Image:** Tap the image placeholder to select from gallery
  - **Question Text:** Enter your question
  - **Category:** Choose existing or create new
  - **Correct Answer:** Toggle switch (VRAI/FAUX)
3. Click **ENREGISTRER LA QUESTION**
4. Question is immediately available in quizzes!

### Testing Different Scenarios

```bash
# Test user accounts (create these via the app):
Email: user1@test.com | Password: test123
Email: user2@test.com | Password: test123

# Test quiz flows:
1. Complete a quiz with all correct answers
2. Complete a quiz with all wrong answers
3. Mix correct and incorrect answers
4. Try different quiz lengths

# Test CRUD operations:
1. Add a question with image
2. Add a question to new category
3. Verify new category appears
4. Complete quiz from new category
```

## 📁 Project Structure

```
lib/
├── business_logic/
│   └── blocs/
│       ├── quizz_cubit.dart          # State management for quiz
│       └── quizz_state.dart          # Quiz state definitions
│
├── data/
│   ├── models/
│   │   └── question.dart             # Question entity with Firestore conversions
│   └── repositories/
│       └── quizz_repository.dart     # Data access layer for questions
│
├── presentation/
│   └── pages/
│       ├── home_page.dart            # Authentication screen (login/signup)
│       ├── category_selection_page.dart  # Quiz category selection
│       ├── quizz_page.dart           # Main quiz gameplay screen
│       ├── score_page.dart           # Results screen with animations
│       ├── add_question_page.dart    # Form to add new questions
│       └── user_profile_page.dart    # User profile management
│
├── firebase_options.dart             # Auto-generated Firebase config
└── main.dart                         # App entry point

android/
├── app/
│   ├── google-services.json          # Firebase configuration
│   ├── build.gradle                  # App-level Gradle config
│   └── src/main/
│       └── AndroidManifest.xml       # Permissions and app config
└── build.gradle                      # Project-level Gradle config

assets/
├── images/                           # Question images and profile pictures
├── animations/                       # Lottie JSON files
└── sounds/                           # Audio files (win/loss)

pubspec.yaml                          # Flutter dependencies
README.md                             # This file
```

### Key Files Explained

#### `lib/main.dart`
Entry point of the application. Initializes Firebase and sets up BLoC provider.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

#### `lib/business_logic/blocs/quizz_cubit.dart`
Manages quiz state and business logic:
- `loadQuestions()` - Fetches questions from Firestore
- `checkAnswer()` - Validates user answer
- `nextQuestion()` - Advances to next question
- `resetQuiz()` - Restarts quiz

#### `lib/data/repositories/quizz_repository.dart`
Abstracts Firestore operations:
- `getQuestions()` - Retrieves questions with optional filtering
- `addQuestion()` - Adds new question to database

#### `lib/data/models/question.dart`
Data model with Firestore conversion methods:
- `fromFirestore()` - Converts Firestore document to Question object
- `toFirestore()` - Converts Question object to Firestore document

## 🎮 State Management

The application uses the **BLoC (Business Logic Component)** pattern via `flutter_bloc` package.

### Quiz States

```dart
abstract class QuizState {
  final int currentQuestionIndex;
  final int score;
  final List<Icon> scoreKeeper;
  final bool answerWasChosen;
}
```

#### QuizLoading
- **When:** Initial state, loading questions from Firestore
- **UI:** Shows `CircularProgressIndicator`

#### QuizQuestionLoaded
- **When:** Question is ready to display
- **Contains:**
  - `currentQuestion` - The active question
  - `questions` - All questions in quiz
  - `currentQuestionIndex` - Progress tracker
  - `score` - Current score
  - `scoreKeeper` - Visual feedback icons
  - `answerWasChosen` - Prevents double-clicking

#### QuizFinished
- **When:** All questions answered
- **Contains:**
  - `score` - Final score
  - `total` - Total questions
- **Triggers:** Navigation to ScorePage

#### QuizError
- **When:** Firestore error or no questions found
- **Contains:** `message` - Error description

### State Flow

```
User Action → Cubit Method → State Change → UI Update

Example: Answering a Question
1. User taps "VRAI" button
2. QuizzPage calls: quizCubit.checkAnswer(true)
3. QuizCubit evaluates answer, updates score
4. Emits new QuizQuestionLoaded with:
   - Updated score
   - New icon in scoreKeeper
   - answerWasChosen = true (disables buttons)
5. After 800ms delay, calls nextQuestion()
6. If more questions: Emits QuizQuestionLoaded with next question
7. If no more questions: Emits QuizFinished
8. BlocListener detects QuizFinished
9. Navigates to ScorePage
```

### Using BLoC in UI

```dart
// Listening for state changes (navigation)
BlocListener<QuizCubit, QuizState>(
  listener: (context, state) {
    if (state is QuizFinished) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(
            score: state.score,
            totalQuestions: state.total,
          ),
        ),
      );
    }
  },
  child: ...
)

// Building UI based on state
BlocBuilder<QuizCubit, QuizState>(
  builder: (context, state) {
    if (state is QuizLoading) {
      return CircularProgressIndicator();
    }
    
    if (state is QuizError) {
      return Text(state.message);
    }
    
    if (state is QuizQuestionLoaded) {
      return QuestionWidget(question: state.currentQuestion);
    }
    
    return SizedBox.shrink();
  },
)
```

## 🔥 Firebase Integration

### Authentication

#### Sign Up
```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);
```

#### Sign In
```dart
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);
```

#### Sign Out
```dart
await FirebaseAuth.instance.signOut();
```

#### Check Current User
```dart
final user = FirebaseAuth.instance.currentUser;
if (user != null) {
  print('User ID: ${user.uid}');
  print('Email: ${user.email}');
}
```

### Firestore Database

#### Fetch All Questions
```dart
QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection('questions')
    .get();

List<Question> questions = snapshot.docs.map((doc) {
  return Question.fromFirestore(
    doc.data() as Map<String, dynamic>, 
    doc.id
  );
}).toList();
```

#### Fetch Questions by Category
```dart
QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection('questions')
    .where('category', isEqualTo: 'Fitness')
    .get();
```

#### Add New Question
```dart
await FirebaseFirestore.instance
    .collection('questions')
    .add({
  'text': 'Is Flutter awesome?',
  'isCorrect': true,
  'imageUrl': 'https://example.com/flutter.png',
  'category': 'Technology',
});
```

#### Real-time Updates with StreamBuilder
```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('questions')
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    
    final questions = snapshot.data!.docs;
    // Build UI with questions
  },
)
```

### Firebase Storage (Avatar Management)

#### Upload Avatar (Base64 Method)
```dart
// 1. Pick image
final XFile? pickedFile = await ImagePicker().pickImage(
  source: ImageSource.gallery,
  maxWidth: 400,
  imageQuality: 70,
);

// 2. Convert to Base64
final bytes = await pickedFile!.readAsBytes();
String base64Image = base64Encode(bytes);

// 3. Save to Firestore
await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .set({
  'photoBase64': base64Image,
  'email': user.email,
}, SetOptions(merge: true));
```

#### Display Avatar with Real-time Updates
```dart
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .snapshots(),
  builder: (context, snapshot) {
    ImageProvider? bgImage;
    
    if (snapshot.hasData && snapshot.data!.exists) {
      final data = snapshot.data!.data() as Map<String, dynamic>?;
      
      if (data != null && data['photoBase64'] != null) {
        bgImage = MemoryImage(base64Decode(data['photoBase64']));
      }
    }
    
    return CircleAvatar(
      backgroundImage: bgImage,
      child: bgImage == null ? Icon(Icons.person) : null,
    );
  },
)
```

## 🔌 API Reference

### Firestore Collections

#### `questions` Collection

**Document Structure:**
```json
{
  "id": "auto-generated",
  "text": "Le squat travaille les quadriceps ?",
  "isCorrect": true,
  "imageUrl": "https://cdn.pixabay.com/photo/...",
  "category": "Fitness"
}
```

**Queries:**

```dart
// Get all questions
FirebaseFirestore.instance.collection('questions').get()

// Filter by category
FirebaseFirestore.instance
  .collection('questions')
  .where('category', isEqualTo: 'Fitness')
  .get()

// Add question
FirebaseFirestore.instance
  .collection('questions')
  .add(questionMap)
```

#### `users` Collection

**Document Structure:**
```json
{
  "uid": "firebase-auth-uid",
  "email": "user@example.com",
  "photoBase64": "base64-encoded-image-string"
}
```

**Queries:**

```dart
// Get user profile
FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .get()

// Update avatar
FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .set({'photoBase64': base64String}, SetOptions(merge: true))

// Delete avatar
FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({'photoBase64': FieldValue.delete()})
```

### Repository Methods

#### QuizRepository

```dart
class QuizRepository {
  // Fetch questions with optional filtering
  Future<List<Question>> getQuestions({
    String? category,  // Filter by category
    int? limit,        // Limit number of questions
  })
  
  // Add new question
  Future<void> addQuestion(Question question)
}
```

**Usage Examples:**

```dart
final repository = QuizRepository();

// Get all Fitness questions
final fitnessQuestions = await repository.getQuestions(
  category: 'Fitness',
);

// Get 10 random questions
final randomQuestions = await repository.getQuestions(
  category: 'Aléatoire',
  limit: 10,
);

// Add new question
await repository.addQuestion(Question(
  id: '',
  questionText: 'New question?',
  isCorrect: true,
  imageUrl: 'https://...',
  category: 'Nutrition',
));
```

## 👨‍💻 Author

**Majdi Benboubaker**
- GitHub: [@majdiBenboubaker](https://github.com/majdiBenboubaker)
- Email: majdi.benboubaker@outlook.fr

⭐ If you found this project helpful, please give it a star!