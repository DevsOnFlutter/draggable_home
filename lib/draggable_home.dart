library draggable_home;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DraggableHome extends StatefulWidget {
  @override
  _DraggableHomeState createState() => _DraggableHomeState();

  final Widget? leading;
  final Widget title;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool alwaysShowLeadingAndAction;
  final Widget? drawer;
  final double headerExpandedHeight;
  final Widget headerWidget;
  final Widget? headerBottomBar;
  final Color? backgroundColor;
  final double curvedBodyRadius;
  final List<Widget> body;
  final bool fullyStretchable;
  final double stretchTriggerOffset;
  final Widget? expandedBody;
  final double stretchMaxHeight;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final double? bottomNavigationBarHeight;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// This will create DraggableHome.
  const DraggableHome({
    Key? key,
    this.leading,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.alwaysShowLeadingAndAction = false,
    this.headerExpandedHeight = 0.35,
    required this.headerWidget,
    this.headerBottomBar,
    this.backgroundColor,
    this.curvedBodyRadius = 20,
    required this.body,
    this.drawer,
    this.fullyStretchable = false,
    this.stretchTriggerOffset = 200,
    this.expandedBody,
    this.stretchMaxHeight = 0.9,
    this.bottomSheet,
    this.bottomNavigationBarHeight = kBottomNavigationBarHeight,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
  })  : assert(headerExpandedHeight > 0.0 &&
            headerExpandedHeight < stretchMaxHeight),
        assert(
          (stretchMaxHeight > headerExpandedHeight) && (stretchMaxHeight < .95),
        ),
        super(key: key);
}

class _DraggableHomeState extends State<DraggableHome> {
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
    final double appBarHeight =
        AppBar().preferredSize.height + widget.curvedBodyRadius;

    final double topPadding = MediaQuery.of(context).padding.top;

    final double expandedHeight =
        MediaQuery.of(context).size.height * widget.headerExpandedHeight;

    final double fullyExpandedHeight =
        MediaQuery.of(context).size.height * (widget.stretchMaxHeight);

    return Scaffold(
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      drawer: widget.drawer,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            // isFullyCollapsed
            if ((isFullyExpanded.value) &&
                notification.metrics.extentBefore > 100) {
              isFullyExpanded.add(false);
            }
            //isFullyCollapsed
            if (notification.metrics.extentBefore >
                expandedHeight - AppBar().preferredSize.height - 40) {
              if (!(isFullyCollapsed.value)) isFullyCollapsed.add(true);
            } else {
              if ((isFullyCollapsed.value)) isFullyCollapsed.add(false);
            }
          }
          return false;
        },
        child: sliver(context, appBarHeight, fullyExpandedHeight,
            expandedHeight, topPadding),
      ),
      bottomSheet: widget.bottomSheet,
      bottomNavigationBar: widget.bottomNavigationBar,
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
              leading: widget.alwaysShowLeadingAndAction
                  ? widget.leading
                  : !streams[0]
                      ? SizedBox()
                      : widget.leading,
              actions: widget.alwaysShowLeadingAndAction
                  ? widget.actions
                  : !streams[0]
                      ? []
                      : widget.actions,
              elevation: 0,
              pinned: true,
              stretch: true,
              centerTitle: widget.centerTitle,
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
                            ? (widget.expandedBody == null
                                ? Container()
                                : widget.expandedBody)
                            : widget.headerWidget),
                  ),
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: roundedCorner(context),
                  ),
                  Positioned(
                    bottom: 0 + widget.curvedBodyRadius,
                    child: AnimatedContainer(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      curve: Curves.easeInOutCirc,
                      duration: Duration(milliseconds: 100),
                      height: streams[0]
                          ? 0
                          : streams[1]
                              ? 0
                              : kToolbarHeight,
                      width: MediaQuery.of(context).size.width,
                      child: streams[0]
                          ? SizedBox()
                          : streams[1]
                              ? SizedBox()
                              : widget.headerBottomBar ?? Container(),
                    ),
                  )
                ],
              ),
              stretchTriggerOffset: widget.stretchTriggerOffset,
              onStretchTrigger: widget.fullyStretchable
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
      height: widget.curvedBodyRadius,
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.curvedBodyRadius),
        ),
      ),
    );
  }

  SliverList sliverList(BuildContext context, double topHeight) {
    final double bottomPadding =
        widget.bottomNavigationBar == null ? 0 : kBottomNavigationBarHeight;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    topHeight -
                    bottomPadding,
                color: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
              ),
              Column(
                children: [
                  expandedUpArrow(),
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

  StreamBuilder<bool> expandedUpArrow() {
    return StreamBuilder<bool>(
        stream: isFullyExpanded.stream,
        builder: (context, snapshot) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: (snapshot.data ?? false) ? 25 : 0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: (snapshot.data ?? false) ? null : Colors.transparent,
              ),
            ),
          );
        });
  }
}
