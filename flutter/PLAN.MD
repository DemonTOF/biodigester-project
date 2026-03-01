
Task summary 

Modify both graphs, 
    - [x] the X axis should adapt depending in the range of the data, if the data spand days the X axis should be in days, if the data spand hours in hours, etc.
    - [x] After updating the filters, the X axis should also update with the new range of data.

## Decisions Log
- Updated `dateFormat` in `DateTimeAxis` inside `_buildSensorCard` to adjust dynamically based on the `duration` between `endDate` and `startDate`.
- Since Riverpod manages the filter state, adjusting filters inherently triggers a UI rebuild passing the new `startDate`, `endDate`, and recalculated `dateFormat` directly to the `SfCartesianChart`.
