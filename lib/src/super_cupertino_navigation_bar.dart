import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_cupertino_navigation_bar/src/navbar_prototypes/normal_navbar_with_floated_search.dart';
import 'package:super_cupertino_navigation_bar/src/navbar_prototypes/normal_navbar_with_pinned_search.dart';
import 'package:super_cupertino_navigation_bar/src/shared/measures.dart';

import 'models/avatar.model.dart';
import 'models/search_field.model.dart';
import 'navbar_prototypes/large_title_with_floated_search.dart';
import 'navbar_prototypes/large_title_with_pinned_search.dart';
import 'navbar_prototypes/large_title_without_search.dart';
import 'shared/navigation_bar_static_components.dart';

class SuperCupertinoNavigationBar extends StatefulWidget {
  /// Creates a navigation bar for scrolling lists.
  ///
  /// The [largeTitle] argument is required and must not be null.
  SuperCupertinoNavigationBar({
    Key? key,
    required this.largeTitle,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyTitle = true,
    this.alwaysShowMiddle = true,
    this.physics = const BouncingScrollPhysics(),
    this.previousPageTitle,
    this.middle,
    this.trailing,
    this.border = Measures.kDefaultNavBarBorder,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.brightness,
    this.padding,
    this.transitionBetweenRoutes = true,
    this.heroTag = Measures.defaultHeroTag,
    this.stretch = true,
    required this.slivers,
    this.scrollController,
    this.largeTitleType = AppBarType.LargeTitleWithFloatedSearch,
    SearchFieldDecoration? searchFieldDecoration,
    this.avatarModel,
  }) : super(key: key) {
    assert(
      automaticallyImplyTitle || largeTitle != null,
      'No largeTitle has been provided but automaticallyImplyTitle is also '
      'false. Either provide a largeTitle or set automaticallyImplyTitle to '
      'true.',
    );

    this.searchFieldDecoration =
        searchFieldDecoration ?? SearchFieldDecoration();
  }

  late final SearchFieldDecoration searchFieldDecoration;
  final ScrollPhysics physics;
  // final String? avatarUrl;
  // final bool avatarIsVisible;
  final AvatarModel? avatarModel;
  final AppBarType largeTitleType;

  /// The navigation bar's title.
  ///
  /// This text will appear in the top static navigation bar when collapsed and
  /// below the navigation bar, in a larger font, when expanded.
  ///
  /// A suitable [DefaultTextStyle] is provided around this widget as it is
  /// moved around, to change its font size.
  ///
  /// If [middle] is null, then the [largeTitle] widget will be inserted into
  /// the tree in two places when transitioning from the collapsed state to the
  /// expanded state. It is therefore imperative that this subtree not contain
  /// any [GlobalKey]s, and that it not rely on maintaining state (for example,
  /// animations will not survive the transition from one location to the other,
  /// and may in fact be visible in two places at once during the transition).
  ///
  /// If null and [automaticallyImplyTitle] is true, an appropriate [Text]
  /// title will be created if the current route is a [CupertinoPageRoute] and
  /// has a `title`.
  ///
  /// This parameter must either be non-null or the route must have a title
  /// ([CupertinoPageRoute.title]) and [automaticallyImplyTitle] must be true.
  final Widget? largeTitle;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.leading}
  ///
  /// This widget is visible in both collapsed and expanded states.
  final Widget? leading;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.automaticallyImplyLeading}
  final bool automaticallyImplyLeading;

  /// Controls whether we should try to imply the [largeTitle] widget if null.
  ///
  /// If true and [largeTitle] is null, automatically fill in a [Text] widget
  /// with the current route's `title` if the route is a [CupertinoPageRoute].
  /// If [largeTitle] widget is not null, this parameter has no effect.
  ///
  /// This value cannot be null.
  final bool automaticallyImplyTitle;

  /// Controls whether [middle] widget should always be visible (even in
  /// expanded state).
  ///
  /// If true (default) and [middle] is not null, [middle] widget is always
  /// visible. If false, [middle] widget is visible only in collapsed state if
  /// it is provided.
  ///
  /// This should be set to false if you only want to show [largeTitle] in
  /// expanded state and [middle] in collapsed state.
  final bool alwaysShowMiddle;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.previousPageTitle}
  final String? previousPageTitle;

  /// A widget to place in the middle of the static navigation bar instead of
  /// the [largeTitle].
  ///
  /// This widget is visible in both collapsed and expanded states if
  /// [alwaysShowMiddle] is true, otherwise just in collapsed state. The text
  /// supplied in [largeTitle] will no longer appear in collapsed state if a
  /// [middle] widget is provided.
  final Widget? middle;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.trailing}
  ///
  /// This widget is visible in both collapsed and expanded states.
  final Widget? trailing;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.backgroundColor}
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.brightness}
  final Brightness? brightness;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.padding}
  final EdgeInsetsDirectional? padding;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.border}
  final Border? border;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.transitionBetweenRoutes}
  final bool transitionBetweenRoutes;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.heroTag}
  final Object heroTag;

  /// True if the navigation bar's background color has no transparency.
  bool get opaque => backgroundColor?.alpha == 0xFF;

  /// Whether the nav bar should stretch to fill the over-scroll area.
  ///
  /// The nav bar can still expand and contract as the user scrolls, but it will
  /// also stretch when the user over-scrolls if the [stretch] value is `true`.
  ///
  /// When set to `true`, the nav bar will prevent subsequent slivers from
  /// accessing overscrolls. This may be undesirable for using overscroll-based
  /// widgets like the [CupertinoSliverRefreshControl].
  ///
  /// Defaults to `false`.
  final bool stretch;

  final List<Widget> slivers;

  /// Scroll controller of [CustomScrollView]
  final ScrollController? scrollController;

  @override
  State<SuperCupertinoNavigationBar> createState() =>
      _SuperCupertinoNavigationBarState();
}

