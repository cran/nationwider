# nationwider 1.1.0

* Added a `NEWS.md` file to track changes to the package.

## Bug Fixes

* Added `semi-det` to the list of available ids
* Fixed NA name in ntwd_get("seasonal_regional"), since the coming update of tidyselect 1.0 which performs stronger name checking (#1).

## New Features

`ntwd_get(id, verbose)`

* Now prints the excel source
* Argument verbose can disable printing

## Minor improvements

* Renamed column `key` to `type/house_type`

# nationwider 1.0.0

* Initial release

