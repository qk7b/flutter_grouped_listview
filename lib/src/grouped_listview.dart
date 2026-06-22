// Copyright 2022 Quentin KLEIN. All rights reserved.
// Use of this source code is governed by a the MIT license that can be
// found in the LICENSE file.

import "package:collection/collection.dart";
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// IndexedItem is used to keep a trace of the index of the item in the
/// original List
class IndexedItem<T> {
  final T item;
  final int indexInOriginalList;

  IndexedItem({
    required this.item,
    required this.indexInOriginalList,
  });
}

/// The [HeaderBuilder] is a function that render a header of type [H] as a
/// [Widget], it takes a [BuildContext], a [header] [H] as parameters and also the
/// items in the group, represented by [itemsForHeader]
///
/// It is used by [GroupedListView<H, I>] to render the headers of type [H]
typedef HeaderBuilder<H, I> = Widget Function(
    BuildContext context, H header, List<I> itemsForHeader);

/// The [ItemsListBuilder] is a function that render a list of items of type [I]
/// as a [Widget], it takes a [BuildContext] and a [List<IndexedItem<I>>]
/// as parameters.
typedef ItemsListBuilder<I> = Widget Function(
  BuildContext context,
  List<IndexedItem<I>> items,
);

/// The [ItemsWithHeaderBuilder] is a function that render a list of items of
/// type [I] with their header as a [Widget], it takes a [BuildContext], a [H],
/// and a [List<IndexedItem<I>>] as parameters.
typedef ItemsWithHeaderBuilder<H, I> = Widget Function(
  BuildContext context,
  H header,
  List<IndexedItem<I>> items,
);

/// [GroupedListView] Widget
/// The goal of this widget is to take a list of items as an input, group
/// them, and display them, grouped with a header
/// In order to do that, it needs 4 things
/// - A list of items
/// - A function that groups this list of item given a certain criteria
/// - A function that builds a header
/// - A function that builds a list of items
class GroupedListView<H, I> extends StatelessWidget {
  // Needed items
  /// List of the items you want to display grouped
  final List<I> items;

  /// Special [Widget] builder taking a [BuildContext] and a [H] header
  /// ([H] is defined by you in the [itemGrouper] parameter)
  /// This *must* be null if you pass a [customBuilder] parameter.
  final HeaderBuilder<H, I>? headerBuilder;

  /// Special [Widget] builder taking a [BuildContext] and a [List] of [I] items
  /// This *must* be null if you pass a [customBuilder] parameter.
  final ItemsListBuilder<I>? itemsBuilder;

  /// Special [Function] that takes a [I] and returns a [H].
  /// This function is used to create the groups of items.
  final H Function(I item) itemGrouper;

  /// Optional [Function] that helps sort the groups by comparing the [H] headers.
  final Comparator<H>? headerSorter;

  /// Optional [Function] that helps sort the items within a heading group by comparing them.
  final Comparator<I>? itemSorter;

  /// Special [Widget] builder taking a [BuildContext], a [H] header and a [List] of [I] items.
  /// This *must* be null if you pass a [headerBuilder] and a [itemsBuilder] parameters.
  final ItemsWithHeaderBuilder<H, I>? customBuilder;

  // Optional items for macro ListView

  /// Defines the scroll direction of the [ListView]
  /// By default, it is [Axis.vertical]
  final Axis scrollDirection;

  /// Defines if the [ListView] is reversed or not
  /// By default, it is false
  final bool reverse;

  /// Defines a specific [ScrollController] for the [ListView]
  final ScrollController? controller;

  final bool? primary;

  /// Defines a specific [ScrollPhysics] for the [ListView]
  final ScrollPhysics? physics;

  /// Defines if the [ListView] is shrinked
  /// By default, it is true
  final bool shrinkWrap;

  /// Defines an optional [EdgeInsetsGeometry] padding for the [ListView]
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  // Optional items for nesteed Column

  /// Only used If you are not using a [customBuilder]
  /// Set the [MainAxisAlignment] of the [Column] used to display the [H] header and its [List] of [I] items
  /// By default, it is [MainAxisAlignment.start]
  final MainAxisAlignment itemsMainAxisAlignment;

  /// Only used If you are not using a [customBuilder]
  /// Set the [MainAxisSize] of the [Column] used to display the [H] header and its [List] of [I] items
  /// By default, it is [MainAxisSize.max]
  final MainAxisSize itemsMainAxisSize;

  /// Only used If you are not using a [customBuilder]
  /// Set the [CrossAxisAlignment] of the [Column] used to display the [H] header and its [List] of [I] items
  /// By default, it is [CrossAxisAlignment.center]
  final CrossAxisAlignment itemsCrossAxisAlignment;

