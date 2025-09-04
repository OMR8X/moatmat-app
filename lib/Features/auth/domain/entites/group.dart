
import 'group_item.dart';

class Group {
  final int id;
  final String name;
  final String classRoom;
  final List<GroupItem> items;
  final List<int> testsIds;

  Group({
    required this.id,
    required this.name,
    required this.classRoom,
    required this.items,
    required this.testsIds,
  });

  Group copyWith({
    int? id,
    String? name,
    String? classRoom,
    List<GroupItem>? items,
    List<int>? testsIds,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      classRoom: classRoom ?? this.classRoom,
      testsIds: testsIds ?? this.testsIds,
    );
  }

  factory Group.empty() {
    return Group(
      id: 0,
      name: '',
      classRoom: '',
      items: [],
      testsIds: [],
    );
  }
}
