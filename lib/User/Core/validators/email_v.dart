String? emailValidator({required String? text, int? lenght}) {
  if (text == null) {
    return "لا يمكن ان يكون حقل الادخال فارغ";
  }
  if (text.isEmpty) {
    return "لا يمكن ان يكون حقل الادخال فارغ";
  }
  //
  final validCharacters = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (!validCharacters.hasMatch(text)) {
    String emailEx = 'example@gmail.com';
    return 'أستخدم بريد ألكتروني صالح $emailEx';
  }
  return null;
}
