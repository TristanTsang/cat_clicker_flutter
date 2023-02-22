import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  bool isRunning = false;
  int counter = 0;
  int record =0;
  late final AnimationController _controller =AnimationController(
    duration: Duration(milliseconds: 1500),
    vsync: this,

  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  late final AnimationController _controllerScale = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward;
  late final Animation<double> _animationScale = CurvedAnimation(
    parent: _controllerScale,
    curve: Curves.linear,
  );
  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    _controllerScale.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("CatClicker"),
      ),
      body: Stack(children: [
        GestureDetector(
          onTap: (){if(isRunning){setState(() {
            counter++;
          });}},
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.15,
                ),
    RotationTransition(
    turns: _animation,
    child: Image(width: MediaQuery.of(context).size.width * 0.5, fit: BoxFit.fill, image: AssetImage("images/CAT.png")),

    )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Clicks: ", style: TextStyle(fontSize: 20)),
                  Text("$counter",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Record: ", style: TextStyle(fontSize: 20)),
                  Text("$record",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () async {
                      if(!isRunning){
                        setState(() {
                          counter =0;
                          isRunning = true;
                        });
                        await Future.delayed(Duration(seconds:3));
                        setState(() {

                          isRunning = false;
                          if(counter>record) {
                            record = counter;
                          }
                        });
                      }
                      
                    },
                    child: Text(
                      "Start!",
                      style: TextStyle(fontSize: 15),
                    ),
                    style: ButtonStyle(
                      foregroundColor: !isRunning ? MaterialStatePropertyAll(Colors.white): MaterialStatePropertyAll(Colors.grey[800]),
                      backgroundColor: !isRunning ? MaterialStatePropertyAll(Colors.purple) : MaterialStatePropertyAll(Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}

