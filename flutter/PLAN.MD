Task summary: [x] Improve date picker UI/UX
    I don't like that after selecting a date I have to select the time, I would like to select the date and time in different pickers, there should be to 2 tabs, one for date and one for time, and the user can switch between them, changing one should not reset the other.

## Decisions Log
- Created a custom `TabbedDateTimePickerDialog` to handle both date and time in one workflow.
- Used `ListWheelScrollView` for the time selector to provide a premium mobile feel.
- Integrated `CalendarDatePicker` for the date tab.