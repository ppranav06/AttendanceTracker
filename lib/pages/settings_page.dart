import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return ListView(
            children: [
              CupertinoListSection.insetGrouped(
                header: const Text('ATTENDANCE'),
                hasLeading: false,
                children: [
                  CupertinoListTile(
                    title: const Text('Minimum Threshold'),
                    subtitle: const Text(
                      'Warn when attendance falls below this percentage',
                    ),
                    additionalInfo: Text(
                      '${state.attendanceThreshold}%',
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _editThreshold(context, state),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _editThreshold(BuildContext context, AppState state) {
    final controller = TextEditingController(
      text: state.attendanceThreshold.toString(),
    );
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Attendance Threshold'),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              const Text('Minimum attendance percentage to maintain.'),
              const SizedBox(height: 14),
              CupertinoTextField(
                controller: controller,
                keyboardType: TextInputType.number,
                placeholder: '0 – 100',
                textAlign: TextAlign.center,
                maxLength: 3,
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val >= 0 && val <= 100) {
                state.setAttendanceThreshold(val);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
