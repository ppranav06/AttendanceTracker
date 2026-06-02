import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../providers/app_state.dart';

class SubjectFormPage extends StatefulWidget {
  final Subject? subject;

  const SubjectFormPage({super.key, this.subject});

  @override
  State<SubjectFormPage> createState() => _SubjectFormPageState();
}

class _SubjectFormPageState extends State<SubjectFormPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _scheduleCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.subject?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.subject?.code ?? '');
    _scheduleCtrl = TextEditingController(text: widget.subject?.schedule ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _scheduleCtrl.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.subject != null;

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Name Required'),
          content: const Text('Please enter a subject name.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final state = context.read<AppState>();
    if (_isEditing) {
      state.updateSubject(Subject(
        id: widget.subject!.id,
        name: name,
        code: _codeCtrl.text.trim(),
        schedule: _scheduleCtrl.text.trim(),
      ));
    } else {
      state.addSubject(Subject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        code: _codeCtrl.text.trim(),
        schedule: _scheduleCtrl.text.trim(),
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        middle: Text(_isEditing ? 'Edit Subject' : 'New Subject'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: ListView(
        children: [
          CupertinoFormSection.insetGrouped(
            header: const Text('SUBJECT DETAILS'),
            children: [
              CupertinoFormRow(
                prefix: const SizedBox(
                  width: 80,
                  child: Text('Name'),
                ),
                child: CupertinoTextField.borderless(
                  controller: _nameCtrl,
                  placeholder: 'e.g. Mathematics',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
              ),
              CupertinoFormRow(
                prefix: const SizedBox(
                  width: 80,
                  child: Text('Code'),
                ),
                child: CupertinoTextField.borderless(
                  controller: _codeCtrl,
                  placeholder: 'e.g. MATH201',
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                ),
              ),
              CupertinoFormRow(
                prefix: const SizedBox(
                  width: 80,
                  child: Text('Schedule'),
                ),
                child: CupertinoTextField.borderless(
                  controller: _scheduleCtrl,
                  placeholder: 'e.g. Mon/Wed 10:00 AM',
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
