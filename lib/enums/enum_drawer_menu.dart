enum EnumDrawerMenu {
  dashboard('home'),
  user('user'),
  room('room'),
  maintenance('maintenance'),
  // task('task'),
  // lostFound('lost_found'),
  booking('booking'),
  bookingHistory('booking_history'),
  inventory('inventory'),
  setting('setting'),
  logout('logout'),
  comingSoon('coming_soon'),
  tax('tax');

  const EnumDrawerMenu(this.value);
  final String value;
}
