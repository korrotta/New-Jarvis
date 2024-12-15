// ignore_for_file: constant_identifier_names

enum Id {
  CLAUDE_3_HAIKU_20240307,
  CLAUDE_3_SONNET_20240229,
  GEMINI_15_FLASH_LATEST,
  GEMINI_15_PRO_LATEST,
  GPT_4_O,
  GPT_4_O_MINI
}

extension IdExtension on Id {
  String get value {
    switch (this) {
      case Id.CLAUDE_3_HAIKU_20240307:
        return 'claude-3-haiku-20240307';
      case Id.CLAUDE_3_SONNET_20240229:
        return 'claude-3-sonnet-20240229';
      case Id.GEMINI_15_FLASH_LATEST:
        return 'gemini-15-flash-latest';
      case Id.GEMINI_15_PRO_LATEST:
        return 'gemini-15-pro-latest';
      case Id.GPT_4_O:
        return 'gpt-4o';
      case Id.GPT_4_O_MINI:
        return 'gpt-4o-mini';
      default:
        return '';
    }
  }
}

extension IdName on Id {
  String get name {
    switch (this) {
      case Id.CLAUDE_3_HAIKU_20240307:
        return 'claude-3-haiku-20240307';
      case Id.CLAUDE_3_SONNET_20240229:
        return 'claude-3-sonnet-20240229';
      case Id.GEMINI_15_FLASH_LATEST:
        return 'gemini-15-flash-latest';
      case Id.GEMINI_15_PRO_LATEST:
        return 'gemini-15-pro-latest';
      case Id.GPT_4_O:
        return 'gpt-4o';
      case Id.GPT_4_O_MINI:
        return 'gpt-4o-mini';
      default:
        return '';
    }
  }
}
