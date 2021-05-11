library sliver_home;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class SliverPage extends StatefulWidget {
  @override
  _SliverPageState createState() => _SliverPageState();

  final Widget title;
  final double headerExpandedHeight;
  final List<Widget> body;
  final Color backgroundColor;
  final PreferredSizeWidget bottom;
  final Widget leading;
  final Widget drawer;
  final List<Widget> actions;
  // final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final Widget headerWidget;
  final bool stretchTrigger;
  final double stretchTriggerOffset;
  final Widget expandedBody;
  final double stretchMaxHeight;

  const SliverPage({
    Key key,
    this.title,
    this.body,
    this.headerWidget,
    this.headerExpandedHeight = 0.5,
    this.backgroundColor,
    this.bottom,
    this.leading,
    this.drawer,
    this.actions,
    // this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.stretchTrigger = false,
    this.stretchTriggerOffset = 200,
    this.expandedBody,
    this.stretchMaxHeight = 0.9,
  })  : assert(title != null),
        assert(body != null),
        assert(headerWidget != null),
        assert(headerExpandedHeight > 0.0 &&
            headerExpandedHeight < stretchMaxHeight),
        assert(
          (stretchMaxHeight > headerExpandedHeight) && (stretchMaxHeight < .95),
        ),
        super(key: key);
}

class _SliverPageState extends State<SliverPage> {
  final BehaviorSubject<bool> isFullyExpanded =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isFullyCollapsed =
      BehaviorSubject<bool>.seeded(false);

  @override
  void dispose() {
    isFullyExpanded.close();
    isFullyCollapsed.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height + 20;

    final double topPadding = MediaQuery.of(context).padding.top;

    final double expandedHeight =
        MediaQuery.of(context).size.height * widget.headerExpandedHeight;

    final double fullyExpandedHeight =
        MediaQuery.of(context).size.height * (widget.stretchMaxHeight);

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      drawer: widget.drawer,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            // isFullyCollapsed
            if ((isFullyExpanded.value ?? false) &&
                notification.metrics.extentBefore > 100) {
              isFullyExpanded.add(false);
            }
            //isFullyCollapsed
            if (notification.metrics.extentBefore >
                expandedHeight - AppBar().preferredSize.height - 40) {
              if (!(isFullyCollapsed.value ?? false))
                isFullyCollapsed.add(true);
            } else {
              if ((isFullyCollapsed.value ?? false))
                isFullyCollapsed.add(false);
            }
          }
          return false;
        },
        child: sliver(context, appBarHeight, fullyExpandedHeight,
            expandedHeight, topPadding),
      ),
      // bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
    );
  }

  CustomScrollView sliver(
    BuildContext context,
    double appBarHeight,
    double fullyExpandedHeight,
    double expandedHeight,
    double topPadding,
  ) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        StreamBuilder<List<bool>>(
          stream: CombineLatestStream.list<bool>(
              [isFullyCollapsed.stream, isFullyExpanded.stream]),
          builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
            List<bool> streams = (snapshot.data ?? [false, false]);

            return SliverAppBar(
              leading: widget.leading,
              actions: widget.actions,
              bottom: widget.bottom,
              elevation: 0,
              pinned: true,
              stretch: true,
              centerTitle: true,
              title: StreamBuilder<bool>(
                stream: null,
                builder: (context, snapshot) {
                  return AnimatedOpacity(
                    opacity: streams[0] ? 1 : 0,
                    duration: Duration(milliseconds: 100),
                    child: widget.title,
                  );
                },
              ),
              collapsedHeight: appBarHeight,
              expandedHeight: streams[1] ? fullyExpandedHeight : expandedHeight,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: Container(
                        child: streams[1]
                            ? widget.expandedBody
                            : widget.headerWidget),
                  ),
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: roundedCorner(context),
                  )
                ],
              ),
              stretchTriggerOffset: widget.stretchTriggerOffset,
              onStretchTrigger: widget.stretchTrigger
                  ? () async {
                      if (streams[1] == false) isFullyExpanded.add(true);
                    }
                  : null,
            );
          },
        ),
        sliverList(context, appBarHeight + topPadding),
      ],
    );
  }

  Container roundedCorner(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: const Radius.circular(20),
        ),
      ),
    );
  }

  SliverList sliverList(BuildContext context, double topHeight) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - topHeight,
                color: widget.backgroundColor,
              ),
              Column(
                children: [
                  StreamBuilder<bool>(
                      stream: isFullyExpanded.stream,
                      initialData: false,
                      builder: (context, snapshot) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: (snapshot.data ?? false) ? 25 : 0,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: (snapshot.data ?? false)
                                  ? null
                                  : Colors.transparent,
                            ),
                          ),
                        );
                      }),
                  //Body
                  ...widget.body
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
