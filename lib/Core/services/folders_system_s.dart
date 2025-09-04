class FoldersSystemService {
  //
  String path = '';
  //
  final Map<String, dynamic> directories;
  //
  final void Function(Map<String, dynamic> directories) onUpdate;

  FoldersSystemService({
    required this.directories,
    required this.onUpdate,
  });

  void addItemDirectory({required int item}) {
    //
    List<String> parts = path.split('/');
    //
    Map<String, dynamic> current = directories;
    //
    for (var part in parts) {
      if (current[part] == null) {
        return;
      }
      current = current[part] as Map<String, dynamic>;
    }
    //
    current['items'] ??= <int>[];
    ((current['items'] as List)).add(item);
    current['items'] = (current['items'] as List).toSet().toList();
    //
    onUpdate(directories);
  }

  void removeItemDirectory({required int item}) {
    //
    List<String> parts = path.split('/');
    //
    Map<String, dynamic> current = directories;
    //
    for (var part in parts) {
      if (current[part] == null) {
        return;
      }
      current = current[part] as Map<String, dynamic>;
    }
    //
    current['items'] ??= <int>[];
    //
    (current['items'] as List).remove(item);
    //
    onUpdate(directories);
  }

  void createDirectory({required String directory}) {
    //
    List<String> parts = ("$path/$directory").split('/');
    //
    Map<String, dynamic> current = directories;
    //

    for (var part in parts) {
      current[part] ??= <String, dynamic>{};
      current = current[part] as Map<String, dynamic>;
    }
    //
    onUpdate(directories);
  }

  void removeDirectory({required String directory}) {
    //
    List<String> parts = ("$path/$directory").split('/');
    //
    Map<String, dynamic> current = directories;

    // Traverse to the parent of the target directory
    for (int i = 0; i < parts.length - 1; i++) {
      if (current[parts[i]] == null) {
        return; // Directory does not exist
      }
      current = current[parts[i]] as Map<String, dynamic>;
    }

    // Remove the target directory
    current.remove(parts.last);
    //

    onUpdate(directories);
  }

  List<String> listAllDirectories() {
    //
    List<String> directoryList = [];
    //
    _traverseDirectories(directories, '', directoryList);
    //
    return directoryList;
  }

  void _traverseDirectories(Map<String, dynamic> currentDir, String path, List<String> directoryList) {
    //
    currentDir.forEach((key, value) {
      //
      String currentPath = path.isEmpty ? key : '$path/$key';
      //
      directoryList.add(currentPath);
      //
      if (value is Map<String, dynamic>) {
        _traverseDirectories(value, currentPath, directoryList);
      }
    });
  }

  ///
  List<int> getDirectoryItems() {
    //
    List<String> parts = path.split('/');
    //
    Map<String, dynamic> current = directories;
    //
    for (var part in parts) {
      if (current[part] == null) {
        return [];
      }
      current = current[part] as Map<String, dynamic>;
    }
    //
    return current['items'] != null ? List<int>.from(current['items']) : [];
  }

  ///
  List<int> getCustomDirectoryItems(String path) {
    //
    List<String> parts = path.split('/');
    //
    Map<String, dynamic> current = directories;
    //
    for (var part in parts) {
      if (current[part] == null) {
        return [];
      }
      current = current[part] as Map<String, dynamic>;
    }
    //
    return current['items'] != null ? List<int>.from(current['items']) : [];
  }

  ///
  List<String> getSubdirectories() {
    //

    //
    List<String> parts = path.split('/');
    Map<String, dynamic> current = directories;

    // Traverse to the target directory
    for (var part in parts) {
      if (current[part] == null) {
        return [];
      }
      current = current[part] as Map<String, dynamic>;
    }

    // Collect the subdirectories
    List<String> subdirectories = [];
    current.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        subdirectories.add(key);
      }
    });

    return subdirectories;
  }

  void pushPathForward({required String directory}) {
    path += "/$directory";
  }

  void popPathBack() {
    //
    List<String> folders = path.split("/");
    //
    folders.removeLast();
    //
    path = folders.join('/');
  }

  bool get canPop {
    return path.contains('/');
  }
}
