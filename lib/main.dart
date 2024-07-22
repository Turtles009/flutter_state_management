import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: APIProvider(
        api: API(),
        child: const HomePage(),
      ),
    );
  }
}

class APIProvider extends InheritedWidget {
  final API api;
  final String uuid;

  APIProvider({
    super.key,
    required super.child,
    required this.api,
  }) : uuid = const Uuid().v4();

  @override
  bool updateShouldNotify(covariant APIProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static APIProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<APIProvider>()!;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueKey _textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APIProvider.of(context).api.dateAndTime ?? ''),
      ),
      body: GestureDetector(
        onTap: () async {
          final api = APIProvider.of(context).api;
          final dateAndTime = await api.getDateAndTime();
          setState(() {
            _textKey = ValueKey(dateAndTime);
          });
        },
        child: Container(
          color: Colors.white,
          child: Center(
            child: DateTimeWidget(
              key: _textKey,
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final api = APIProvider.of(context).api;
    return Text(
      api.dateAndTime ?? 'Tap on the screen to fetch date and time.',
    );
  }
}

class API {
  String? dateAndTime;

  Future<String> getDateAndTime() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    ).then(
      (value) {
        dateAndTime = value;
        return value;
      },
    );
  }
}
