enum Model {
  dify,
}

extension ModelExtension on Model {
  String get name {
    switch (this) {
      case Model.dify:
        return 'dify';
    }
  }
}
