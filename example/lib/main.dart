import 'package:flutter/material.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';
import 'package:sticky_headers/sticky_headers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
            child: const Text('Custom'),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CustomPage())),
          ),
          ElevatedButton(
            child: const Text('ListView'),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ListPage())),
          ),
          ElevatedButton(
            child: const Text('GridView'),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const GridPage())),
          ),
          ElevatedButton(
            child: const Text('Sticky Header'),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const StickyPage())),
          ),
          ElevatedButton(
            child: const Text('Horizontal Page'),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HorizontalPage())),
          ),
        ],
      ),
    );
  }
}

class CustomPage extends StatelessWidget {
  const CustomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom GroupedListView')),
      body: GroupedListView(
        items: List<int>.generate(100, (index) => index + 1),
        headerBuilder: (context, isEven, itemsForHeader) {
          return Container(
            color: Colors.amber,
            padding: const EdgeInsets.all(16),
            child: Text(
              '${(isEven ? 'Even' : 'Odd')} (${itemsForHeader.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
        itemsBuilder: (context, List<IndexedItem<int>> items) {
          return ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {
                return Container(
                  color: Color.fromARGB(
                    255,
                    ((128 / items.length) * index).toInt() + 127,
                    ((128 / items.length) * index).toInt() + 127,
                    ((128 / items.length) * index).toInt() + 127,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(items[index].item.toRadixString(10),
                      textAlign: TextAlign.center),
                );
              });
        },
        itemGrouper: (int i) => i.isEven,
        itemsCrossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GroupedListView.list()')),
      body: GroupedListView.list(
        items: List<int>.generate(100, (index) => index + 1),
        headerBuilder: (context, isEven, itemsForHeader) {
          return Container(
            color: Colors.amber,
            padding: const EdgeInsets.all(16),
            child: Text(
              '${(isEven ? 'Even' : 'Odd')} (${itemsForHeader.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
        listItemBuilder:
            (context, int countInGroup, int itemIndexInGroup, int item, _) =>
                Container(
          color: Color.fromARGB(
            255,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
          ),
          padding: const EdgeInsets.all(8),
          child: Text(item.toRadixString(10), textAlign: TextAlign.center),
        ),
        itemGrouper: (int i) => i.isEven,
      ),
    );
  }
}

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GroupedListView.grid()')),
      body: GroupedListView.grid(
        items: List<int>.generate(100, (index) => index + 1),
        headerBuilder: (context, isEven, itemsForHeader) {
          return Container(
            color: Colors.amber,
            padding: const EdgeInsets.all(16),
            child: Text(
              '${(isEven ? 'Even' : 'Odd')} (${itemsForHeader.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
        gridItemBuilder:
            (context, int countInGroup, int itemIndexInGroup, int item, _) =>
                Container(
          color: Color.fromARGB(
            255,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
          ),
          padding: const EdgeInsets.all(8),
          child: Text(item.toRadixString(10), textAlign: TextAlign.center),
        ),
        itemGrouper: (int i) => i.isEven,
        crossAxisCount: 5,
      ),
    );
  }
}

class StickyPage extends StatelessWidget {
  const StickyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Custom GroupedListView with StickyHeader')),
      body: GroupedListView<bool, int>(
        items: List<int>.generate(100, (index) => index + 1),
        customBuilder:
            (context, bool isEvenHeader, List<IndexedItem<int>> items) {
          return StickyHeader(
              header: Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(16),
                child: Text(
                  isEvenHeader ? 'Even' : 'Odd',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return Container(
                      color: Color.fromARGB(
                        255,
                        ((128 / items.length) * index).toInt() + 127,
                        ((128 / items.length) * index).toInt() + 127,
                        ((128 / items.length) * index).toInt() + 127,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(items[index].item.toRadixString(10),
                          textAlign: TextAlign.center),
                    );
                  }));
        },
        itemGrouper: (int i) => i.isEven,
        itemsCrossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

class HorizontalPage extends StatelessWidget {
  const HorizontalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              'GroupedListView.list() GroupedListView horizontal Page')),
      body: GroupedListView.list(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        items: List<int>.generate(100, (index) => index + 1),
        itemGrouper: (int i) => i.isEven,
        headerBuilder: (context, isEven, itemsForHeader) =>
            Text('${(isEven ? 'Even' : 'Odd')} (${itemsForHeader.length})'),
        listItemBuilder:
            (context, int countInGroup, int itemIndexInGroup, int item, _) =>
                Container(
          color: Color.fromARGB(
            255,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
            ((128 / countInGroup) * itemIndexInGroup).toInt() + 127,
          ),
          padding: const EdgeInsets.all(8),
          child: Text(item.toRadixString(10), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
