
import '../../Features/tests/domain/entities/outer_test.dart';

PaperType stringToPaperType(String paperType) {
  switch (paperType) {
    case 'A4':
      return PaperType.A4;
    case 'A5':
      return PaperType.A5;
    case 'A6':
      return PaperType.A6;
    default:
      return PaperType.A4;
  }
}
