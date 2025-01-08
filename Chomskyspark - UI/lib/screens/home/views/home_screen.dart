import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                   margin: const EdgeInsets.only(top: 20.0),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chomskyspark',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Plus Jakarta',
                          //fontWeight: FontWeight.bold,
                          color: Colors.black

                        ),
                      ),
                      IconButton(
                        onPressed: () {

                        },
                        icon: Icon(Icons.menu, color: Colors.black),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Add button functionality
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Counter'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'You are doing Excellent,',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nickname',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Find Object'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF5B7E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Discover a Word'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF5B7E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 245,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/images/nesto.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add camera functionality
                        },
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        label: Text('Take a Picture'),
                            style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xFFFF5B7E),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
