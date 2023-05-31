class Utils {
  static String snakeCaseToCamelCase(String snakeCase) {
    List<String> parts = snakeCase.split('_');
    String camelCase = parts[0];

    for (int i = 1; i < parts.length; i++) {
      String capitalized =
          parts[i].substring(0, 1).toUpperCase() + parts[i].substring(1);
      camelCase += capitalized;
    }

    return camelCase;
  }
}
