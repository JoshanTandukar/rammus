enum Flavor {
  DEV,
  STAGING,
  PRODUCTION,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'Dev';
      case Flavor.STAGING:
        return 'Staging';
      case Flavor.PRODUCTION:
        return 'Production';
      default:
        return 'Production';
    }
  }

}
