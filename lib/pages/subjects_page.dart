import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../providers/app_state.dart';
import 'subject_form_page.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Subjects'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _openForm(context, null),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: Consumer<AppState>(
        builder: (context, state, _) {
          final subjects = state.subjects;
          if (subjects.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            itemCount: subjects.length,
            separatorBuilder: (context, _) => Container(
              height: 0.5,
              margin: const EdgeInsets.only(left: 16),
              color: CupertinoColors.separator.resolveFrom(context),
            ),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Dismissible(
                key: Key(subject.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: CupertinoColors.destructiveRed,
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.white,
                  ),
                ),
                confirmDismiss: (_) => _confirmDelete(context, subject),
                onDismissed: (_) => state.deleteSubject(subject.id),
                child: CupertinoListTile(
                  title: Text(subject.name),
                  subtitle: subject.schedule.isNotEmpty
                      ? Text(
                          subject.schedule,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 13,
                          ),
                        )
                      : null,
                  additionalInfo: subject.code.isNotEmpty
                      ? Text(
                          subject.code,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 13,
                          ),
                        )
                      : null,
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _openForm(context, subject),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Subject subject) async {
    bool confirmed = false;
    await showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Remove "${subject.name}"?'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              confirmed = true;
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed;
  }

  void _openForm(BuildContext context, Subject? subject) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => SubjectFormPage(subject: subject),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.book,
            size: 56,
            color: CupertinoColors.systemGrey3,
          ),
          SizedBox(height: 12),
          Text(
            'No Subjects',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tap + to add your first subject',
            style: TextStyle(
              color: CupertinoColors.systemGrey2,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
