enum Flavor {
  development('DEVELOPMENT', 'DEV '),
  staging('STAGING', 'STG '),
  production('PRODUCTION', '');

  const Flavor(this.description, this.title);
  final String description;
  final String title;
}
