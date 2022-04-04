import 'package:file_picker/file_picker.dart';

List<String> acceptedCompressed = ['.zip', '.rar', '.7z'];

Future<String?> pickFile() async {
  var result = await FilePicker.platform.pickFiles(
    dialogTitle: "Select a game to add",
    allowMultiple: false,
    allowedExtensions: ['.exe'],
    type: FileType.any,
  );
  if (result != null && result.files.single.extension == "exe") {
    return result.files.single.path!;
  } else {
    return null;
  }
}

Future<String> pickFolder() async {
  return await FilePicker.platform.getDirectoryPath() ?? "";
}
