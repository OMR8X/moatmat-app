import 'package:moatmat_app/User/Core/functions/coders/decode.dart';

class RetrieveAssetRequest {
  final String fileName;
  final String fileRepositoryId;

  RetrieveAssetRequest({
    required this.fileRepositoryId,
    required this.fileName,
  });

  factory RetrieveAssetRequest.fromSupabaseLink(String supabaseLink) {
    final fileName = decodeFileNameKeepExtension(supabaseLink.split("/").last);
    return RetrieveAssetRequest(
      fileRepositoryId: supabaseLink.split("/").firstWhere((e) => int.tryParse(e) != null),
      fileName: fileName,
    );
  }
}