  /// Only used If you are not using a [customBuilder]
  /// Set the [TextDirection] of the [Column] used to display the [H] header and its [List] of [I] items
  final TextDirection? itemsTextDirection;

  /// Only used If you are not using a [customBuilder]
  /// Set the [VerticalDirection] of the [Column] used to display the [H] header and its [List] of [I] items
  final VerticalDirection itemsVerticalDirection;

  /// Only used If you are not using a [customBuilder]
  /// Set the [TextBaseline] of the [Column] used to display the [H] header and its [List] of [I] items
  final TextBaseline? itemsTextBaseline;

  /// Created a [GroupedListView] with all the customized parametes you want
  ///
  /// Using this constructor, you'll have to provide the [itemsBuilder]
  /// which is a [Function] that helps build the the List of items.
  ///
  /// Be aware, if you want to build a fully customized header + List item, you
  /// can provide a [customBuilder], but if you do so, let [headerBuilder] and
  /// [itemsBuilder] to null.
  ///
  /// Also, as by default, a [ListView] is used, you can customise it using all
  /// the parameters you need (see [ListView]'s documentation)
  ///
  /// Last but not least, if you do not provide a [customBuilder], you can customise
  /// the default [Column] used to display the [H] headers and [List] of [I] items.
  /// All of the fields are prefixed by `items` ([itemsMainAxisAlignment], [itemsMainAxisSize], ...)
  GroupedListView(
      {super.key,
      // GroupedListView params
      required this.items,
      this.headerBuilder,
      this.itemsBuilder,
      required this.itemGrouper,
      this.customBuilder,
      this.headerSorter,
      this.itemSorter,
      // ListView Params
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = true,
      this.padding,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.cacheExtent,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.restorationId,
      this.clipBehavior = Clip.hardEdge,
      // Column params (not compatible with customBuilder)
      this.itemsMainAxisAlignment = MainAxisAlignment.start,
      this.itemsMainAxisSize = MainAxisSize.max,
      this.itemsCrossAxisAlignment = CrossAxisAlignment.center,
      this.itemsTextDirection,
      this.itemsVerticalDirection = VerticalDirection.down,
      this.itemsTextBaseline}) {
    if (customBuilder != null &&
        (headerBuilder != null || itemsBuilder != null)) {
      throw ArgumentError.value(customBuilder,
          'If customBuilder is specified, you should not pass any headerBuilder or itemsBuilder');
    } else if (customBuilder == null && headerBuilder == null) {
      throw ArgumentError.value(headerBuilder,
          'You must provide a non null headerBuilder as there is no customBuilder provided');
    } else if (customBuilder == null && itemsBuilder == null) {
      throw ArgumentError.value(itemsBuilder,
          'You must provide a non null itemsBuilder as there is no customBuilder provided');
    }
  }

