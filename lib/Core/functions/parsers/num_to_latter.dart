String numberToLetter(int number) {
  if (number < 1 || number > 26) {
    throw RangeError('Number must be between 1 and 26');
  }

  return String.fromCharCode(64 + number);
}
