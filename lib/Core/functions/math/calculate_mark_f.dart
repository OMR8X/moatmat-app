

import '../../../Features/result/domain/entities/result.dart';
import '../../../Features/tests/domain/entities/question.dart';

double calculateMarkFunction(Result r, List<Question> q) {
  double result = 0.0;
  
  for (int i = 0; i < q.length; i++) {
    final question = q[i];
    List<int?> correctAnswers = [];
    
    for (int j = 0; j < question.answers.length; j++) {
      if (question.answers[j].trueAnswer ?? false) {
        correctAnswers.add(j);
      }
    }
    
    // Check if i is a valid index in r.answers before accessing it
    if (i < r.answers.length && correctAnswers.contains(r.answers[i])) {
      result++;
    }
  }

  // Ensure division is done only if q.length is non-zero to avoid division by zero
  if (q.isNotEmpty) {
    result = (result / q.length);
  }

  // Formatting the result to two decimal places
  result = double.tryParse(result.toStringAsFixed(2)) ?? 0.0;
  
  return result;
}
