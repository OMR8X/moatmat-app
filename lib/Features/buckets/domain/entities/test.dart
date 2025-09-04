import 'package:equatable/equatable.dart';

/// Entity representing a test in the application.
///
/// This entity contains all the information about a test, including
/// its metadata and content.
class Test extends Equatable {
  /// Unique identifier for the test
  final int id;
  
  /// Title of the test
  final String title;
  
  /// Description of the test
  final String description;
  
  /// List of questions in the test
  final List<dynamic> questions;
  
  /// Additional test content and materials
  final Map<String, dynamic> content;
  
  /// Creates a new [Test] instance.
  const Test({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.content,
  });
  
  @override
  List<Object?> get props => [id, title, description, questions, content];
}