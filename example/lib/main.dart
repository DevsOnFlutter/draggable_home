import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

import 'camera_preview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Draggable Home",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: const Icon(Icons.arrow_back_ios),
      title: const Text("Draggable Home"),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        listView(),
      ],
      fullyStretchable: true,
      expandedBody: const CameraPreview(),
    );
  }

  Row headerBottomBarWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget headerWidget(BuildContext context) => Center(
        child: Text("Title",
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.white70)),
      );

  ListView listView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        color: Colors.white70,
        child: ListTile(
          leading: CircleAvatar(
            child: Text("$index"),
          ),
          title: const Text("Title"),
          subtitle: const Text("Subtitile"),
        ),
      ),
    );
  }
}
