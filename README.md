# Flutter Simple Grouped ListView

![Pub Version](https://img.shields.io/pub/v/simple_grouped_listview)

See on [pub.dev](https://pub.dev/packages/simple_grouped_listview)

`simple_grouped_listview` is a package that helps you display grouped item in a listview

## Usecase

Sometimes, you have a `List<T>` and you want to display it but with a particularity.
`T` must be grouped somehow.

For example, `T` has a `DateTime` field and you want to group them under the `day` or the `month` or the `year` or even some mix.

Using this package, you'll be able to display your `List<T>` easily without doing much.

## Features

There are 4 main features exposed in this library.

- Custom Grouped ListView with a builder for the header and for the List of items
- List Grouped ListView with a builder for the header and for each item of the Lists
- Grid Grouped ListView with a builder for the header and for each item of the Grids
- Custom Grouped ListView with a builder for each group of items (header and List of items)

Using this 4 Widgets, you'll be able to do whatever you need to get some results like this:

<img width="200" alt="Simple List" src="https://raw.githubusercontent.com/quentin7b/flutter_grouped_listview/main/raw/simple_list.gif">
<img width="200" alt="Simple Grid" src="https://raw.githubusercontent.com/quentin7b/flutter_grouped_listview/main/raw/grid_list.gif">
<img width="200" alt="Sticky List" src="https://raw.githubusercontent.com/quentin7b/flutter_grouped_listview/main/raw/sticky_list.gif">


## Installation 

### Dependency 

Add the package as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  simple_grouped_listview: "^3.0.0"
```

### Import 
Import the package in your code file.

```dart
import 'package:simple_grouped_listview/simple_grouped_listview.dart';
```

## Usage

You can use the widget `GroupedListView` to create your listviews.

There are 3 available constructors for this widhet.

Mandatory params are

- `items` which is the `List<T>` that you want to display
- `itemGrouper` which is a `H Function(T item)`, `H` being the header that is used to group your items. 
For example, if you want to group your `T` items with a `DateTime` field on the year, then item groupe can be `itemGrouper: (T i) => T.dateTime.year`.

Now you have 2 possibilities.

- Providing a `headerBuilder` and a `listItemBuilder`/`gridItemBuilder`/`itemsBuilder` that are builders that help creating the list
- Providing a `customBuilder` that will be in charge of building all the items (header and list included)

Moreover, you have 3 helpers to guide you

- `GroupedListView.list()` that displays your `List<T>` is a `ListView`
- `GroupedListView.grid()` that displays your `List<T>` is a `GridView`
- `GroupedListView()` that displays your `List<T>` is a ... your call ! 

Here are examples of each usage

### Simple

```dart
GroupedListView.list(
    items: List<int>.generate(100, (index) => index + 1),
    itemGrouper: (int i) => i.isEven,
    headerBuilder: (context, isEven, itemsForHeaderCount) => Container(
        color: Colors.amber,
        child: Text(
            isEven ? 'Even' : 'Odd',
            style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: const EdgeInsets.all(16),
    ),
    listItemBuilder:
        (context, int countInGroup, int itemIndexInGroup, int item, int itemIndexInOriginalList) =>
            Container(
        child: Text(item.toRadixString(10), textAlign: TextAlign.center),
        padding: const EdgeInsets.all(8),
    ),
);
```

> Using the `GroupedListView.list()` constructor, you have to provide a `listItemBuilder` to build the items, the `ListView` itself is handled by the **package**

### Grid

```dart
GroupedListView.grid(
    items: List<int>.generate(100, (index) => index + 1),
    itemGrouper: (int i) => i.isEven,
    headerBuilder: (context, isEven, itemsForHeaderCount) => Container(
        color: Colors.amber,
        child: Text(
            isEven ? 'Even' : 'Odd',
            style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: const EdgeInsets.all(16),
    ),
    gridItemBuilder:
        (context, int countInGroup, int itemIndexInGroup, int item, int itemIndexInOriginalList) =>
            Container(
        child: Text(item.toRadixString(10), textAlign: TextAlign.center),
        padding: const EdgeInsets.all(8),
    ),
    crossAxisCount: 5,
);
```

> Using the `GroupedListView.grid()` constructor, you have to provide a `gridItemBuilder` to build the items, the `GridView` itself is handled by the **package**
> Note that for the `grid` constructor, a `crossAxisCount` parameter is **required**

### Custom

```dart
GroupedListView(
    items: List<int>.generate(100, (index) => index + 1),
    headerBuilder: (context, isEven, itemsForHeader) => Container(
        child: Text(
            isEven ? 'Even' : 'Odd',
            style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: const EdgeInsets.all(16),
    ),
    itemsBuilder: (context, List<IndexedItem<int>> items) => ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, int index) => Container(
            child: Text(items[index].item.toRadixString(10),
                textAlign: TextAlign.center),
            padding: const EdgeInsets.all(8),
        ),
    ),
    itemGrouper: (int i) => i.isEven,
);
```

> Using the `GroupedListView.grid()` constructor, you have to provide a `itemsBuilder` to build the items, nothing is provided by the **paclage** so, here is an example with a `ListView`

### sticky_header

What if you want to use some other **package** like [StickyHeaders](https://pub.dev/packages/sticky_headers), giving a `headerBuilder` and an `itemBuilder` won't work for this kind of *package*.
No worries, you can use a specific **constructor** to do so.

```dart
GroupedListView(
    items: List<int>.generate(100, (index) => index + 1),
    customBuilder: (context, bool isEvenHeader, List<<IndexedItem<int>> items) => StickyHeader(
        header: Container(
        color: Colors.amber,
        child: Text(
            isEvenHeader ? 'Even' : 'Odd',
            style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: const EdgeInsets.all(16)),
        content: ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) => Container(
                child: Text(items[index].item.toRadixString(10),
                    textAlign: TextAlign.center),
                padding: const EdgeInsets.all(8),
            ),
        ),
    ),
    itemGrouper: (int i) => i.isEven,
)
```

> Using the `GroupedListView()` with a `customBuilder` helps you manage your UI with what you want the customBuilder being a Function that gives you a `BuildContext`, a `H` (your header type) and a `List<IndexedItem<T>>`


## Additional information

Feel free to open an issue or contribute to this package ! Hope it helps you build awesome UI with flutter.
See the [example](./example) folder for examples of usage.
