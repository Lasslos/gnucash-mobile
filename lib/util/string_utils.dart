extension StringUtils on String {
  String capitalizeAndLower() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
