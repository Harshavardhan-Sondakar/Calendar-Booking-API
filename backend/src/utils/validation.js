function validateBooking(data) {
  if (!data.userId || !data.startTime || !data.endTime) {
    return { error: 'Missing required fields' };
  }
  const start = new Date(data.startTime);
  const end = new Date(data.endTime);
  if (isNaN(start) || isNaN(end)) {
    return { error: 'Invalid date format' };
  }
  if (start >= end) {
    return { error: 'startTime must be before endTime' };
  }
  return {};
}

function isConflict(bookings, startTime, endTime) {
  const start = new Date(startTime);
  const end = new Date(endTime);
  return bookings.some(b => {
    const bStart = new Date(b.startTime);
    const bEnd = new Date(b.endTime);
    return (start < bEnd && end > bStart);
  });
}

module.exports = { validateBooking, isConflict };