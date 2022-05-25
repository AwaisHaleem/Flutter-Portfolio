import 'package:flutter/material.dart';
import 'package:pk_netflix/Provider/Appbar/app_bar_provider.dart';
import 'package:pk_netflix/data/data.dart';
import 'package:pk_netflix/widgets/Preview.dart';
import 'package:provider/provider.dart';

import '../widgets/content_header.dart';
import '../widgets/content_list.dart';
import '../widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        Provider.of<AppBarProvider>(context, listen: false)
            .setOffSet(_scrollController!.offset);
      });
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // double _offset = Provider.of<AppBarProvider>(context).offSet;
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        child: const Icon(Icons.cast),
        onPressed: () => print("cast"),
      ),
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: Consumer<AppBarProvider>(builder: (ctx, app, chi) {
          return CustomAppBar(
            scrollOffset: app.offSet,
          );
        }),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ContentHeader(featuredContent: sintelContent),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 20),
          ),
          SliverToBoxAdapter(
            child: Preview(
                key: const PageStorageKey("Previews"),
                titl: "Previews",
                contentList: previews),
          ),
          SliverToBoxAdapter(
            child: ContentList(
                key: const PageStorageKey("My List"),
                title: 'My List',
                contentList: myList),
          ),
          SliverToBoxAdapter(
            child: ContentList(
                key: const PageStorageKey("Originals"),
                title: 'Originals',
                contentList: originals,
                isOriginal: true),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                  key: const PageStorageKey("Trending"),
                  title: 'Trendig',
                  contentList: trending),
            ),
          )
        ],
      ),
    );
  }
}
