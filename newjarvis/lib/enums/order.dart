enum Order {
  ASC,
  DESC,
}

extension ModelExtension on Order {
  String get name {
    switch (this) {
      case Order.ASC:
        return 'ASC';
      case Order.DESC:
        return 'DESC';
    }
  }
}
