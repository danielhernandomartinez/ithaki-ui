import 'package:flutter_riverpod/flutter_riverpod.dart';

class CvPublishedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setPublished(bool value) => state = value;
}

final cvPublishedProvider =
    NotifierProvider<CvPublishedNotifier, bool>(CvPublishedNotifier.new);
