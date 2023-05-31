import 'package:flutter/material.dart';
import 'package:project_prak_tpm/Halaman_Utama.dart';
import 'package:project_prak_tpm/kalender.dart';
import 'package:project_prak_tpm/login.dart';
import 'package:project_prak_tpm/profil_us.dart';

class HalamanProfilIndrawani extends StatefulWidget {
  const HalamanProfilIndrawani({Key? key}) : super(key: key);

  @override
  State<HalamanProfilIndrawani> createState() => _HalamanProfilIndrawaniState();
}

class _HalamanProfilIndrawaniState extends State<HalamanProfilIndrawani> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage (
                    'images/iin.jpg'
                ),
                radius: 80,
              ),
              SizedBox(height: 16),
              Text(
                'INDRAWANI',
                style: TextStyle (
                    fontSize: 20, fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 8),
              Text(
                '123200018',
                style: TextStyle (
                    fontSize: 16
                ),
              ),
              SizedBox(height: 24),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('View Profile Details'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Nama'),
                      subtitle: Text('Indrawani'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Kelas'),
                      subtitle: Text('Pratikum Pemrograman Mobile IF-D'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.lightbulb),
                      title: Text('Harapan / Cita-cita'),
                      subtitle: Text('Cepat Lulus dan Keliling Benua'),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}