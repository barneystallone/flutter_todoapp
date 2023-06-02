import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/list_todos.dart';
import '../components/td_app_bar.dart';
import '../resources/app_color.dart';

class HomePage extends StatefulWidget {
  // final String title;
  final bool isRestorePage;
  const HomePage({super.key, this.isRestorePage = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final List<String> _titleList = ['Todos', 'Restore'];
  final List<Widget> _pages = [
    const ListTodo(),
    const ListTodo(
      isRestorePage: true,
    )
  ];
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: TdAppBar(
          rightPressed: () async {
            bool? status = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('😍'),
                content: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Do you want to logout?',
                        style: TextStyle(fontSize: 22.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            if (status ?? false) {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          },
          title: _titleList[_currentPageIndex]),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPageIndex = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _pages[index % _pages.length];
            },
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.restore_from_trash), label: 'Restore')
        ],
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 600), curve: Curves.ease);
        },
        // animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
