String? notEmptyValidator({required String? text, int? lenght}) {
  if (text == null) {
    return "لا يمكن ان يكون حقل الادخال فارغ";
  }
  if (text.isEmpty) {
    return "لا يمكن ان يكون حقل الادخال فارغ";
  }
  if (lenght != null && text.length < lenght) {
    return "يجب ان لا يقل طول البيانات عن $lenght";
  }
  return null;
}
