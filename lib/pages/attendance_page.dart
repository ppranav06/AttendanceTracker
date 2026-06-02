import 'package:flutter/cupertino.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Attendance'),
      ),
      child: SizedBox.expand(),
    );
  }
}
