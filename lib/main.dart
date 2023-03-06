import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'When Pickup?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final length = useState(3);
    final date = useState(DateTime.now());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('When drop off?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    DateTime val = await showDialog(
                        context: context,
                        builder: (context) {
                          return DatePickerDialog(
                            initialDate: date.value,
                            firstDate:
                                date.value.subtract(const Duration(days: 30)),
                            lastDate: date.value.add(const Duration(days: 30)),
                          );
                        });

                    date.value = DateTime(
                      val.year,
                      val.month,
                      val.day,
                      date.value.hour,
                      date.value.minute,
                    );
                  },
                  child: Text(Jiffy(date.value).yMMMd),
                ),
                TextButton(
                  onPressed: () async {
                    TimeOfDay val = await showDialog(
                        context: context,
                        builder: (context) {
                          return TimePickerDialog(
                            initialTime: TimeOfDay.fromDateTime(date.value),
                          );
                        });

                    date.value = DateTime(
                      date.value.year,
                      date.value.month,
                      date.value.day,
                      val.hour,
                      val.minute,
                    );
                  },
                  child: Text(Jiffy(date.value).format('h:mm a')),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('How long?'),
            SizedBox(
              width: 80,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '3',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isEmpty || int.parse(value) <= 0) {
                          length.value = 1;
                        } else {
                          length.value = int.parse(value).clamp(1, 9999999999);
                        }
                      },
                    ),
                  ),
                  const Text('days'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('When pickup?'),
            SelectableText(
              Jiffy(date.value.add(Duration(days: length.value)))
                  .format("EEEE, MMMM do yyyy, h:mm a"),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
