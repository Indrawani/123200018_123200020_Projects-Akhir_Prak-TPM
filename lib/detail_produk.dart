import 'package:flutter/material.dart';
import 'package:project_prak_tpm/Halaman_Utama.dart';
import 'package:project_prak_tpm/login.dart';
import 'package:project_prak_tpm/profil_us.dart';
import 'kalender.dart';
import 'list_produk.dart';
import 'package:intl/intl.dart';

class Order {
  final String mealName;
  final int quantity;
  final double totalPrice;

  Order({
    required this.mealName,
    required this.quantity,
    required this.totalPrice,
  });
}

class MealDetailPage extends StatefulWidget {
  final Meal meal;
  const MealDetailPage({required this.meal});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  int _currentIndex = 0;
  Order? order;

  int quantity = 1;
  double price = 10.0; // Tetapkan harga secara manual
  String selectedCurrency = 'IDR'; // Mata uang yang dipilih

  Map<String, double> exchangeRates = {
    'USD': 0.0000714, // Kurs pertukaran IDR ke USD
    'EUR': 0.0000607, // Kurs pertukaran IDR ke EUR
    'IDR': 1.0, // Kurs pertukaran IDR ke IDR (1 IDR = 1 IDR)
    'GBP': 0.0000512, // Kurs pertukaran IDR ke GBP
    'JPY': 0.00714, // Kurs pertukaran IDR ke JPY
  };

  double get selectedPrice {
    if (selectedCurrency != 'IDR') {
      return price * exchangeRates[selectedCurrency]!;
    } else {
      return price;
    }
  }

  double get totalHarga {
    return selectedPrice * quantity;
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  void addToCart() {
    final newOrder = Order(
      mealName: widget.meal.name,
      quantity: quantity,
      totalPrice: totalHarga,
    );

    setState(() {
      order = newOrder;
    });

    print('Makanan ${widget.meal.name} dengan jumlah $quantity ditambahkan ke keranjang. Total Harga: \$${totalHarga.toStringAsFixed(5)}');
  }

  void _showCheckoutPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Terimakasih !"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pesanan Anda sedang dikemas.",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Detail Pesanan:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Text("Makanan: ${widget.meal.name}"),
              Text("Jumlah: $quantity"),
              Text("Total Harga: \$${totalHarga.toStringAsFixed(5)}"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                addToCart(); // rekam data yg di input
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.name),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  widget.meal.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      Center(
                        child: Text(
                          widget.meal.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Center(
                        child: Text(
                          "Category: ${widget.meal.category}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: decreaseQuantity,
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    onPressed: increaseQuantity,
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total :",
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8.0), // Spasi antara teks "Total :" dan hasilnya
                          Text(
                            "${totalHarga.toStringAsFixed(5)} $selectedCurrency",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Pilih Mata Uang",
                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          DropdownButton<String>(
                            value: selectedCurrency,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCurrency = newValue!;
                              });
                            },
                            items: exchangeRates.keys.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      FractionallySizedBox(
                        widthFactor: 0.8, // Lebar tombol relatif terhadap lebar layar (80%)
                        child: ElevatedButton(
                          onPressed: _showCheckoutPopup, // Memanggil method _showCheckoutPopup saat tombol diklik
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.0),
                              onTap: _showCheckoutPopup, // Memanggil method _showCheckoutPopup saat tombol diklik
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'CheckOut',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}