import 'package:http/http.dart' as http;
import 'dart:async';

void main() async {
  await makeGetRequest();
  await makeGetRequest();
  await makeGetRequest();
  await makeGetRequest();
  await makeGetRequest();
}

// Function to make a single GET request
Future<void> makeGetRequest() async {
  try {
    var response = await http.get(
      Uri.parse('https://www.omr8x.com/notes/get'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print("done");
    }
    print("error");
  } catch (e) {
    print(e);
  }
}
