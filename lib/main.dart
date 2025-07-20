import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

enum PageType { home, map, settings }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike App',
      debugShowCheckedModeBanner: false,
      home: MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  PageType selectedPage = PageType.home;
  bool isSidebarOpen = false;

  Widget _buildPage() {
    switch (selectedPage) {
      case PageType.map:
        return MapPage();
      case PageType.settings:
        return SettingsPage();
      case PageType.home:
      default:
        return HomePage();
    }
  }

  Widget _buildSidebarButton(String label, PageType page) {
    final isSelected = selectedPage == page;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedPage = page;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color.fromARGB(255, 125, 177, 150) : Colors.white,
          foregroundColor: Colors.black,
          minimumSize: Size(80, 55),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: isSidebarOpen ? 120 : 60,
            color: const Color.fromARGB(255, 192, 192, 192),
            child: Column(
              children: [
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.menu, color: const Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () {
                    setState(() {
                      isSidebarOpen = !isSidebarOpen;
                    });
                  },
                ),
                if (isSidebarOpen) ...[
                  _buildSidebarButton("首頁", PageType.home),
                  _buildSidebarButton("地圖", PageType.map),
                  _buildSidebarButton("設定", PageType.settings),
                ]
              ],
            ),
          ),
          Expanded(child: _buildPage())
        ],
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255), 
      child: Stack(
        children: [
          Center(
            child: Text(
              "即時影像",
              style: TextStyle(fontSize: 30, color: Colors.grey[500]),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 120,
            right: 20,
            child: Container(
              height: 80,
              color: const Color.fromARGB(235, 235, 235, 235).withOpacity(0.9),
              child: Center(
                child: Text("資訊顯示", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  final LatLng center = LatLng(25.0330, 121.5654); // 台北 101

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: center,
            zoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.bike_app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 40,
                  height: 40,
                  child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 30,
          left: 120,
          right: 20,
          child: Container(
            height: 80,
            color: const Color.fromARGB(235, 235, 235, 235).withOpacity(0.9),
            child: Center(
              child: Text("資訊顯示", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Center(
        child: Text("設定頁面", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