  /// Created a [GroupedListView] with your [List] of [I] displayed in a [ListView]
  ///
  /// Using this constructor, you'll have to provide the [listItemBuilder]
  /// which is a [Function] that helps build the the List of items.
  ///
  /// Also, as by default, a [ListView] is used, you can customise it using all
  /// the parameters you need (see [ListView]'s documentation)
  ///
  /// Last but not least, if you do not provide a [customBuilder], you can customise
  /// the default [Column] used to display the [H] headers and [List] of [I] items.
  /// All of the fields are prefixed by `items` ([itemsMainAxisAlignment], [itemsMainAxisSize], ...)
  GroupedListView.list({
    Key? key,
    // GroupedListView params
    required List<I> items,
    required HeaderBuilder<H, I> headerBuilder,
    required Widget Function(BuildContext context, int itemCountInGroup,
            int itemIndexInGroup, I item, int itemIndexInOriginalList)
        listItemBuilder,
    required H Function(I item) itemGrouper,
    Comparator<H>? headerSorter,
    Comparator<I>? itemSorter,
    // Optional items for macro ListView
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = true,
    EdgeInsetsGeometry? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : this(
          key: key,
          // GroupedListView params
          items: items,
          headerBuilder: headerBuilder,
          itemsBuilder: (context, List<IndexedItem> items) {
            return ListView.builder(
              scrollDirection: scrollDirection,
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) => listItemBuilder(
                context,
                items.length,
                index,
                items[index].item,
                items[index].indexInOriginalList,
              ),
            );
          },
          itemGrouper: itemGrouper,
          headerSorter: headerSorter,
          itemSorter: itemSorter,
          // Optional items for macro ListView
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// Created a [GroupedListView] with your [List] of [I] displayed in a [GridView]
  ///
  /// Using this constructor, you'll have to provide the [gridItemBuilder]
  /// which is a [Function] that helps build the the List of items.
  /// You also have to provide at least a [crossAxisCount] to fix the number of items in the axis.
  ///
  /// If you want more customization of the [GridView] you can (not mandatory) use also
  /// [crossAxisSpacing], [mainAxisSpacing] and [itemsAspectRatio]
  ///
  /// Also, as by default, a [ListView] is used, you can customise it using all
  /// the parameters you need (see [ListView]'s documentation)
  ///
  /// Last but not least, if you do not provide a [customBuilder], you can customise
  /// the default [Column] used to display the [H] headers and [List] of [I] items.
  /// All of the fields are prefixed by `items` ([itemsMainAxisAlignment], [itemsMainAxisSize], ...)
  GroupedListView.grid({
    Key? key,
    // GroupedListView params
    required List<I> items,
    required HeaderBuilder<H, I> headerBuilder,
    required Widget Function(BuildContext context, int itemCountInGroup,
            int itemIndexInGroup, I item, int itemIndexInOriginalList)
        gridItemBuilder,
    required H Function(I item) itemGrouper,
    Comparator<H>? headerSorter,
    Comparator<I>? itemSorter,
    // Gridview params
    required int crossAxisCount,
    double crossAxisSpacing = 0,
    double mainAxisSpacing = 0,
    double itemsAspectRatio = 1,
    // Optional items for macro ListView
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = true,
    EdgeInsetsGeometry? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : this(
          key: key,
          // GroupedListView params
          items: items,
          headerBuilder: headerBuilder,
          itemsBuilder: (context, List<IndexedItem> items) {
            return GridView.count(
                scrollDirection: scrollDirection,
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                childAspectRatio: itemsAspectRatio,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                physics: const NeverScrollableScrollPhysics(),
                children: items
                    .mapIndexed(
                      (index, item) => gridItemBuilder(
                        context,
                        items.length,
                        index,
                        item.item,
                        item.indexInOriginalList,
                      ),
                    )
                    .toList());
          },
          itemGrouper: itemGrouper,
          headerSorter: headerSorter,
          itemSorter: itemSorter,
          // Optional items for macro ListView
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  @override
  Widget build(BuildContext context) {
    final Map<H, List<IndexedItem<I>>> groupedItems = _generateGroupedList();
    List<H> keys = groupedItems.keys.toList();
    if (headerSorter != null) {
      keys.sort(headerSorter);
    }
    return ListView.builder(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      itemCount: keys.length,
      itemBuilder: (context, index) {
        H header = keys[index];
        List<IndexedItem<I>> items = groupedItems[header]!;
        if (itemSorter != null) {
          items.sortByCompare((i) => i.item, (a, b) => itemSorter!(a, b));
        }
        final nonIndexedItems = items.map((i) => i.item).toList();
        if (customBuilder != null) {
          return customBuilder!(context, header, items);
        } else {
          return scrollDirection == Axis.vertical
              ? Column(
                  mainAxisAlignment: itemsMainAxisAlignment,
                  mainAxisSize: itemsMainAxisSize,
                  crossAxisAlignment: itemsCrossAxisAlignment,
                  textDirection: itemsTextDirection,
                  verticalDirection: itemsVerticalDirection,
                  textBaseline: itemsTextBaseline,
                  children: [
                    headerBuilder!(context, header, nonIndexedItems),
                    itemsBuilder!(context, items)
                  ],
                )
              : Row(
                  mainAxisAlignment: itemsMainAxisAlignment,
                  mainAxisSize: itemsMainAxisSize,
                  crossAxisAlignment: itemsCrossAxisAlignment,
                  textDirection: itemsTextDirection,
                  verticalDirection: itemsVerticalDirection,
                  textBaseline: itemsTextBaseline,
                  children: [
                      headerBuilder!(context, header, nonIndexedItems),
                      itemsBuilder!(context, items)
                    ]);
        }
      },
    );
  }

  Map<H, List<IndexedItem<I>>> _generateGroupedList() {
    Map<H, List<IndexedItem<I>>> groupedItems = {};
    int index = 0;
    while (index < items.length) {
      I item = items[index];
      H itemHeader = itemGrouper(item);
      IndexedItem<I> indexedItem =
          IndexedItem(item: item, indexInOriginalList: index);
      if (!groupedItems.containsKey(itemHeader)) {
        groupedItems.putIfAbsent(
            itemHeader, () => List<IndexedItem<I>>.empty(growable: true));
      }
      groupedItems[itemHeader]!.add(indexedItem);
      index = index + 1;
    }
    return groupedItems;
  }
}
