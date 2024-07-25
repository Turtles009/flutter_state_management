import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}

String now() => DateTime.now().toIso8601String();

@immutable
class Seconds {
  final String value;

  Seconds() : value = now();
}

class Minutes {
  final String value;

  Minutes() : value = now();
}

class SecondsWidget extends StatelessWidget {
  const SecondsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<Seconds>();
    return Expanded(
      child: Container(
        height: 100,
        color: Colors.yellow,
        child: Text(
          seconds.value,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MinutesWidget extends StatelessWidget {
  const MinutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final minutes = context.watch<Minutes>();
    return Expanded(
      child: Container(
        height: 100,
        color: Colors.blue,
        child: Text(
          minutes.value,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Stream<String> newStream(Duration duration) => Stream.periodic(
      duration,
      (_) => now(),
    );

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App'),
      ),
      body: MultiProvider(
        providers: [
          StreamProvider.value(
            value: Stream<Seconds>.periodic(
                const Duration(seconds: 1), (_) => Seconds()),
            initialData: Seconds(),
          ),
          StreamProvider.value(
            value: Stream<Minutes>.periodic(
                const Duration(minutes: 1), (_) => Minutes()),
            initialData: Minutes(),
          )
        ],
        child: const Column(
          children: [
            Row(
              children: [
                SecondsWidget(),
                MinutesWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
