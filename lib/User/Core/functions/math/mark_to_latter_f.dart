String markToLatterFunction(double mark) {
  if (mark >= 0.95) {
    
    return 'A+';
  } else if (mark >= 0.90) {
    return 'A';
  } else if (mark >= 0.85) {
    return 'A-';
  } else if (mark >= 0.80) {
    return 'B+';
  } else if (mark >= 0.75) {
    return 'B';
  } else if (mark >= 0.70) {
    return 'B-';
  } else if (mark >= 0.65) {
    return 'C+';
  } else if (mark >= 0.60) {
    return 'C';
  } else if (mark >= 0.55) {
    return 'C-';
  } else if (mark >= 0.50) {
    return 'D+';
  } else if (mark >= 0.45) {
    return 'D';
  } else if (mark >= 0.40) {
    return 'D-';
  } else {
    return 'F';
  }
}
