# Calendar Booking API Project

## Overview
This project is a full-stack Calendar Booking application built with Flutter for the frontend and Node.js for the backend. It allows users to view available meeting rooms and book them based on their availability.

## Backend Setup

### Prerequisites
- Node.js (version 14 or higher)
- MongoDB (running locally or remotely)

### Installation
1. Navigate to the `backend` directory:
   ```
   cd calendar-booking-app/backend
   ```

2. Install the dependencies:
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
   npm start
   ```

### API Endpoints
- `GET /bookings`: Retrieve all bookings.
- `GET /bookings/:id`: Retrieve a booking by ID.
- `POST /bookings`: Create a new booking.
- `PUT /bookings/:id`: Update an existing booking.
- `DELETE /bookings/:id`: Delete a booking.

## Frontend Setup

### Prerequisites
- Flutter SDK (version 2.0 or higher)

### Installation
1. Navigate to the `frontend` directory:
   ```
   cd calendar-booking-app/frontend
   ```

2. Install the dependencies:
   ```
   flutter pub get
   ```

3. Run the application:
   ```
   flutter run
   ```