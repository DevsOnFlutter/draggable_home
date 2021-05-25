# Draggable Home

A draggable Flutter widget that makes implementing a Sliding up and fully-stretchable  much easier! Based on the Scaffold and Sliver.

<br>
<p>
<a href="https://play.google.com/store/apps/details?id=com.hackthedeveloper.recite"><img width="205px" alt="Example" src="https://imgur.com/8rwRBWe.gif"/></a>
<img width="205px" alt="Example" src="https://imgur.com/lAtgU0E.gif"/>
<img width="205px" alt="Example" src="https://imgur.com/QS7y9OU.gif"/>
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
* `title` widget is basically for title in AppBar. For no title in appbar, simply put an empty Contnainer.
* `headerWidget` is the expanded widget  just above body when not fully expanded.
* `body` is in the form of Column which requires list of widget or a widget. Do not add any verically scrollable widge or you may just disable the scroll.
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

## Arguments
There are several options that allow for more control:

|  Properties  |   Description   |
|--------------|-----------------|
| `leading` | A widget to display before the toolbar's title. |
| `action` | A list of Widgets to display in a row after the title widget. |
| `drawer` | Drawers are typically used with the Scaffold.drawer property. |
| `centerTitle` | Allows toggling of title from the center. By default title is in the center.|
| `headerExpandedHeight` | Height of the header widget. The height is a double between 0.0 and 1.0. The default value of height is 0.35 and should be less than **stretchMaxHeight** |
| `headerWidget` | A widget to display Header above body. |
|`alwaysShowLeadingAndAction`| This make Leading and Action always visible. Default value is false. |
|`headerBottomBar`| AppBar or toolBar like widget just above the body. | 
| `backgroundColor` | The color of the Material widget that underlies the entire DraggableHome body. |
| `curvedBodyRadius` | Creates a border top left and top right radius of body, Default radius of the body is 20.0. For no radius simply set value to **0**.|
| `fullyStretchable` | Allows toggling of fully expand draggability of the DraggableHome. Set this to true to allow the user to fully expand the header. |
| `stretchTriggerOffset` | The offset of overscroll required to fully expand the header.|
| `expandedBody` | A widget to display when fully expanded as header or expandedBody above body. |
| `stretchMaxHeight` | Height of the expandedBody widget. The height is a double between 0.0 and 0.95. The default value of height is 0.9 and should be greater than **headerExpandedHeight**  |
| `bottomSheet` | A persistent bottom sheet shows information that supplements the primary content of the app. A persistent bottom sheet remains visible even when the user interacts with other parts of the app.|
|`bottomNavigationBarHeight`| This is requires when using custom height to adjust body height. This make no effect on **bottomNavigationBar**.|
|`bottomNavigationBar` | Snack bars slide from underneath the bottom navigation bar while bottom sheets are stacked on top. |
| `floatingActionButton` | A floating action button is a circular icon button that hovers over content to promote a primary action in the application. |
| `floatingActionButtonLocation` | An object that defines a position for the FloatingActionButton based on the Scaffold's ScaffoldPrelayoutGeometry.|
| `floatingActionButtonAnimator` | Provider of animations to move the FloatingActionButton between FloatingActionButtonLocations. |


<br>
<br>


## Sample code for ListView.builder

```dart
DraggableHome(
  title: Text("Ttitle"),
  headerWidget: headerWidget(),
  body: [
    Container(...),

    // shrinkWrap true required for ListView.builder()
    // disable the scroll for any verically scrollable widget
    // provide top padding 0 to fix extra space in listView
    ListView.builder(
      padding: EdgeInsets.only(top: 0),
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
<br>
<br>

<br>
<p>
<img width="205px" alt="Example" src="https://imgur.com/q6lrXad.gif"/>
<img width="205px" alt="Example" src="https://imgur.com/zdv0jS6.png"/>
<img width="205px" alt="Example" src="https://imgur.com/m0MXP2P.png"/>
</p>
<br>

## Contributions

Contributions are welcomed!

If you feel that a hook is missing, feel free to open a pull-request.

For a custom-hook to be merged, you will need to do the following:

- Describe the use-case.

-  Open an issue explaining why we need this hook, how to use it, ...
  This is important as a hook will not get merged if the hook doens't appeal to
  a large number of people.

-  If your hook is rejected, don't worry! A rejection doesn't mean that it won't
  be merged later in the future if more people shows an interest in it.
  In the mean-time, feel free to publish your hook as a package on https://pub.dev.

-  A hook will not be merged unles fully tested, to avoid breaking it inadvertendly
  in the future.