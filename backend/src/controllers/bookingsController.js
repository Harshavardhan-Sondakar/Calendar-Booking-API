const { validateBooking, isConflict } = require('../utils/validation');
const bookings = [];

exports.getAllBookings = (req, res) => {
  res.json(bookings);
};

exports.getBookingById = (req, res) => {
  const booking = bookings.find(b => b.id === req.params.id);
  if (!booking) return res.status(404).json({ error: 'Booking not found' });
  res.json(booking);
};

exports.createBooking = (req, res) => {
  const { error } = validateBooking(req.body);
  if (error) return res.status(400).json({ error });

  if (isConflict(bookings, req.body.startTime, req.body.endTime)) {
    return res.status(409).json({ error: 'Booking conflict detected' });
  }

  const newBooking = {
    id: `booking-${Date.now()}`,
    ...req.body,
  };
  bookings.push(newBooking);
  res.status(201).json(newBooking);
};

exports.updateBooking = (req, res) => {
  const booking = bookings.find(b => b.id === req.params.id);
  if (!booking) return res.status(404).json({ error: 'Booking not found' });

  const { userId, startTime, endTime } = req.body;
  if (!userId || !startTime || !endTime) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // Check for conflicts with other bookings
  const conflict = bookings.some(
    b =>
      b.id !== booking.id &&
      new Date(startTime) < new Date(b.endTime) &&
      new Date(endTime) > new Date(b.startTime)
  );
  if (conflict) {
    return res.status(409).json({ error: 'Booking conflict detected' });
  }

  booking.userId = userId;
  booking.startTime = startTime;
  booking.endTime = endTime;

  res.json(booking);
};

exports.deleteBooking = (req, res) => {
  const index = bookings.findIndex(b => b.id === req.params.id);
  if (index === -1) return res.status(404).json({ error: 'Booking not found' });

  bookings.splice(index, 1);
  res.json({ message: 'Booking deleted' });
};