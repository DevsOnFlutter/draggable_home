# Draggable Home

A draggable Flutter widget that makes implementing a Sliding up and fully-strechable much easier! Based on the Scaffold and Sliver.

<br>

<p>
<img width="205px" alt="Example" src="https://github.com/4-alok/draggable_home/raw/master/screenshots/example.gif"/>
<img width="205px" alt="Example" src="https://github.com/4-alok/draggable_home/raw/master/screenshots/1.jpg"/>
<img width="205px" alt="Example" src="https://github.com/4-alok/draggable_home/raw/master/screenshots/2.png"/>
<img width="205px" alt="Example" src="https://github.com/4-alok/draggable_home/raw/master/screenshots/3.png"/>
</p>
<br>

## Usage

Make sure to check out [examples](https://github.com/) for more details.

### Installation

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  draggable_home: ^1.0.0
```

### Basic setup

*The complete example is available [here](https://github.com/).*

**DraggableHome** requires you to provide `title`, `headerWidget` and `body`:
* `title` widget is basically for title in AppBar. For no title in appbar, simply put a empty Contnainer.
* `headerWidget` is the expanded widget  just above body when not fully expanded.
* `body` is in the form of Column which requires list of widget or a widget. Do not add any verically scrollable widge or you may just disable the scrollable
```dart
  physics: const NeverScrollableScrollPhysics()
```
<br>

Sample code
```dart
DraggableHome(
  title: Text("Ttitle"),
  headerWidget: headerWidget(),
  body: [
    Container(...),
    (...),
  ]
);
```

Sample code for ListView.builder

```dart
DraggableHome(
  title: Text("Ttitle"),
  headerWidget: headerWidget(),
  body: [
    Container(...),

    // shrinkWrap true required for ListView.builder()
    // disable the scroll for any verically scrollable widget
    ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text("$index"),
        ),
      ),
    ),

    (...),
  ]
);
```
