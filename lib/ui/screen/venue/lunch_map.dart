import 'package:auto_size_text/auto_size_text.dart';
import 'package:conference_2023/l10n/localization.dart';
import 'package:conference_2023/model/venue/lunch_provider.dart';
import 'package:conference_2023/util/launch_in_external_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class LunchMapPage extends ConsumerWidget {
  const LunchMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final storeList = ref.watch(storeListProvider);

    return TableView.builder(
      pinnedRowCount: 1,
      columnCount: 7,
      rowCount: storeList.items.length,
      columnBuilder: (index) => switch (index) {
        0 => const TableSpan(
            extent: FixedTableSpanExtent(48),
          ),
        1 || 2 => const TableSpan(
            extent: FixedTableSpanExtent(140),
          ),
        3 => const TableSpan(
            extent: MaxTableSpanExtent(
              FixedTableSpanExtent(140),
              FractionalTableSpanExtent(0.2),
            ),
          ),
        4 => const TableSpan(
            extent: MaxTableSpanExtent(
              FixedTableSpanExtent(140),
              FractionalTableSpanExtent(0.4),
            ),
          ),
        5 => const TableSpan(
            extent: FixedTableSpanExtent(100),
          ),
        6 => const TableSpan(
            extent: RemainingTableSpanExtent(),
          ),
        _ => const TableSpan(
            extent: FixedTableSpanExtent(0),
          ),
      },
      rowBuilder: (index) => switch (index) {
        0 => TableSpan(
            extent: const FixedTableSpanExtent(48),
            backgroundDecoration: TableSpanDecoration(
              border: TableSpanBorder(
                trailing: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1,
                ),
              ),
            ),
          ),
        _ => TableSpan(
            extent: const MaxTableSpanExtent(
              FixedTableSpanExtent(100),
              FractionalTableSpanExtent(0.2),
            ),
            backgroundDecoration: TableSpanDecoration(
              border: TableSpanBorder(
                trailing: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
            ),
          ),
      },
      cellBuilder: (context, vicinity) {
        final store = storeList.items[vicinity.row];
        if (vicinity.row == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                switch (vicinity.column) {
                  0 => '',
                  1 => store.name,
                  2 => store.routeTime,
                  3 => store.recommendedMenu,
                  4 => store.comment,
                  5 => localization.venueMenuOption,
                  _ => '',
                },
              ),
            ),
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: switch (vicinity.column) {
              0 => Text('${vicinity.row}'),
              1 => AutoSizeText(
                  store.name,
                  maxLines: 2,
                  softWrap: true,
                ),
              2 => Text(localization.venueRouteTime(store.routeTime)),
              3 => AutoSizeText(
                  store.recommendedMenu,
                  maxLines: 5,
                  softWrap: true,
                ),
              4 => AutoSizeText(
                  store.comment,
                  maxLines: 5,
                  softWrap: true,
                ),
              5 => PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(localization.venueMenuLink),
                      onTap: () async {
                        final uri = Uri.parse(store.externalLink);
                        await launchInExternalApp(uri);
                      },
                    ),
                    PopupMenuItem(
                      child: Text(localization.venueMenuNavitimeMap),
                      onTap: () async {
                        final uri = Uri.parse(store.navitimeMapLink);
                        await launchInExternalApp(uri);
                      },
                    ),
                    PopupMenuItem(
                      child: Text(localization.venueMenuGoogleMap),
                      onTap: () async {
                        final uri = Uri.parse(store.googleMapLink);
                        await launchInExternalApp(uri);
                      },
                    ),
                  ],
                ),
              _ => const SizedBox.shrink(),
            },
          ),
        );
      },
    );
  }
}
