import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/utils/formatters.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/command_history_item.dart';
import 'package:secure_home/presentation/providers/history_provider.dart';
import 'package:secure_home/presentation/widgets/app_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(historyProvider);
    final colors = context.colors;
    final grouped = <String, List<CommandHistoryItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(Formatters.relativeDay(item.timestamp), () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear history?'),
                    content: const Text('This only removes local command records.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear')),
                    ],
                  ),
                );
                if (ok == true) await ref.read(historyProvider.notifier).clear();
              },
              child: const Text('Clear'),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No commands yet.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final day = grouped.keys.elementAt(index);
                final dayItems = grouped[day]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                      child: Text(day, style: Theme.of(context).textTheme.titleSmall),
                    ),
                    ...dayItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _HistoryTile(item: item),
                        )),
                  ],
                );
              },
            ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final CommandHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ok = item.status == HistoryStatus.sent;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: ok ? colors.secured : colors.disarmed,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  '${Formatters.time(item.timestamp)}  ·  ${PhoneUtils.mask(item.destination)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (item.errorMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(item.errorMessage!, style: TextStyle(color: colors.disarmed, fontSize: 12)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
