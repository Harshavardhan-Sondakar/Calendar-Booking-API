# Calendar Booking App

This project is a full-stack Calendar Booking API application built using Flutter for the frontend and Node.js for the backend. It allows users to view and book available meeting rooms.

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

1. Navigate to the `backend` directory.
2. Install dependencies using npm:
   ```
   npm install
   ```
3. Create a `.env` file in the `backend` directory with the following content:
   ```
   MONGO_URI=mongodb://localhost:27017/calendar
   JWT_SECRET=your_jwt_secret
   ```
4. Start the server:
   ```
   node src/app.js
   ```

## Frontend Setup

1. Navigate to the `frontend` directory.
2. Install dependencies using Flutter:
   ```
   flutter pub get
   ```
3. Run the application:
   ```
   flutter run
   ```

## Features

- View available meeting rooms.
- Book meeting rooms by providing user ID, start time, and end time.
- Authentication for secure access to booking features.

## Technologies Used

- **Frontend:** Flutter
- **Backend:** Node.js, Express
- **Database:** MongoDB

## Contributing

Feel free to fork the repository and submit pull requests for any improvements or bug fixes.