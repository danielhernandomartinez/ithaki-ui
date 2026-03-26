/// Maps a language name to its ISO 639-1 two-letter code for flag display.
String langCode(String language) {
  const map = {
    'Spanish': 'es', 'English': 'gb', 'French': 'fr', 'German': 'de',
    'Italian': 'it', 'Portuguese': 'pt', 'Chinese': 'cn', 'Japanese': 'jp',
    'Korean': 'kr', 'Arabic': 'ae', 'Russian': 'ru', 'Dutch': 'nl',
    'Swedish': 'se', 'Norwegian': 'no', 'Danish': 'dk', 'Finnish': 'fi',
    'Polish': 'pl', 'Turkish': 'tr', 'Greek': 'gr', 'Hindi': 'in',
    'Catalan': 'es', 'Basque': 'es', 'Galician': 'es',
  };
  return map[language] ?? language.substring(0, 2).toLowerCase();
}
