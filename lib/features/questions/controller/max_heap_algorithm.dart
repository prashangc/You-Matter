class MaxHeap<T> {
  final List<T> _heap;
  final Function(T, T) _compare;

  MaxHeap(this._compare) : _heap = [];

  void insert(T element) {
    _heap.add(element);
    _bubbleUp(_heap.length - 1);
  }

  T removeMax() {
    if (_heap.isEmpty) {
      throw StateError('Heap is empty');
    }

    final maxItem = _heap.first;
    final lastItem = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = lastItem;
      _sinkDown(0);
    }
    return maxItem;
  }

  void _bubbleUp(int index) {
    while (index > 0) {
      final parentIndex = (index - 1) ~/ 2;
      if (_compare(_heap[parentIndex], _heap[index]) >= 0) {
        break;
      }
      _swap(parentIndex, index);
      index = parentIndex;
    }
  }

  void _sinkDown(int index) {
    while (true) {
      final leftChildIndex = 2 * index + 1;
      final rightChildIndex = 2 * index + 2;
      int largestIndex = index;

      if (leftChildIndex < _heap.length &&
          _compare(_heap[leftChildIndex], _heap[largestIndex]) > 0) {
        largestIndex = leftChildIndex;
      }

      if (rightChildIndex < _heap.length &&
          _compare(_heap[rightChildIndex], _heap[largestIndex]) > 0) {
        largestIndex = rightChildIndex;
      }

      if (largestIndex == index) {
        break;
      }

      _swap(index, largestIndex);
      index = largestIndex;
    }
  }

  void _swap(int i, int j) {
    final temp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = temp;
  }

  bool isEmpty() {
    return _heap.isEmpty;
  }
}

class WordFrequency {
  final String word;
  final int frequency;

  WordFrequency(this.word, this.frequency);
}

List<String> findMostMatchingWords(List<String> words) {
  var wordCounts = <String, int>{};

  // Count occurrences of each word
  for (var word in words) {
    wordCounts[word] = (wordCounts[word] ?? 0) + 1;
  }

  // Use a max-heap to find the most repetitive words efficiently
  var maxHeap = MaxHeap<WordFrequency>((a, b) => a.frequency - b.frequency);
  for (var entry in wordCounts.entries) {
    maxHeap.insert(WordFrequency(entry.key, entry.value));
  }

  // Find words with the maximum count
  var mostRepetitiveWords = <String>[];
  var maxCount = maxHeap.removeMax().frequency;
  while (!maxHeap.isEmpty() && maxHeap._heap[0].frequency == maxCount) {
    mostRepetitiveWords.add(maxHeap.removeMax().word);
  }
  if (mostRepetitiveWords.isEmpty) {
    print('No matching categories found');
  }
  for (var element in mostRepetitiveWords) {
    print('The category found is: $element');
  }

  return mostRepetitiveWords;
}
