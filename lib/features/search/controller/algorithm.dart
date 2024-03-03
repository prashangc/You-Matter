List<dynamic> findTherapistsByKeyword(List<dynamic> therapist, String keyword) {
  List<dynamic> filteredTherapists = therapist.where((element) {
    String therapistUsername = element.data()['username'];
    double similarity = calculateJaccardSimilarity(therapistUsername, keyword);
    // Direct match
    bool isDirectMatch =
        therapistUsername.toLowerCase().startsWith(keyword.toLowerCase());
    return similarity >= 0.5 || isDirectMatch;
  }).toList();
  print(filteredTherapists.length);
  return filteredTherapists;
}

// Function to calculate Jaccard similarity between two sets of characters
double calculateJaccardSimilarity(String a, String b) {
  Set<String> setA = a.split('').toSet();
  Set<String> setB = b.split('').toSet();

  // Calculate intersection and union sizes
  int intersectionSize = setA.intersection(setB).length;
  int unionSize = setA.union(setB).length;

  // Calculate Jaccard similarity
  double similarity = intersectionSize / unionSize;
  return similarity;
}



// int calculateLevenshteinDistance(String keyword, String therapistName) {
//   // Initialize a matrix with dimensions (a.length + 1) x (b.length + 1)
//   List<List<int>> matrix = List.generate(
//     keyword.length + 1,
//     (row) => List<int>.filled(therapistName.length + 1, 0),
//   );

//   // Initialize the first row and column of the matrix
//   for (int i = 0; i <= keyword.length; i++) {
//     matrix[i][0] = i;
//   }
//   for (int j = 0; j <= therapistName.length; j++) {
//     matrix[0][j] = j;
//   }

//   // Fill the matrix
//   for (int i = 1; i <= keyword.length; i++) {
//     for (int j = 1; j <= therapistName.length; j++) {
//       int cost = keyword[i - 1] == therapistName[j - 1] ? 0 : 1;
//       matrix[i][j] = (matrix[i - 1][j] + 1) // Deletion
//           .compareTo(matrix[i][j - 1] + 1) // Insertion
//           .compareTo(matrix[i - 1][j - 1] + cost); // Substitution
//     }
//   }

//   // Return the bottom-right cell of the matrix
//   return matrix[keyword.length][therapistName.length];
// }
