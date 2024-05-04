import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../features/profile/models/user_model.dart';
import '../../../features/profile/views/profile_page.dart';
import '../../../main.dart';
import '../../extensions/context.dart';
import '../../services/local_storage_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/value_notifier.dart';
import '../dialog/base_dialog.dart';
import '../image/image_profile.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ValueListenableBuilder<UserModel?>(
              valueListenable: userDataNotifier,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    const ImageProfile(radius: 24, iconSize: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value?.fullName == null
                              ? 'Guest User'
                              : '${value?.fullName}',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          value?.email == null
                              ? 'please update your data'
                              : '${value?.email}',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ]),
                );
              }),
          const Divider(height: 0),
          const SizedBox(height: 10),
          Column(
            children: [
              (
                icon: Icons.person,
                title: 'Profile',
                onTap: () => nextScreen(const ProfilePage()),
              ),
              (
                icon: Icons.history,
                title: 'History',
                onTap: () {
                  baseDialog(
                    context,
                    child: StatefulBuilder(builder: (context, setInnerState) {
                      final historyList =
                          getIt<LocalStorageService>().getList('searchHistory');
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Search History',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...historyList.map((text) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Text(text, style: context.textTheme.bodyMedium),
                                const Spacer(),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    historyList.remove(text);
                                    getIt<LocalStorageService>()
                                        .remove('searchHistory');
                                    final value = historyList.join(',').trim();
                                    if (value.isNotEmpty) {
                                      getIt<LocalStorageService>()
                                          .setList('searchHistory', value);
                                    }
                                    setInnerState(() {});
                                  },
                                  child: const Icon(Icons.close, size: 20),
                                ),
                              ]),
                            );
                          }),
                          if (historyList.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  historyList.clear();
                                  getIt<LocalStorageService>()
                                      .remove('searchHistory');
                                  setInnerState(() {});
                                },
                                child: Text(
                                  'Clear All',
                                  style: context.textTheme.titleSmall?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Text(
                              'No search history data',
                              style: context.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      );
                    }),
                  );
                },
              ),
              (
                icon: Icons.support_agent,
                title: 'Support',
                onTap: () => launchUrl(
                    Uri.parse(
                        'https://wa.me/6281234567890?text=${Uri.parse('Hello, I need support to use this app. Can you help me?')}'),
                    mode: LaunchMode.externalApplication),
              ),
            ].map((e) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  e.onTap();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      Icon(e.icon, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        e.title,
                        style: context.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }
}
