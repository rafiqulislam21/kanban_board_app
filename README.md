# Kanban Board App

A Flutter app that can be used for task management.

## Installation
`Flutter sdk: Flutter (Channel stable, 3.7.3, on Microsoft Windows [Version 10.0.22621.1265], locale en-US)`
#### Library used:
```dart
  get: ^4.6.5
  get_storage: ^2.0.2
  jiffy: ^5.0.0
  boardview: ^0.2.2
  confetti: ^0.7.0
  to_csv: ^1.1.1
 ````
Clean existing package cache:
```bash
$flutter clean
```
Get all the packages:
```bash
$flutter pub get
```
Run in debug mode:
```bash
$flutter run
```
Build in release mode:
```bash
$flutter build apk
```

## How to use/ Features
- Add columns: There is a floating `+` button in the bottom right corner. By pressing the button adding a new column is possible.
- Edit column: This feature is available under the three-dot button in every column header.
- Delete column: This feature is available under the three-dot button in every column header.
------
- Add task: Add button `+` in column header or column body.
- Edit task: Edit button for every task card.
- Delete task: Delete button for every task card.
- Complete task: There is a tik button on every task card. When the user clicks that button, the task would be considered a completed task.
- Export task list to CSV file: For every column, there is an individual CSV export option.
-----
- Theme: In the app bar there is a switch, using that switch user can use light/dark mode.

<div style="height:100px">
  ![](https://github.com/rafiqulislam21/kanban_board_app/blob/master/demo/light.jpg)
  </div>
  <div style="height:100px">
  ![](https://github.com/rafiqulislam21/kanban_board_app/blob/master/demo/dark.jpg)
 </div>
There is a demo [here](https://github.com/rafiqulislam21/kanban_board_app/blob/master/demo/ezgif.com-video-to-gif.gif) on how to use it.

![](https://github.com/rafiqulislam21/kanban_board_app/blob/master/demo/ezgif.com-video-to-gif.gif)
