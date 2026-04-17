// ---------------------------------------------------------------------------
// Career Assistant — data models
// ---------------------------------------------------------------------------

enum MsgType { user, ai }

enum AiVariant { text, textWithChips, articles, jobs }

class ArticleData {
  final String title;
  final String excerpt;
  final String author;
  final String time;
  const ArticleData({
    required this.title,
    required this.excerpt,
    required this.author,
    required this.time,
  });
}

class JobData {
  final String company;
  final String title;
  final String salary;
  final int matchPct;
  final String matchLabel;
  const JobData({
    required this.company,
    required this.title,
    required this.salary,
    required this.matchPct,
    required this.matchLabel,
  });
}

class ChatMessage {
  final MsgType type;
  final String text;
  final AiVariant variant;
  final List<String> chips;
  final List<ArticleData> articles;
  final List<JobData> jobs;

  const ChatMessage({
    required this.type,
    required this.text,
    this.variant = AiVariant.text,
    this.chips = const [],
    this.articles = const [],
    this.jobs = const [],
  });
}
