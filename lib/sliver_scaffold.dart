import 'dart:ui';

import 'package:flutter/material.dart';

const double _searchHeight = 54;
const double _vPadding = 12;
const double _appBarCollapsedHeight = _searchHeight + _vPadding * 2;
const double _appBarExpandedHeight = _searchHeight + 100;

class SliverScaffold extends StatefulWidget {
  const SliverScaffold({
    Key? key,
    required this.body,
  }) : super(key: key);
  final Widget body;
  @override
  State<SliverScaffold> createState() => _SliverScaffoldState();
}

class _SliverScaffoldState extends State<SliverScaffold> {
  final ScrollController _controller = ScrollController();

  double currentExtent = 0.0;

  double get minExtent => 0.0;
  double get maxExtent => _controller.position.maxScrollExtent;

  double get deltaExtent => maxExtent - minExtent;

  /// Icons spacing before scrolling and after scrolling
  final Tween<double> actionSpacingTween = Tween<double>(begin: 24, end: 0);
  double actionSpacing = 24;

  /// Search bar before scrolling and after scrolling
  final Tween<double> hSearchTween = Tween<double>(begin: 16, end: 48);
  double hSearch = 16;

  final Tween<double> vSearchTween = Tween<double>(begin: 74, end: 12);
  double vSearch = 74;

  /// Transition curve
  Curve get curve => Curves.easeOutCubic;
  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  double _remapCurrentExtent(Tween<double> target) {
    final double deltaTarget = target.end! - target.begin!;

    double currentTarget =
        (((currentExtent - minExtent) * deltaTarget) / deltaExtent) +
            target.begin!;

    double t = (currentTarget - target.begin!) / deltaTarget;

    double curveT = curve.transform(t);
    return lerpDouble(target.begin!, target.end!, curveT) ?? 0;
  }

  _scrollListener() {
    setState(() {
      currentExtent = _controller.offset;
      actionSpacing = _remapCurrentExtent(actionSpacingTween);
      hSearch = _remapCurrentExtent(hSearchTween);
      vSearch = _remapCurrentExtent(vSearchTween);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _controller,
      headerSliverBuilder: (_, __) => [
        SliverAppBar(
          backgroundColor: Colors.teal.shade300,
          leading: Row(
            children: [
              SizedBox(width: actionSpacing),
              IconButton(
                onPressed: () {},
                splashRadius: 24,
                icon: const Icon(
                  Icons.grid_view_rounded,
                ),
              ),
            ],
          ),
          leadingWidth: 74,
          toolbarHeight: _appBarCollapsedHeight,
          collapsedHeight: _appBarCollapsedHeight,
          expandedHeight: _appBarExpandedHeight,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar.createSettings(
            currentExtent: _appBarCollapsedHeight,
            minExtent: _appBarCollapsedHeight,
            maxExtent: _appBarExpandedHeight,
            toolbarOpacity: 1.0,
            child: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(
                top: vSearch,
                left: hSearch,
                right: hSearch,
              ),
              title: Column(
                children: [
                  SizedBox(
                    height: _searchHeight,
                    width: double.maxFinite,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.amber.shade50,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              splashRadius: 24,
              icon: const Icon(
                Icons.notifications_rounded,
              ),
            ),
            SizedBox(width: actionSpacing),
          ],
        ),
      ],
      body: widget.body,
    );
  }
}
