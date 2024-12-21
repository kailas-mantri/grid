import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(const GridApp());

class GridApp extends StatelessWidget {
  const GridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Grid Search",
        theme: ThemeData(primaryColor: Colors.blue),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/gridInput': (context) => const GridScreen()
        });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    navigateToGridScreen();
  }

  void navigateToGridScreen() {
    Timer(Duration(milliseconds: 5000), () {
      Navigator.pushReplacementNamed(context, '/gridInput');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Grid Search App",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  GridState createState() => GridState();
}

class GridState extends State<GridScreen> {
  final _mController = TextEditingController();
  final _nController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Dimensions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _mController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Enter number of rows (m)"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Enter number of columns (n)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  int? m = int.tryParse(_mController.text);
                  int? n = int.tryParse(_nController.text);
                  if (m != null && n != null && m > 0 && n > 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GridEntryScreen(m: m, n: n)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Please enter valid numbers for row and columns")));
                  }
                },
                child: const Text("next"))
          ],
        ),
      ),
    );
  }
}

class GridEntryScreen extends StatefulWidget {
  final int m, n;
  const GridEntryScreen({super.key, required this.m, required this.n});

  @override
  GridEntryScreenState createState() => GridEntryScreenState();
}

class GridEntryScreenState extends State<GridEntryScreen> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focus;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.m * widget.n, (index) => TextEditingController());
    _focus = List.generate(widget.m * widget.n, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focus) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleInputCompletion(int index) {
    if (index < _focus.length - 1) {
      FocusScope.of(context).requestFocus(_focus[index + 1]);
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Alphabets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.n,
                ),
                itemCount: widget.m * widget.n,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focus[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ""),
                      onChanged: (value) {
                        if (value.length == 1) {
                          _handleInputCompletion(index);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                List<List<String>> grid = List.generate(
                  widget.m,
                  (eleI) => List.generate(
                    widget.n,
                    (eleJ) =>
                        _controllers[eleI * widget.n + eleJ].text.toUpperCase(),
                  ),
                );

                if (grid
                    .expand((row) => row)
                    .any((element) => element.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All cells must have a value'),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(grid: grid),
                    ),
                  );
                }
              },
              child: const Text("Create Grid"),
            )
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final List<List<String>> grid;
  const SearchScreen({super.key, required this.grid});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<List<bool>>? _highlighted;

  void searchWord(String word) {
    word = word.toUpperCase();
    int m = widget.grid.length;
    int n = widget.grid[0].length;

    List<List<bool>> highlighted =
        List.generate(m, (_) => List.generate(n, (_) => false));

    // Horizontal search
    for (int i = 0; i < m; i++) {
      for (int j = 0; j <= n - word.length; j++) {
        if (widget.grid[i].sublist(j, j + word.length).join() == word) {
          for (int k = 0; k < word.length; k++) {
            highlighted[i][j + k] = true;
          }
        }
      }
    }

    // Vertical search
    for (int i = 0; i <= m - word.length; i++) {
      for (int j = 0; j < n; j++) {
        if (List.generate(word.length, (k) => widget.grid[i + k][j]).join() ==
            word) {
          for (int k = 0; k < word.length; k++) {
            highlighted[i + k][j] = true;
          }
        }
      }
    }

    // Diagonal search (South-East)
    for (int i = 0; i <= m - word.length; i++) {
      for (int j = 0; j <= n - word.length; j++) {
        if (List.generate(word.length, (k) => widget.grid[i + k][j + k])
                .join() ==
            word) {
          for (int k = 0; k < word.length; k++) {
            highlighted[i + k][j + k] = true;
          }
        }
      }
    }

    setState(() {
      _highlighted = highlighted;
    });
  }

  get highlighted => _highlighted;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Search in Grid'),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back))),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                  controller: _searchController,
                  onChanged: (value) => searchWord(value),
                  onSubmitted: (value) {
                    searchWord(value);
                    FocusScope.of(context).unfocus();
                  },
                  onEditingComplete: () {
                    searchWord(_searchController.text);
                    FocusScope.of(context).unfocus();
                  },
                  decoration:
                      const InputDecoration(labelText: 'Enter word to search')),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.grid[0].length),
                  itemCount: widget.grid.length * widget.grid[0].length,
                  itemBuilder: (context, index) {
                    int row = index ~/ widget.grid[0].length;
                    int col = index % widget.grid[0].length;

                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: _highlighted != null && _highlighted![row][col]
                              ? Colors.yellow
                              : Colors.white,
                          border: Border.all(color: Colors.black)),
                      alignment: Alignment.center,
                      child: Text(
                        widget.grid[row][col],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  Navigator.popUntil(
                      context, (route) => route.settings.name == "/gridInput");
                },
                child: const Text("Reset"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
