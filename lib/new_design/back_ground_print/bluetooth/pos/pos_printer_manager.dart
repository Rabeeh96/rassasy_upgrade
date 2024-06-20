import 'package:easy_logger/easy_logger.dart';
export 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class PosPrinterManager {
  static EasyLogger logger = EasyLogger(
    name: 'pos_printer_manager',
    defaultLevel: LevelMessages.debug,
    enableBuildModes: [BuildMode.debug, BuildMode.profile, BuildMode.release],
    enableLevels: [
      LevelMessages.debug,
      LevelMessages.info,
      LevelMessages.error,
      LevelMessages.warning
    ],
  );
}
