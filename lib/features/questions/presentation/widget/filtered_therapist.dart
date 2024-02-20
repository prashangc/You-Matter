import 'package:flutter/material.dart';
import 'package:you_matter/features/home/presentation/widgets/therapist.dart';

class FilteredTherapist extends StatefulWidget {
  final List<String> categoryList;
  const FilteredTherapist({super.key, required this.categoryList});

  @override
  State<FilteredTherapist> createState() => _FilteredTherapistState();
}

class _FilteredTherapistState extends State<FilteredTherapist> {
  List<String> filteredCategories = [];
  @override
  void initState() {
    super.initState();
    method();
  }

  method() async {
    filteredCategories = findMostRepetitiveWords(widget.categoryList);
  }

  List<String> findMostRepetitiveWords(List<String> words) {
    Map<String, int> wordCounts = {};

    // Count occurrences of each word
    for (String word in words) {
      if (wordCounts.containsKey(word)) {
        wordCounts[word] = wordCounts[word]! + 1;
      } else {
        wordCounts[word] = 1;
      }
    }

    // Find the maximum count
    int maxCount = 0;
    wordCounts.forEach((word, count) {
      if (count > maxCount) {
        maxCount = count;
      }
    });

    // Find words with the maximum count
    List<String> mostRepetitiveWords = [];
    wordCounts.forEach((word, count) {
      if (count == maxCount) {
        mostRepetitiveWords.add(word);
      }
    });

    return mostRepetitiveWords;
  }

  @override
  Widget build(BuildContext context) {
    return therapistCard(context,
        isChat: true, filteredCategories: filteredCategories);
  }
}
