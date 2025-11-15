enum EnumRole {
  manager('Manager'),
  receptionist('Receptionist'),
  housekeeping('Housekeeping'),
  owner('Owner'),
  accountant('Accountant');

  const EnumRole(this.value);
  final String value;
}
