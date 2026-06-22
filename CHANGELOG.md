## 3.0.0

- Update dependencies
- Add number of elements in section to the header builder (**breaking change**)
- Add unit tests

## 2.0.0

- Add a the original index of the item in the parameters

## 1.0.0

* `GroupedListView`
* `GroupedListView.list()`
* `GroupedListView.grid()`

See [documentation](https://github.com/quentin7b/flutter_grouped_listview)

## 1.0.1

* Fixes an issue that makes horizontal lists and scroll lead to Unbounded height

## 2.0.0

* Added a new argument in the builders `itemsBuilder` and `customBuilder` no longer takes `List<I>` as parameter but a `List<IndexedItem<I>>`.
* `gridItemBuilder` in `GroupedListView.grid` and `listItemBuilder` in `GroupedListView.list()` are taking a new parameter, `int itemIndexInOriginalList` which is, as it says, the index of the item in the original given list.

This is a breaking change, as your code needs to be updated to takes this new parameter in account.

This fills a [requirement asked in the project](https://github.com/quentin7b/flutter_grouped_listview/issues/5) 

> This would be necessary to create a "scroll to header" function and is available in most List/GridView objects and other grouped list packages.