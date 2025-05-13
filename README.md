# Calendar Booking App

This project is a full-stack Calendar Booking API application built using Flutter for the frontend and Node.js for the backend. It allows users to view available meeting rooms and book them based on their availability.

## Project Structure

```
calendar-booking-app
├── backend
│   ├── src
│   │   ├── app.js
│   │   ├── controllers
│   │   │   └── bookingController.js
│   │   ├── models
│   │   │   └── booking.js
│   │   ├── routes
│   │   │   └── bookingRoutes.js
│   │   ├── middleware
│   │   │   └── auth.js
│   │   └── utils
│   │       └── db.js
│   ├── package.json
│   ├── .env
│   └── README.md
├── frontend
│   ├── lib
│   │   ├── main.dart
│   │   ├── screens
│   │   │   └── calendar_screen.dart
│   │   ├── widgets
│   │   │   └── booking_form.dart
│   │   └── services
│   │       └── api_service.dart
│   ├── pubspec.yaml
│   └── README.md
└── README.md
```

## Backend Setup

1. Navigate to the `backend` directory:
   ```
   cd backend
   ```

2. Install the required dependencies:
   ```
   npm install
   ```

3. Set up your environment variables in the `.env` file:
   ```
   MONGO_URI=mongodb://localhost:27017/calendar
   JWT_SECRET=your_jwt_secret
   ```

4. Start the server:
   ```
   node src/app.js
   ```

## Frontend Setup

1. Navigate to the `frontend` directory:
   ```
   cd frontend
   ```

2. Install the required dependencies:
   ```
   flutter pub get
   ```

3. Run the Flutter application:
   ```
   flutter run
   ```

## Features

- User authentication and authorization
- View available meeting rooms
- Create bookings with start and end times
- Conflict checking for bookings

## Technologies Used

- **Backend**: Node.js, Express, MongoDB
- **Frontend**: Flutter

