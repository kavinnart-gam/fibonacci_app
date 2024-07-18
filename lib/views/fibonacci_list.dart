import 'package:flutter/material.dart';

import '../model/fibonacci_model.dart';

class Fibonaccilist extends StatefulWidget {
  const Fibonaccilist({Key? key}) : super(key: key);

  @override
  State<Fibonaccilist> createState() => _FibonaccilistState();
}

class _FibonaccilistState extends State<Fibonaccilist> {
  final int size = 40;
  int currentId = -1;
  List<FibonacciModel> fibonacciList = [
    FibonacciModel(value: 0, iconName: 'circle', id: 0),
    FibonacciModel(value: 1, iconName: 'square', id: 1),
  ];

  List<FibonacciModel> selectedList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getFibonacciList();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getFibonacciList() {
    for (int i = 2; i <= size; i++) {
      int result = fibonacciList[i - 1].value + fibonacciList[i - 2].value;
      String iconName = (result % 3 == 0)
          ? 'circle'
          : (result % 3 == 1)
              ? 'square'
              : 'cross';

      fibonacciList.add(
        FibonacciModel(value: result, iconName: iconName, id: i),
      );
    }
    setState(() {});
  }

  final Map<String, IconData> iconMap = {
    'circle': Icons.circle,
    'square': Icons.crop_square,
    'cross': Icons.close,
  };

  void _showModalBottomSheet(BuildContext context, FibonacciModel selectedItem, double h) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: h,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: selectedList.length,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentId = selectedList[index].id;
                      //  pop item from selectedList and scroll to this item by id
                      selectedList.removeWhere((item) => item.id == selectedList[index].id);
                      Navigator.of(context).pop();
                      _scrollToIndex(currentId);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: selectedItem.id == selectedList[index].id ? Colors.green : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('index: ${selectedList[index].id}, Number: ${selectedList[index].value.toString()}'),
                        Icon(
                          iconMap[selectedList[index].iconName],
                          size: 23,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  void _scrollToIndex(int index) {
    // Calculate the scroll position based on the item index
    double scrollPosition = index * 70; // Adjust based on your item height or content
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example"),
      ),
      body: ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: fibonacciList.length,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                bool isSameType = selectedList.any((item) => item.iconName == fibonacciList[index].iconName);
                bool isSameId = selectedList.any((item) => item.id == fibonacciList[index].id);

                if (!isSameId) {
                  if (selectedList.isEmpty || isSameType) {
                    selectedList.add(fibonacciList[index]);
                  } else {
                    selectedList.clear();
                    selectedList.add(fibonacciList[index]);
                  }
                  _showModalBottomSheet(context, fibonacciList[index], h);
                }
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: currentId == fibonacciList[index].id ? Colors.red : Colors.transparent,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('index: $index, Number: ${fibonacciList[index].value.toString()}'),
                    Icon(
                      iconMap[fibonacciList[index].iconName],
                      size: 23,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