// A state class exists for the nav bar so that the keys of its sub-components
// don't change when rebuilding the nav bar, causing the sub-components to
// lose their own states.
class _SuperCupertinoNavigationBarState
    extends State<SuperCupertinoNavigationBar>
    with SingleTickerProviderStateMixin {
  late NavigationBarStaticComponentsKeys keys;
  late AnimationController animationController;
  late FocusNode _focusNode;
  late double _offset = 0;
  // late ScrollController _scrollController;
  TextEditingController textController = TextEditingController();
  final ScrollController _localScrollController =
      ScrollController(initialScrollOffset: 0);

  ///true if appBar is collapsed else false
  final ValueNotifier<bool> searchBarHasFocusMetric = ValueNotifier(false);

  ///true if appBar is collapsed else false
  final ValueNotifier<bool> searchBarHasDataMetric = ValueNotifier(false);

  ///true if appBar is collapsed else false

  @override
  void initState() {
    super.initState();
    keys = NavigationBarStaticComponentsKeys();
    animationController = AnimationController(
      vsync: this,
      duration: Measures.mainAnimationControllerForMaxExtent,
    );
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        _offset = _scrollController.offset;
        setState(() {});
      });
      if (widget.searchFieldDecoration.hideSearchBarOnInit &&
          widget.largeTitleType == AppBarType.LargeTitleWithFloatedSearch) {
        _scrollController.animateTo(
          Measures.searchBarHeight,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      }
    });
  }

  TextEditingController get availableTextController =>
      widget.searchFieldDecoration.controller ?? textController;

  ScrollController get _scrollController =>
      widget.scrollController ?? _localScrollController;

  @override
  void dispose() {
    animationController.dispose();
    _focusNode.dispose();
    widget.searchFieldDecoration.controller?.dispose();
    textController.dispose();
    widget.scrollController?.dispose();
    searchBarHasFocusMetric.dispose();
    searchBarHasDataMetric.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavigationBarStaticComponents components =
        NavigationBarStaticComponents(
      keys: keys,
      route: ModalRoute.of(context),
      userLeading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      automaticallyImplyTitle: widget.automaticallyImplyTitle,
      previousPageTitle: widget.previousPageTitle,
      userMiddle: widget.middle,
      userTrailing: widget.trailing,
      userLargeTitle: widget.largeTitle,
      padding: widget.padding,
      large: true,
    );

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: (e) async {
        /// this solves Fast scroll jag
        await Future.delayed(const Duration(milliseconds: 60));

        if (_scrollController.hasClients) {
          if (widget.largeTitleType == AppBarType.LargeTitleWithFloatedSearch) {
            if (_scrollController.offset < Measures.searchBarHeight / 2 &&
                _scrollController.offset > 0) {
              _scrollController.animateTo(
                0,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            } else if (_scrollController.offset >=
                    Measures.searchBarHeight / 2 &&
                _scrollController.offset < Measures.searchBarHeight) {
              _scrollController.animateTo(
                Measures.searchBarHeight,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            } else if (_scrollController.offset >= Measures.searchBarHeight &&
                _scrollController.offset <
                    Measures.searchBarHeight +
                        Measures.navBarLargeTitleHeight / 2) {
              _scrollController.animateTo(
                Measures.searchBarHeight,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            } else if (_scrollController.offset >
                    Measures.searchBarHeight +
                        Measures.navBarLargeTitleHeight / 2 &&
                _scrollController.offset <
                    Measures.searchBarHeight +
                        Measures.navBarLargeTitleHeight) {
              _scrollController.animateTo(
                Measures.searchBarHeight + Measures.navBarLargeTitleHeight,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            }
          } else if (widget.largeTitleType ==
              AppBarType.LargeTitleWithoutSearch) {
            if (_scrollController.offset <
                    Measures.navBarLargeTitleHeight / 2 &&
                _scrollController.offset > 0) {
              _scrollController.animateTo(
                0,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            } else if (_scrollController.offset >=
                    Measures.navBarLargeTitleHeight / 2 &&
                _scrollController.offset < Measures.navBarLargeTitleHeight) {
              _scrollController.animateTo(
                Measures.navBarLargeTitleHeight,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            }
          } else if (widget.largeTitleType ==
              AppBarType.LargeTitleWithPinnedSearch) {
            if (_scrollController.offset <
                    Measures.navBarLargeTitleHeight / 2 &&
                _scrollController.offset > 0) {
              _scrollController.animateTo(
                0,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            } else if (_scrollController.offset >=
                    Measures.navBarLargeTitleHeight / 2 &&
                _scrollController.offset <
                    Measures.navBarLargeTitleHeight -
                        Measures.navBarBottomPadding) {
              _scrollController.animateTo(
                Measures.navBarLargeTitleHeight - Measures.navBarBottomPadding,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            }
          } else if (widget.largeTitleType ==
              AppBarType.NormalNavbarWithFloatedSearch) {
            if (_scrollController.offset < Measures.searchBarHeight / 2 &&
                _scrollController.offset > 0) {
              _scrollController.animateTo(
                0,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            } else if (_scrollController.offset >=
                    Measures.searchBarHeight / 2 &&
                _scrollController.offset < Measures.searchBarHeight) {
              _scrollController.animateTo(
                Measures.searchBarHeight,
                duration: Measures.snapScrollAnimation,
                curve: Curves.fastOutSlowIn,
              );
            }
          }
        }
      },
      child: ValueListenableBuilder(
          valueListenable: searchBarHasFocusMetric,
          builder: (context, searchBarHasFocus, child) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: widget.physics,
                  slivers: <Widget>[
                    /// This is padding for stretching above
                    SliverToBoxAdapter(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: !searchBarHasFocus
                            ? (Measures.navBarPersistentHeight +
                                MediaQuery.paddingOf(context).top +
                                (widget.largeTitleType !=
                                        AppBarType.LargeTitleWithoutSearch
                                    ? Measures.searchBarHeight
                                    : 0) +
                                (widget.largeTitleType ==
                                            AppBarType
                                                .NormalNavbarWithFloatedSearch ||
                                        widget.largeTitleType ==
                                            AppBarType
                                                .NormalNavbarWithPinnedSearch
                                    ? 0
                                    : Measures.navBarLargeTitleHeight) +
                                Measures.collapsedBottomPadding)
                            : Measures.navBarPersistentHeight +
                                MediaQuery.paddingOf(context).top,
                      ),
                    ),
                    ...widget.slivers,
                  ],
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ValueListenableBuilder(
                      valueListenable: searchBarHasDataMetric,
                      builder: (context, searchBarHasData, child) {
                        bool _ignore = false;
                        bool _showResultScreen = false;
                        if (widget.searchFieldDecoration.searchFieldBehaviour ==
                            SearchFieldBehaviour
                                .ShowResultScreenAfterFieldFocused) {
                          _ignore = !searchBarHasFocus;
                          _showResultScreen = searchBarHasFocus;
                        } else if (widget
                                .searchFieldDecoration.searchFieldBehaviour ==
                            SearchFieldBehaviour
                                .ShowResultScreenAfterFieldInput) {
                          _ignore = !searchBarHasData;
                          _showResultScreen = searchBarHasData;
                        } else if (widget
                                .searchFieldDecoration.searchFieldBehaviour ==
                            SearchFieldBehaviour.NeverShowResultScreen) {
                          _ignore = true;
                          _showResultScreen = false;
                        }
                        return IgnorePointer(
                          ignoring: _ignore,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: _showResultScreen ? 1 : 0,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color: CupertinoTheme.of(context)
                                    .scaffoldBackgroundColor,
                                child: Stack(
                                  children: [
                                    _buildSearchResultContent(context),
                                    Positioned(
                                      child: wrapWithBackground(
                                        backgroundColor:
                                            CupertinoDynamicColor.maybeResolve(
                                                    widget.backgroundColor,
                                                    context) ??
                                                CupertinoTheme.of(context)
                                                    .scaffoldBackgroundColor
                                                    .withOpacity(0.50),
                                        child: widget.searchFieldDecoration
                                            .searchResultHeader,
                                      ),
                                      top: Measures.searchBarHeight +
                                          Measures.collapsedBottomPadding +
                                          MediaQuery.of(context).padding.top,
                                      left: 0,
                                      right: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Builder(builder: (context) {
                  double _height = 0;
                  if (searchBarHasFocus) {
                    _height = Measures.navBarPersistentHeight +
                        MediaQuery.paddingOf(context).top;
                  } else {
                    if (widget.largeTitleType ==
                        AppBarType.LargeTitleWithFloatedSearch) {
                      _height = Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top +
                          Measures.searchBarHeight +
                          Measures.navBarLargeTitleHeight -
                          clampDouble(
                              _offset,
                              widget.stretch ? -200 : 0,
                              Measures.searchBarHeight +
                                  Measures.collapsedBottomPadding +
                                  Measures.navBarLargeTitleHeight);
                    } else if (widget.largeTitleType ==
                        AppBarType.LargeTitleWithPinnedSearch) {
                      _height = Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top +
                          Measures.searchBarHeight +
                          Measures.navBarLargeTitleHeight -
                          clampDouble(
                              _offset,
                              widget.stretch ? -200 : 0,
                              Measures.searchBarHeight +
                                  Measures.collapsedBottomPadding);
                    } else if (widget.largeTitleType ==
                        AppBarType.LargeTitleWithoutSearch) {
                      _height = Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top +
                          Measures.navBarLargeTitleHeight -
                          clampDouble(
                            _offset,
                            widget.stretch ? -200 : 0,
                            Measures.navBarLargeTitleHeight,
                          );
                    } else if (widget.largeTitleType ==
                        AppBarType.NormalNavbarWithFloatedSearch) {
                      _height = Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top +
                          Measures.searchBarHeight +
                          Measures.normalNavbarCollapsedBottomPadding -
                          clampDouble(
                              _offset,
                              0,
                              Measures.searchBarHeight +
                                  Measures.normalNavbarCollapsedBottomPadding);
                    } else if (widget.largeTitleType ==
                        AppBarType.NormalNavbarWithPinnedSearch) {
                      _height = Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top +
                          Measures.searchBarHeight +
                          Measures.normalNavbarCollapsedBottomPadding;
                    }
                  }

                  Widget _filteredChild = const SizedBox();
                  if (widget.largeTitleType ==
                      AppBarType.LargeTitleWithPinnedSearch) {
                    _filteredChild = LargeTitleWithPinnedSearch(
                      keys: keys,
                      hasDataValueNotifier: searchBarHasDataMetric,
                      hasFocusValueNotifier: searchBarHasFocusMetric,
                      avatarModel: widget.avatarModel ?? AvatarModel(),
                      focusNode: _focusNode,
                      animationController: animationController,
                      searchFieldDecoration: widget.searchFieldDecoration,
                      scrollController: _scrollController,
                      textEditingController: availableTextController,
                      components: components,
                      userMiddle: widget.middle,
                      backgroundColor: CupertinoDynamicColor.maybeResolve(
                              widget.backgroundColor, context) ??
                          CupertinoTheme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.75),
                      collapsedBackgroundColor:
                          CupertinoDynamicColor.maybeResolve(
                                  widget.collapsedBackgroundColor, context) ??
                              CupertinoTheme.of(context)
                                  .barBackgroundColor
                                  .withOpacity(0.5),
                      brightness: widget.brightness,
                      border: widget.border,
                      padding: widget.padding,
                      actionsForegroundColor:
                          CupertinoTheme.of(context).primaryColor,
                      transitionBetweenRoutes: widget.transitionBetweenRoutes,
                      heroTag: widget.heroTag,
                      persistentHeight: Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top,
                      alwaysShowMiddle:
                          widget.alwaysShowMiddle && widget.middle != null,
                    );
                  }
                  if (widget.largeTitleType ==
                      AppBarType.LargeTitleWithFloatedSearch) {
                    _filteredChild = LargeTitleWithFloatedSearch(
                      keys: keys,
                      hasDataValueNotifier: searchBarHasDataMetric,
                      hasFocusValueNotifier: searchBarHasFocusMetric,
                      avatarModel: widget.avatarModel ?? AvatarModel(),
                      focusNode: _focusNode,
                      animationController: animationController,
                      searchFieldDecoration: widget.searchFieldDecoration,
                      scrollController: _scrollController,
                      textEditingController: availableTextController,
                      components: components,
                      userMiddle: widget.middle,
                      backgroundColor: CupertinoDynamicColor.maybeResolve(
                              widget.backgroundColor, context) ??
                          CupertinoTheme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.75),
                      collapsedBackgroundColor:
                          CupertinoDynamicColor.maybeResolve(
                                  widget.collapsedBackgroundColor, context) ??
                              CupertinoTheme.of(context)
                                  .barBackgroundColor
                                  .withOpacity(0.5),
                      brightness: widget.brightness,
                      border: widget.border,
                      padding: widget.padding,
                      actionsForegroundColor:
                          CupertinoTheme.of(context).primaryColor,
                      transitionBetweenRoutes: widget.transitionBetweenRoutes,
                      heroTag: widget.heroTag,
                      persistentHeight: Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top,
                      alwaysShowMiddle:
                          widget.alwaysShowMiddle && widget.middle != null,
                    );
                  }

                  if (widget.largeTitleType ==
                      AppBarType.LargeTitleWithoutSearch) {
                    _filteredChild = LargeTitleWithoutSearch(
                      keys: keys,
                      hasFocusValueNotifier: searchBarHasFocusMetric,
                      avatarModel: widget.avatarModel ?? AvatarModel(),
                      focusNode: _focusNode,
                      animationController: animationController,
                      searchFieldDecoration: widget.searchFieldDecoration,
                      scrollController: _scrollController,
                      components: components,
                      userMiddle: widget.middle,
                      backgroundColor: CupertinoDynamicColor.maybeResolve(
                              widget.backgroundColor, context) ??
                          CupertinoTheme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.75),
                      collapsedBackgroundColor:
                          CupertinoDynamicColor.maybeResolve(
                                  widget.collapsedBackgroundColor, context) ??
                              CupertinoTheme.of(context)
                                  .barBackgroundColor
                                  .withOpacity(0.5),
                      brightness: widget.brightness,
                      border: widget.border,
                      padding: widget.padding,
                      actionsForegroundColor:
                          CupertinoTheme.of(context).primaryColor,
                      transitionBetweenRoutes: widget.transitionBetweenRoutes,
                      heroTag: widget.heroTag,
                      persistentHeight: Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top,
                      alwaysShowMiddle:
                          widget.alwaysShowMiddle && widget.middle != null,
                    );
                  }
                  if (widget.largeTitleType ==
                      AppBarType.NormalNavbarWithFloatedSearch) {
                    _filteredChild = NormalNavbarWithFloatedSearch(
                      keys: keys,
                      hasDataValueNotifier: searchBarHasDataMetric,
                      hasFocusValueNotifier: searchBarHasFocusMetric,
                      avatarModel: widget.avatarModel ?? AvatarModel(),
                      focusNode: _focusNode,
                      animationController: animationController,
                      searchFieldDecoration: widget.searchFieldDecoration,
                      scrollController: _scrollController,
                      textEditingController: availableTextController,
                      components: components,
                      userMiddle: widget.middle,
                      backgroundColor: CupertinoDynamicColor.maybeResolve(
                              widget.backgroundColor, context) ??
                          CupertinoTheme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.75),
                      collapsedBackgroundColor:
                          CupertinoDynamicColor.maybeResolve(
                                  widget.collapsedBackgroundColor, context) ??
                              CupertinoTheme.of(context)
                                  .barBackgroundColor
                                  .withOpacity(0.5),
                      brightness: widget.brightness,
                      border: widget.border,
                      padding: widget.padding,
                      actionsForegroundColor:
                          CupertinoTheme.of(context).primaryColor,
                      transitionBetweenRoutes: widget.transitionBetweenRoutes,
                      heroTag: widget.heroTag,
                      persistentHeight: Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top,
                      alwaysShowMiddle:
                          widget.alwaysShowMiddle && widget.middle != null,
                    );
                  }
                  if (widget.largeTitleType ==
                      AppBarType.NormalNavbarWithPinnedSearch) {
                    _filteredChild = NormalNavbarWithPinnedSearch(
                      keys: keys,
                      hasDataValueNotifier: searchBarHasDataMetric,
                      hasFocusValueNotifier: searchBarHasFocusMetric,
                      avatarModel: widget.avatarModel ?? AvatarModel(),
                      focusNode: _focusNode,
                      animationController: animationController,
                      searchFieldDecoration: widget.searchFieldDecoration,
                      scrollController: _scrollController,
                      textEditingController: availableTextController,
                      components: components,
                      userMiddle: widget.middle,
                      backgroundColor: CupertinoDynamicColor.maybeResolve(
                              widget.backgroundColor, context) ??
                          CupertinoTheme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.75),
                      collapsedBackgroundColor:
                          CupertinoDynamicColor.maybeResolve(
                                  widget.collapsedBackgroundColor, context) ??
                              CupertinoTheme.of(context)
                                  .barBackgroundColor
                                  .withOpacity(0.5),
                      brightness: widget.brightness,
                      border: widget.border,
                      padding: widget.padding,
                      actionsForegroundColor:
                          CupertinoTheme.of(context).primaryColor,
                      transitionBetweenRoutes: widget.transitionBetweenRoutes,
                      heroTag: widget.heroTag,
                      persistentHeight: Measures.navBarPersistentHeight +
                          MediaQuery.paddingOf(context).top,
                      alwaysShowMiddle:
                          widget.alwaysShowMiddle && widget.middle != null,
                    );
                  }

                  return AnimatedPositioned(
                    duration: Duration(
                        milliseconds:
                            animationController.isAnimating ? 250 : 0),
                    top: 0,
                    height: _height,
                    left: 0,
                    right: 0,
                    child: _filteredChild,
                  );
                }),
              ],
            );
          }),
    );
  }

  Widget _buildSearchResultContent(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListView(
        padding: EdgeInsets.only(
          right: 0,
          left: 0,
          top: Measures.navBarPersistentHeight +
              MediaQuery.paddingOf(context).top +
              widget.searchFieldDecoration.searchResultHeader.height,
        ),
        children: widget.searchFieldDecoration.searchResultChildren,
      ),
    );

    /*return ValueListenableBuilder(
        valueListenable: Measures.searchBarHasData,
        builder: (context, searchBarHasData, child) {
          if (!searchBarHasData) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: widget.searchFieldDecoration.emptyWidget ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.abc,
                          size: 60,
                          color: widget.searchFieldDecoration.cursorColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Search Something!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Write at least ${widget.searchFieldDecoration.minimumChars} character to search",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 120,
                        )
                      ],
                    ),
              ),
            );
          }

          return ValueListenableBuilder(
              valueListenable: Measures.searchHasError,
              builder: (context, hasError, child) {
                if (hasError) {
                  //print("hasError");
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: widget.searchFieldDecoration.emptyWidget ??
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_outlined,
                                size: 60,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Something went wrong!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Check spelling or do a new search",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 120,
                              )
                            ],
                          ),
                    ),
                  );
                }

                return ValueListenableBuilder(
                  valueListenable: Measures.searchIsLoading,
                  builder: (context, isLoading, child) {
                    //print("isLoading $isLoading");
                    if (isLoading) {
                      return Positioned(
                        top: Measures.navBarPersistentHeight +
                            MediaQuery.paddingOf(context).top +
                            10 +
                            renderBox.size.height,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 14,
                          ),
                        ),
                      );
                    }
                    //print("isNotLoading");

                    if (Measures.searchListItems.value.isEmpty) {
                      return Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: widget.searchFieldDecoration.emptyWidget ??
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 60,
                                    color: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .color!
                                        .withOpacity(0.8),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'No results for your search',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Opacity(
                                    opacity: 0.65,
                                    child: Text(
                                      "Check spelling or do a new search",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 120,
                                  )
                                ],
                              ),
                        ),
                      );
                    }
                    return ListView(
                      padding: EdgeInsets.only(
                        right: 15,
                        left: 15,
                        top: Measures.navBarPersistentHeight +
                            MediaQuery.paddingOf(context).top +
                            10 +
                            renderBox.size.height,
                      ),
                      addAutomaticKeepAlives: true,
                      children:
                          widget.searchFieldDecoration.searchResultChildren,
                    );
                  },
                );
              });
        });*/
  }
}