import 'package:flutter/material.dart';
import 'package:project_prak_tpm/Halaman_Utama.dart';
import 'package:project_prak_tpm/detail_profil1.dart';
import 'package:project_prak_tpm/detail_profil2.dart';
import 'package:project_prak_tpm/kalender.dart';
import 'package:project_prak_tpm/login.dart';


class DaftarAnggota extends StatefulWidget {
  const DaftarAnggota({Key? key}) : super(key: key);

  @override
  State<DaftarAnggota> createState() => _DaftarAnggotaState();
}

class Anggota {
  final String nama;
  final String nim;
  final String foto;

  Anggota({
    required this.nama,
    required this.nim,
    required this.foto,
  });
}

final daftarAnggota = [
  Anggota(
    nama: 'Indrawani',
    nim: '123200018',
    foto: 'images/iin.jpg',
  ),
  Anggota(
    nama: 'Ergyna Islamia',
    nim: '123200020',
    foto: 'images/ergy.jpg',
  ),
];

class _DaftarAnggotaState extends State<DaftarAnggota> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Anggota'),
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
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: daftarAnggota.length,
              itemBuilder: (BuildContext context, int index) {
                final anggota = daftarAnggota[index];
                return Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(anggota.foto),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                anggota.nama,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'NIM: ${anggota.nim}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (anggota.nama == 'Indrawani') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HalamanProfilIndrawani(),
                                        ),
                                      );
                                    } else if (anggota.nama == 'Ergyna Islamia') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HalamanProfilErgy(),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text("Lihat Detail Profil"),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(40),
                                    onPrimary: Colors.white,
                                    shape: const RoundedRectangleBorder(),
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}