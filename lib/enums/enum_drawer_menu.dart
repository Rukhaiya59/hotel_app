enum EnumDrawerMenu {
  dashboard('home'),
  user('user'),
  room('room'),
  maintenance('maintenance'),
  discount("discount"),
  expense("expense"),
  booking('booking'),
  cleanOps("Clean Ops"),
  hotelLogs("Hotel Logs"),
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
