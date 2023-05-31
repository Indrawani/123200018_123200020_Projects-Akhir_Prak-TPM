import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_prak_tpm/login.dart';
import 'package:project_prak_tpm/profil_us.dart';
import 'halaman_utama.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({Key? key}) : super(key: key);

  @override
  _KalenderPageState createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  late DateTime _dateTime;
  late String _timezone;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _dateTime = _selectTimezone('WIB');
    _timezone = 'WIB';
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _dateTime = _selectTimezone(_timezone);
    });
    Future.delayed(const Duration(seconds: 1), () => _updateTime());
  }

  DateTime _selectTimezone(String timezone) {
    if (timezone == 'WIB') {
      return DateTime.now().toUtc().add(const Duration(hours: 7));
    } else if (timezone == 'WITA') {
      return DateTime.now().toUtc().add(const Duration(hours: 8));
    } else if (timezone == 'WIT') {
      return DateTime.now().toUtc().add(const Duration(hours: 9));
    } else {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Kalender'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: Colors.green,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          if (value == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DaftarAnggota())); // Navigasi ke halaman profil
          } else if (value == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KalenderPage())); // Navigasi ke halaman kalender
          }else if (value == 3) {
            AlertDialog alert = AlertDialog(
              title: Text("Logout"),
              content: Container(
                child: Text("Apakah Anda Yakin Ingin Logout?"),
              ),
              actions: [
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
            showDialog(context: context, builder: (context) => alert);
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HalamanUtama()));
          }
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Halaman Utama'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Profil'),
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            title: Text('Kalender'),
            icon: Icon(Icons.calendar_today),
          ),
          BottomNavigationBarItem(
            title: Text('Logout'),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 50),
          Text(
            'Todays Calendar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              height: 250,
              width: 450,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(_dateTime),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/jam.png',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          DateFormat('HH:mm:ss').format(_dateTime),
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimezoneButton('WIB'),
                        const SizedBox(width: 16),
                        _buildTimezoneButton('WITA'),
                        const SizedBox(width: 16),
                        _buildTimezoneButton('WIT'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimezoneButton(String timezone) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _timezone = timezone;
        });
      },
      child: Text(timezone),
      style: ElevatedButton.styleFrom(
        primary: _timezone == timezone ? Colors.green : Colors.grey[300],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
