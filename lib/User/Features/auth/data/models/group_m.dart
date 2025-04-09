import '../../domain/entites/group.dart';
import '../../domain/entites/group_item.dart';
import 'group_item_m.dart';

class GroupModel extends Group {
  GroupModel({
    required super.id,
    required super.name,
    required super.items,
    required super.classRoom,
    required super.testsIds,
  });

  factory GroupModel.fromJson(Map json) {
    List itemsJson = json["items"];
    return GroupModel(
      id: json["id"],
      name: json["name"],
      classRoom: json["classRoom"] ?? "",
      testsIds: json["tests_ids"]?.cast<int>() ?? <int>[],
      items: List.generate(itemsJson.length, (index) {
        return GroupItemModel.fromJson(itemsJson[index]);
      }),
    );
  }
  factory GroupModel.fromClass(Group group) {
    return GroupModel(
      id: group.id,
      name: group.name,
      classRoom: group.classRoom,
      items: group.items,
      testsIds: group.testsIds,
    );
  }

  Map<String, dynamic> toJson() {
    final list = filterDuplicatedItems(items);
    return {
      "id": id,
      "name": name,
      "classRoom": classRoom,
      "tests_ids": testsIds,
      "items": List.generate(list.length, (index) {
        return GroupItemModel.fromClass(list[index].copyWith(id: index)).toJson();
      }),
    };
  }

  List<GroupItem> filterDuplicatedItems(List<GroupItem> items) {
    //
    Set<String> uuids = {};
    //
    List<GroupItem> list = [];
    //
    for (var item in items) {
      if (!uuids.contains(item.userData.uuid)) {
        list.add(item);
        uuids.add(item.userData.uuid);
      }
    }
    //
    return list;
  }
}
