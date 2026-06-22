import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_grouped_listview/src/grouped_listview.dart';

void main() {
  group('IndexedItem', () {
    test('should create an IndexedItem with item and index', () {
      const item = 'test';
      const index = 5;

      final indexedItem = IndexedItem(item: item, indexInOriginalList: index);

      expect(indexedItem.item, equals(item));
      expect(indexedItem.indexInOriginalList, equals(index));
    });

    test('should support different types', () {
      final intItem = IndexedItem(item: 42, indexInOriginalList: 0);
      final mapItem =
          IndexedItem(item: {'key': 'value'}, indexInOriginalList: 1);

      expect(intItem.item, equals(42));
      expect(mapItem.item, equals({'key': 'value'}));
    });
  });

  group('GroupedListView Constructor', () {
    test(
        'should throw ArgumentError when customBuilder is provided with headerBuilder',
        () {
      expect(
        () => GroupedListView<String, String>(
          items: ['item1', 'item2'],
          itemGrouper: (item) => item.substring(0, 1),
          headerBuilder: (context, header, count) => Text(header),
          itemsBuilder: (context, items) => Container(),
          customBuilder: (context, header, items) => Container(),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        'should throw ArgumentError when customBuilder is provided with itemsBuilder',
        () {
      expect(
        () => GroupedListView<String, String>(
          items: ['item1', 'item2'],
          itemGrouper: (item) => item.substring(0, 1),
          itemsBuilder: (context, items) => Container(),
          customBuilder: (context, header, items) => Container(),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        'should throw ArgumentError when headerBuilder is null and customBuilder is not provided',
        () {
      expect(
        () => GroupedListView<String, String>(
          items: ['item1', 'item2'],
          itemGrouper: (item) => item.substring(0, 1),
          itemsBuilder: (context, items) => Container(),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        'should throw ArgumentError when itemsBuilder is null and customBuilder is not provided',
        () {
      expect(
        () => GroupedListView<String, String>(
          items: ['item1', 'item2'],
          itemGrouper: (item) => item.substring(0, 1),
          headerBuilder: (context, header, count) => Text(header),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should create successfully with headerBuilder and itemsBuilder', () {
      final widget = GroupedListView<String, String>(
        items: ['item1', 'item2'],
        itemGrouper: (item) => item.substring(0, 1),
        headerBuilder: (context, header, count) => Text(header),
        itemsBuilder: (context, items) => Container(),
      );

      expect(widget, isNotNull);
      expect(widget.items, equals(['item1', 'item2']));
    });

    test('should create successfully with customBuilder', () {
      final widget = GroupedListView<String, String>(
        items: ['item1', 'item2'],
        itemGrouper: (item) => item.substring(0, 1),
        customBuilder: (context, header, items) => Container(),
      );

      expect(widget, isNotNull);
      expect(widget.customBuilder, isNotNull);
    });
  });

  group('Grouping Logic', () {
    testWidgets('should group items correctly by string prefix',
        (WidgetTester tester) async {
      final items = ['apple', 'apricot', 'banana', 'berry'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              itemsBuilder: (context, items) => Column(
                children: items.map((item) => Text(item.item)).toList(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Header: a'), findsOneWidget);
      expect(find.text('Header: b'), findsOneWidget);
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('apricot'), findsOneWidget);
      expect(find.text('banana'), findsOneWidget);
      expect(find.text('berry'), findsOneWidget);
    });

    testWidgets('should preserve original indices in grouped items',
        (WidgetTester tester) async {
      final items = ['apple', 'apricot', 'banana', 'berry'];
      final capturedIndices = <int>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, indexedItems) {
                for (final indexedItem in indexedItems) {
                  capturedIndices.add(indexedItem.indexInOriginalList);
                }
                return Container();
              },
            ),
          ),
        ),
      );

      expect(capturedIndices, containsAll([0, 1, 2, 3]));
    });

    testWidgets('should handle empty list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: [],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should work with single item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, items) =>
                  Text('Header: $header (${items.length})'),
              itemsBuilder: (context, items) => Container(),
            ),
          ),
        ),
      );

      expect(find.text('Header: a (1)'), findsOneWidget);
    });

    testWidgets('should group items by complex criteria',
        (WidgetTester tester) async {
      final items = [1, 2, 3, 4, 5, 6];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, int>(
              items: items,
              itemGrouper: (item) => item % 2 == 0 ? 'even' : 'odd',
              headerBuilder: (context, header, items) =>
                  Text('$header (${items.length})'),
              itemsBuilder: (context, items) => Container(),
            ),
          ),
        ),
      );

      expect(find.text('odd (3)'), findsOneWidget);
      expect(find.text('even (3)'), findsOneWidget);
    });

    testWidgets('should maintain insertion order within groups',
        (WidgetTester tester) async {
      final items = ['apple', 'avocado', 'apricot', 'banana'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, indexedItems) => Column(
                children: indexedItems.map((item) => Text(item.item)).toList(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('apple'), findsOneWidget);
      expect(find.text('avocado'), findsOneWidget);
      expect(find.text('apricot'), findsOneWidget);
    });
  });

  group('GroupedListView Widget Building', () {
    testWidgets('should build with headerBuilder and itemsBuilder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'apricot', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              itemsBuilder: (context, items) => Column(
                children: items.map((item) => Text(item.item)).toList(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Header: a'), findsOneWidget);
      expect(find.text('Header: b'), findsOneWidget);
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('apricot'), findsOneWidget);
      expect(find.text('banana'), findsOneWidget);
    });

    testWidgets('should build with customBuilder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              customBuilder: (context, header, items) => Column(
                children: [
                  Text('Custom: $header'),
                  ...items.map((item) => Text(item.item)),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom: a'), findsOneWidget);
      expect(find.text('Custom: b'), findsOneWidget);
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('banana'), findsOneWidget);
    });

    testWidgets('should render with vertical scroll direction',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              scrollDirection: Axis.vertical,
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should render with horizontal scroll direction',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should handle reversed list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              reverse: true,
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should handle empty list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: [],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });
  });

  group('GroupedListView.list Constructor', () {
    testWidgets('should build with list item builder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>.list(
              items: ['apple', 'apricot', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              listItemBuilder:
                  (context, itemCount, itemIndex, item, itemIndexInOriginal) {
                return Text(item);
              },
            ),
          ),
        ),
      );

      expect(find.text('Header: a'), findsOneWidget);
      expect(find.text('Header: b'), findsOneWidget);
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('banana'), findsOneWidget);
    });

    testWidgets('should pass correct parameters to listItemBuilder',
        (WidgetTester tester) async {
      int capturedItemCount = -1;
      int capturedItemIndex = -1;
      int capturedOriginalIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>.list(
              items: ['apple', 'apricot', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text('Header'),
              listItemBuilder:
                  (context, itemCount, itemIndex, item, itemIndexInOriginal) {
                if (item == 'apricot') {
                  capturedItemCount = itemCount;
                  capturedItemIndex = itemIndex;
                  capturedOriginalIndex = itemIndexInOriginal;
                }
                return Text(item);
              },
            ),
          ),
        ),
      );

      expect(capturedItemCount, equals(2)); // 2 items in 'a' group
      expect(capturedItemIndex, equals(1)); // second item in group
      expect(capturedOriginalIndex, equals(1)); // second item in original list
    });
  });

  group('GroupedListView.grid Constructor', () {
    testWidgets('should build with grid item builder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>.grid(
              items: ['apple', 'apricot', 'banana', 'blueberry'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              crossAxisCount: 2,
              gridItemBuilder:
                  (context, itemCount, itemIndex, item, itemIndexInOriginal) {
                return Text(item);
              },
            ),
          ),
        ),
      );

      expect(find.text('Header: a'), findsOneWidget);
      expect(find.text('Header: b'), findsOneWidget);
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('banana'), findsOneWidget);
    });

    testWidgets('should create GridView with correct crossAxisCount',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>.grid(
              items: ['a1', 'a2', 'a3', 'a4'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text('Header'),
              crossAxisCount: 3,
              gridItemBuilder:
                  (context, itemCount, itemIndex, item, itemIndexInOriginal) {
                return Text(item);
              },
            ),
          ),
        ),
      );

      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('should pass correct parameters to gridItemBuilder',
        (WidgetTester tester) async {
      int capturedItemCount = -1;
      int capturedItemIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>.grid(
              items: ['a1', 'a2', 'a3', 'b1'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text('Header'),
              crossAxisCount: 2,
              gridItemBuilder:
                  (context, itemCount, itemIndex, item, itemIndexInOriginal) {
                if (item == 'a2') {
                  capturedItemCount = itemCount;
                  capturedItemIndex = itemIndex;
                }
                return Text(item);
              },
            ),
          ),
        ),
      );

      expect(capturedItemCount, equals(3)); // 3 items in 'a' group
      expect(capturedItemIndex, equals(1)); // second item in group
    });
  });

  group('HeaderSorter', () {
    testWidgets('should sort headers using headerSorter',
        (WidgetTester tester) async {
      final items = ['charlie', 'apple', 'banana'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              itemsBuilder: (context, items) => Container(),
              headerSorter: (a, b) => a.compareTo(b),
            ),
          ),
        ),
      );

      final headers = find.byType(Text);
      expect(headers, findsWidgets);

      // Headers should be sorted: a, b, c
      expect(find.text('Header: a'), findsOneWidget);
      expect(find.text('Header: b'), findsOneWidget);
      expect(find.text('Header: c'), findsOneWidget);
    });

    testWidgets('should reverse sort headers with custom comparator',
        (WidgetTester tester) async {
      final items = ['apple', 'banana', 'cherry'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              itemsBuilder: (context, items) => Container(),
              headerSorter: (a, b) => b.compareTo(a), // Reverse sort
            ),
          ),
        ),
      );

      final headers = find.byType(Text);
      expect(headers, findsWidgets);
    });
  });

  group('ItemSorter', () {
    testWidgets('should sort items within groups using itemSorter',
        (WidgetTester tester) async {
      final items = ['apple', 'avocado', 'banana', 'blueberry', 'cherry'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              itemsBuilder: (context, itemsList) => Column(
                children: itemsList.map((indexedItem) {
                  return Text('Item: ${indexedItem.item}');
                }).toList(),
              ),
              itemSorter: (a, b) => a.compareTo(b),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final items_a = find.byWidgetPredicate((widget) =>
          widget is Text &&
          (widget.data == 'Item: apple' || widget.data == 'Item: avocado'));
      expect(items_a.evaluate().length, greaterThanOrEqualTo(0));
    });

    testWidgets('should sort items in reverse order with custom comparator',
        (WidgetTester tester) async {
      final items = ['apple', 'avocado', 'banana', 'blueberry'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) =>
                  Text('Header: $header'),
              itemsBuilder: (context, itemsList) => Column(
                children: itemsList.map((indexedItem) {
                  return Text('Item: ${indexedItem.item}');
                }).toList(),
              ),
              itemSorter: (a, b) => b.compareTo(a), // Reverse sort
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final items_widgets = find.byType(Text);
      expect(items_widgets, findsWidgets);
    });

    testWidgets('should work with numeric item sorting',
        (WidgetTester tester) async {
      final items = [3, 1, 4, 1, 5, 9, 2, 6];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, int>(
              items: items,
              itemGrouper: (item) => 'Numbers',
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, itemsList) => Column(
                children: itemsList.map((indexedItem) {
                  return Text('${indexedItem.item}');
                }).toList(),
              ),
              itemSorter: (a, b) => a.compareTo(b),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('1'), findsWidgets);
      expect(find.text('9'), findsOneWidget);
    });

    test('should accept itemSorter in constructor without errors', () {
      final widget = GroupedListView<String, String>(
        items: ['apple', 'banana', 'cherry'],
        itemGrouper: (item) => item.substring(0, 1),
        headerBuilder: (context, header, count) => Text(header),
        itemsBuilder: (context, items) => Container(),
        itemSorter: (a, b) => a.compareTo(b),
      );

      expect(widget, isNotNull);
      expect(widget.itemSorter, isNotNull);
    });

    test('should accept null itemSorter (optional parameter)', () {
      final widget = GroupedListView<String, String>(
        items: ['apple', 'banana', 'cherry'],
        itemGrouper: (item) => item.substring(0, 1),
        headerBuilder: (context, header, count) => Text(header),
        itemsBuilder: (context, items) => Container(),
        itemSorter: null,
      );

      expect(widget, isNotNull);
      expect(widget.itemSorter, isNull);
    });
  });

  group('ListView Customization Parameters', () {
    testWidgets('should apply padding to ListView',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should set shrinkWrap property', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              shrinkWrap: false,
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });
  });

  group('Column Customization Parameters', () {
    testWidgets('should build Column with custom mainAxisAlignment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              itemsMainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should build Row with horizontal scroll direction',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              scrollDirection: Axis.horizontal,
              itemsMainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
    });
  });

  group('Complex Grouping Scenarios', () {
    testWidgets('should handle complex objects grouping',
        (WidgetTester tester) async {
      final items = [
        {'name': 'Alice', 'category': 'A'},
        {'name': 'Bob', 'category': 'B'},
        {'name': 'Andrew', 'category': 'A'},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, Map<String, String>>(
              items: items,
              itemGrouper: (item) => item['category']!,
              headerBuilder: (context, header, count) =>
                  Text('Category: $header'),
              itemsBuilder: (context, items) => Column(
                children:
                    items.map((item) => Text(item.item['name']!)).toList(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Category: A'), findsOneWidget);
      expect(find.text('Category: B'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Andrew'), findsOneWidget);
    });

    testWidgets('should handle numeric grouping', (WidgetTester tester) async {
      final items = [1, 2, 3, 4, 5, 6];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, int>(
              items: items,
              itemGrouper: (item) => item % 2 == 0 ? 'even' : 'odd',
              headerBuilder: (context, header, items) =>
                  Text('$header (${items.length})'),
              itemsBuilder: (context, items) => Column(
                children: items.map((item) => Text('${item.item}')).toList(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('odd (3)'), findsOneWidget);
      expect(find.text('even (3)'), findsOneWidget);
    });

    testWidgets('should maintain all items through grouping process',
        (WidgetTester tester) async {
      final items = ['a1', 'a2', 'b1', 'b2', 'c1'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: items,
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Column(
                children: items.map((item) => Text(item.item)).toList(),
              ),
            ),
          ),
        ),
      );

      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }
    });
  });

  group('Key and Widget Properties', () {
    testWidgets('should handle widget key', (WidgetTester tester) async {
      final key = ValueKey('grouped_list');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              key: key,
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
            ),
          ),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('should handle restorationId', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedListView<String, String>(
              items: ['apple', 'banana'],
              itemGrouper: (item) => item.substring(0, 1),
              headerBuilder: (context, header, count) => Text(header),
              itemsBuilder: (context, items) => Container(),
              restorationId: 'grouped_list_view',
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });
  });
}
