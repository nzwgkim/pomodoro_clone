import 'dart:async';

import 'package:flutter/material.dart';

const bgColor = 0xffE64D3D;

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static List<int> TimerList = [15, 20, 25, 30, 35];
  static int runSeconds = TimerList[2] * 60;
  int totalSeconds = runSeconds; // 25분 == 1500 초
  late Timer timer;
  bool isRunning = false;
  int totalPomodoro = 0;
  int totalGoal = 0;

  bool isBreak = false;
  int breakSeconds = 5 * 60;

  void OnTick(Timer timer) {
    // print(timer.tick);
    setState(() {
      if (totalSeconds != 0) {
        if (totalPomodoro == 4) {
          totalPomodoro = 0;
        }
        if (totalGoal == 12) {
          totalGoal = 0;
        }
        --totalSeconds;
      } else {
        if (isBreak == false) {
          isBreak = true;
          ++totalPomodoro;
          totalSeconds = breakSeconds; //setTime;

          if (totalPomodoro == 4) {
            totalGoal++;
            totalSeconds = runSeconds;
            isRunning = false;
            isBreak = false;
            timer.cancel();
          }
        } else {
          totalSeconds = runSeconds;
          isBreak = false;
        }
      }
    });
    print(totalSeconds);
  }

  void onStartPressed() {
    if (!isRunning) {
      timer = Timer.periodic(const Duration(seconds: 1), OnTick);
    }
    isRunning = true;

    print('Start, isRunning=$isRunning');
  }

  void onPausePressed() {
    if (timer.isActive) {
      timer.cancel();
      setState(() {
        isRunning = false;
      });
    }
    print('Pause, isRunning=$isRunning');
  }

  void onResetPressed() {
    setState(() {
      totalPomodoro = 0;
      totalGoal = 0;
      isRunning = false;
      totalSeconds = runSeconds;
      timer.cancel();
    });
  }

  String formatMinute(int sec) {
    var dur = Duration(seconds: sec);
    // print(dur.toString().split('.').first.substring(2, 7));
    // substring(int start, [int? end]) → String
    // The substring of this string from [start], inclusive, to [end], exclusive.
    return dur.toString().split('.').first.substring(2, 4);
  }

  String formatSecond(int sec) {
    print('seconds: $sec');

    var dur = Duration(seconds: sec);
    // print(dur.toString().split('.').first.substring(2, 7));
    // substring(int start, [int? end]) → String
    // The substring of this string from [start], inclusive, to [end], exclusive.
    return dur.toString().split('.').first.substring(5, 7);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(bgColor),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const TopPart(),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                          child: Text(formatMinute(totalSeconds),
                              style: TextStyle(
                                  fontSize: 80,
                                  color: isBreak
                                      ? Colors.blue
                                      : const Color(0xffBF3A2B),
                                  fontWeight: FontWeight.w700)),
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                              fontSize: 80,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                          child: Text(formatSecond(totalSeconds),
                              style: TextStyle(
                                  fontSize: 80,
                                  color: isBreak
                                      ? Colors.blue
                                      : const Color(0xffBF3A2B),
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: TimerList.map(
                        (e) => OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.yellow),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                isRunning ? Colors.grey : Colors.white),
                          ),
                          child: Text(
                            e.toString(),
                            style: TextStyle(
                                fontSize: 25,
                                color: isRunning
                                    ? Colors.black
                                    : const Color(0xffBF3A2B)),
                          ),
                          onPressed: () {
                            if (isRunning != true) {
                              runSeconds = e * 60;
                              totalSeconds = runSeconds;
                              setState(() {});
                              print(runSeconds);
                            } else {
                              print('Disabled');
                            }
                          },
                        ),
                      ).toList(),
                    )),
                    // Expanded(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       OutlinedButton(
                    //         style: ButtonStyle(
                    //           foregroundColor: MaterialStateProperty.all<Color>(
                    //               Colors.yellow),
                    //           backgroundColor: MaterialStateProperty.all<Color>(
                    //               Colors.white),
                    //         ),
                    //         child: const Text(
                    //           '15',
                    //           style: TextStyle(fontSize: 25),
                    //         ),
                    //         onPressed: () {
                    //           if (isRunning != true) {
                    //             runSeconds = 15 * 60;
                    //             totalSeconds = runSeconds;
                    //             setState(() {});
                    //             print(runSeconds);
                    //           } else {
                    //             print('Disabled');
                    //           }
                    //         },
                    //       ),
                    //       TextButton(
                    //         child: const Text('20'),
                    //         onPressed: () {
                    //           if (isRunning != true) {
                    //             runSeconds = 20 * 60;
                    //             totalSeconds = runSeconds;
                    //             setState(() {});
                    //             print(runSeconds);
                    //           } else {
                    //             print('Disabled');
                    //           }
                    //         },
                    //       ),
                    //       OutlinedButton(
                    //         child: const Text('25'),
                    //         onPressed: () {
                    //           if (isRunning != true) {
                    //             runSeconds = 25 * 60;
                    //             totalSeconds = runSeconds;
                    //             setState(() {});
                    //             print(runSeconds);
                    //           } else {
                    //             print('Disabled');
                    //           }
                    //         },
                    //       ),
                    //       OutlinedButton(
                    //         child: Text(
                    //           '30',
                    //           style: TextStyle(
                    //               color: Colors.grey.withOpacity(0.8)),
                    //         ),
                    //         onPressed: () {
                    //           if (isRunning != true) {
                    //             runSeconds = 30 * 60;
                    //             totalSeconds = runSeconds;
                    //             setState(() {});
                    //             print(runSeconds);
                    //           } else {
                    //             print('Disabled');
                    //           }
                    //         },
                    //       ),
                    //       OutlinedButton(
                    //         child: const Text('35'),
                    //         onPressed: () {
                    //           if (isRunning != true) {
                    //             runSeconds = 35 * 60;
                    //             totalSeconds = runSeconds;
                    //             setState(() {});
                    //             print(runSeconds);
                    //           } else {
                    //             print('Disabled');
                    //           }
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IconButton(
                        onPressed: isRunning ? onPausePressed : onStartPressed,
                        icon: Icon(
                          isRunning
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          color:
                              isBreak ? Colors.blue : const Color(0xffBF3A2B),
                          size: 90,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text('$totalPomodoro/4',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30)),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'ROUND',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text('$totalGoal/12',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30)),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'GOAL',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class MiddlePart extends StatelessWidget {
  final String minute, second;
  final bool isBreak;

  const MiddlePart(
      {super.key,
      required this.minute,
      required this.second,
      required this.isBreak});

  @override
  Widget build(BuildContext context) {
    int selectedNumber = 30;

    return Expanded(
        flex: 2,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: Text(minute,
                      style: TextStyle(
                          fontSize: 80,
                          color:
                              isBreak ? Colors.blue : const Color(0xffBF3A2B),
                          fontWeight: FontWeight.w700)),
                ),
                Text(
                  ':',
                  style: TextStyle(
                      fontSize: 80, color: Colors.white.withOpacity(0.5)),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: Text(second,
                      style: TextStyle(
                          fontSize: 80,
                          color:
                              isBreak ? Colors.blue : const Color(0xffBF3A2B),
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.yellow),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    '15',
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text('20'),
                  onPressed: () {},
                ),
                OutlinedButton(
                  child: const Text('25'),
                  onPressed: () {},
                ),
                OutlinedButton(
                  child: const Text('30'),
                  onPressed: () {},
                ),
                OutlinedButton(
                  child: const Text('35'),
                  onPressed: () {},
                ),
              ],
            )

                // GestureDetector(
                //   onTap: () {},
                //   child: ListView.separated(
                //       scrollDirection: Axis.horizontal,
                //       itemBuilder: (context, index) => Text(
                //             TimerList[index].toString(),
                //             style: const TextStyle(
                //                 fontSize: 30, color: Colors.white),
                //           ),
                //       separatorBuilder: (context, index) =>
                //           const SizedBox(width: 40),
                //       itemCount: TimerList.length),
                // ),
                )
          ],
        ));
  }
}

class TopPart extends StatelessWidget {
  const TopPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              SizedBox(
                height: 20,
              ),
              Text(
                'POMOTIMER',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }
}
