class UpdateInfo {
  //
  final int appVersion;
  final int currentVersion;
  final int minimumVersion;
  final String app;
  //

  UpdateInfo({
    required this.appVersion,
    required this.currentVersion,
    required this.minimumVersion,
    required this.app,
  });
  //
  String getVersionText() {
    //
    List<String> letters = appVersion.toString().split("");
    //
    String txt = "";
    //
    for (int i = 0; i < letters.length; i++) {
      if (i == 1 || i == 2) {
        txt += ".";
      }
      txt += letters[i];
    }
    //
    return txt;
  }

  //
  UpdateInfo copyWith({
    int? appVersion,
    int? currentVersion,
    int? minimumVersion,
    String? app,
  }) {
    return UpdateInfo(
      appVersion: appVersion ?? this.appVersion,
      currentVersion: currentVersion ?? this.currentVersion,
      minimumVersion: minimumVersion ?? this.minimumVersion,
      app: app ?? this.app,
    );
  }
}
