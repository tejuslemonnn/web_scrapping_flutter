import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:web_scraping/models/package_model.dart';
import 'package:web_scraping/services/http_service.dart';
import 'package:web_scraping/services/scrapper_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;

  final PagingController<int, PackageModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((page) {
      _getPackages();
    });
    super.initState();
  }

  Future<void> _getPackages() async {
    try {
      final html = await HttpService.getPackage(page);
      if (html != null) {
        final packages = ScrapperService.run(html);
        _pagingController.appendPage(packages, page++);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Scrapping Pub.dev'),
      ),
      body: PagedListView<int, PackageModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<PackageModel>(
          itemBuilder: (context, item, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.description),
                      trailing: Text(item.likes),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(item.version),
                          Text(item.tags.join(', ')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
