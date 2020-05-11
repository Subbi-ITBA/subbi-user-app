import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements HttpClient {}

main() {

  // group('login', () {

  //   test('Returns true if user exists', () async {
  //     final client = MockClient();

  //     // Use Mockito to return a successful response when it calls the
  //     // provided http.Client.
  //     when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
  //         .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

  //     expect(await fetchPost(client), const TypeMatcher<Post>());
  //   });

  //   test('throws an exception if the http call completes with an error', () {
  //     final client = MockClient();

  //     // Use Mockito to return an unsuccessful response when it calls the
  //     // provided http.Client.
  //     when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
  //         .thenAnswer((_) async => http.Response('Not Found', 404));

  //     expect(fetchPost(client), throwsException);
  //   });
  // });

}