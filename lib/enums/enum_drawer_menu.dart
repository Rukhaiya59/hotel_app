enum EnumDrawerMenu {
  dashboard('home'),
  user('user'),
  room('room'),
  maintenance('maintenance'),

  housekeeping("housekeeping"),
  discount("discount"),
  expense("expense"),
  booking('booking'),
  bookingHistory('booking_history'),
  inventory('inventory'),
  setting('setting'),
  logout('logout'),
  report('report'),
  comingSoon('coming_soon'),
  reservation('reservation'),
  cleaning('cleaning history'),
  guest('guest'),
  createTax('createTax');

  const EnumDrawerMenu(this.value);
  final String value;
}
