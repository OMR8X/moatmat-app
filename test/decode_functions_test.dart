import 'package:flutter_test/flutter_test.dart';
import 'package:moatmat_app/User/Core/functions/coders/decode.dart';

void main() {
  group('decodeFileName', () {
    test('should correctly decode a complex file name', () {
      const String encodedFileName =
          'Day____2024____20____D8____AD____D8____A7____D9____84____D8____AA____D9____83____20____D8____AE____D8____B7____D8____B1____D8____A9____20____D8____A7____D9____86____D8____AA____20______D8____A7____D8____A8____D9____88_____D9____86____D9____85____D8____B1____20_____D8____AE____D9____88____D8____B4_tv____20____20_____D8____AE____D9____88____D8____B4_____D8____B3____D9____88____D8____A7____D9____84____D9____81____20_____D8____B9____D9____84____D9____8A_____D8____B3____D9____84____D8____A7____D9____85____20_____D8____B9____D9____84____D9____8A_____D8____B1____D9____8A____D8____AF____D9____87____D8____A7(MP4).mp4.mp4';
      final String decodedFileName = decodeFileName(encodedFileName);
      print(decodedFileName);
    });
  });
}
