# Project-ASE-RAG
This was an internal project started by my colleague and fellow tech partner Olivia Sharratt aka Liv, back in September 2024 she proposed to me an idea to create a RAG status to allow transparency and clarity on the readiness of the tech in the ASE space.

RAG Status Tracker - Flutter Project
📁 Project Structure
lib/
├── main.dart
├── models/
│   └── ticket_model.dart
└── screens/
    ├── login_screen.dart
    ├── register_screen.dart
    ├── dashboard_screen.dart
    ├── tickets_screen.dart
    └── create_ticket_screen.dart
🎨 Features Implemented
1. Authentication Screens

Login Screen (login_screen.dart)

Email and password validation
Smooth slide transition to dashboard
Link to register screen with fade transition


Register Screen (register_screen.dart)

Full name, email, and password fields
Form validation
Navigation back to login



2. Dashboard Screen (dashboard_screen.dart)

Status Overview Cards

Red, Amber, and Green ticket counts
Color-coded borders and icons
Descriptive text for each status


Quick Actions

View All Tickets (slide transition)
Create New Ticket (scale + fade transition)


Recent Activity

Last 3 tickets displayed
Status indicators
Platform and date information



3. Tickets List Screen (tickets_screen.dart)

Search Functionality

Search bar for filtering tickets


Filter by Status

Dialog with Red/Amber/Green/All options
Visual feedback for selected filter


Ticket Cards

Full ticket information display
Status badges with color coding
Assignee, platform, and date



4. Create Ticket Screen (create_ticket_screen.dart)

Form Fields

Title (required)
Platform dropdown
Status priority buttons (Red/Amber/Green)
Team member assignment with avatars
Description textarea (required)


Validation

All fields validated
Error messages via SnackBar
Success confirmation



5. Data Model (ticket_model.dart)

Ticket class with all properties
TicketStatus enum (red, amber, green)
Sample data generator for demo

🎭 Navigation & Transitions
Implemented Transitions:

Slide Transition: Login → Dashboard, Dashboard → Tickets
Fade Transition: Login ↔ Register, Dashboard → Login
Scale + Fade: Dashboard/Tickets → Create Ticket

🎨 Design System
Color Palette:

Primary: Indigo (#4F46E5)
Red Status: #EF4444
Amber Status: #F59E0B
Green Status: #10B981
Background: #F9FAFB
Text Primary: #1F2937
Text Secondary: #6B7280
Border: #D1D5DB

Typography:

Headings: Bold, 20-32px
Body: Regular, 14-16px
Small: Regular, 12px

📦 Dependencies Needed
Add these to your pubspec.yaml:
yamldependencies:
  flutter:
    sdk: flutter
  # No additional packages required! 
  # All features built with Flutter's core widgets
🚀 Getting Started

Create a new Flutter project:

bashflutter create rag_status_tracker
cd rag_status_tracker

Copy all the .dart files to their respective locations:

main.dart → lib/main.dart
ticket_model.dart → lib/models/ticket_model.dart
All screen files → lib/screens/


Update imports in each file to match your project structure:

dartimport 'package:rag_status_tracker/models/ticket_model.dart';
import 'package:rag_status_tracker/screens/login_screen.dart';
// etc...

Run the app:

bashflutter run
🎯 Key Features to Note
Form Validation

All forms include proper validation
Error messages displayed inline
Required fields enforced

State Management

Uses StatefulWidget for interactive screens
Proper disposal of controllers
Efficient state updates

Responsive Design

Works on mobile, tablet, and desktop
Proper use of SingleChildScrollView for smaller screens
Flexible layouts with Row, Column, and Expanded

User Experience

Loading indicators where appropriate
Success/error messages via SnackBar
Smooth animations between screens
Consistent color coding for ticket statuses

🔧 Customization Tips

Add Backend Integration: Replace sample data in ticket_model.dart with API calls
Add Authentication: Integrate Firebase Auth or your backend auth
Persistent Storage: Add local storage with shared_preferences or hive
Real-time Updates: Implement WebSocket or Firebase Realtime Database
Push Notifications: Add FCM for ticket updates

📱 Platform Support
This app is ready for:

✅ Android
✅ iOS
✅ Web
✅ Desktop (Windows, macOS, Linux)

All with the same codebase!