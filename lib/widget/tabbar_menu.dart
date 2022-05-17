import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/model.dart';
import 'package:news_app/service/service.dart';

import 'news_item.dart';

class TabBarMenu extends StatefulWidget {
  final List<Article> articles;

  const TabBarMenu({Key? key, required this.articles}) : super(key: key);

  @override
  State<TabBarMenu> createState() => _TabBarMenuState();
}

class _TabBarMenuState extends State<TabBarMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Tab> myTab = [
    const Tab(
      text: 'business',
    ),
    const Tab(
      text: 'entertainment',
    ),
    const Tab(
      text: 'general',
    ),
    const Tab(
      text: 'health',
    ),
    const Tab(
      text: 'science',
    ),
    const Tab(
      text: 'sports',
    ),
    const Tab(
      text: 'technology',
    ),
  ];

  @override
  initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTab.length);
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var news = News();
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: myTab,
            labelColor: Colors.deepOrangeAccent,
            unselectedLabelColor: Colors.black,
            isScrollable: true,
            indicator: const BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Colors.deepOrangeAccent,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: myTab.map((Tab tab) {
                return FutureBuilder(
                    future: news.getNewsByCategories(tab.text.toString()),
                    builder: (context, snapshot) => snapshot.data != null
                        ? _listNewsCategory(snapshot.data as List<Article>)
                        : const Center(child: CircularProgressIndicator()));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listNewsCategory(List<Article> article) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
        itemBuilder: (context, index) => NewsItem(article: article[index]),
        itemCount: article.length,
      ),
    );
  }
}
