import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:nhcoree/Database/IpConfig.dart';

class Donasi extends StatefulWidget {
  const Donasi({super.key});

  @override
  State<Donasi> createState() => _DonasiState();
}

class _DonasiState extends State<Donasi> {
  String? selectedNominal; // Default nilai null
  TextEditingController nominalController =
      TextEditingController(text: 'Rp. 0');
  String selectedTujuan = ''; // Default tujuan donasi

  @override
  void initState() {
    super.initState();
    MidtransSDK.init(
      config: MidtransConfig(
        clientKey: 'SB-Mid-client-Cus_lO_5JXzHSIcU',
        merchantBaseUrl: "${IpConfig.baseUrl}/api/create-transaction",
      ),
    );
  }

  @override
  void dispose() {
    nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DONASI',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA4C751)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/new_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Data Diri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0), // Add padding as needed
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Nama Lengkap',
                    hintStyle: const TextStyle(color: Color(0xff8F9BA1)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true, // Set filled to true
                    fillColor: const Color(0xFFEAEAEA),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0), // Add padding as needed
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan No WhatsApp',
                    hintStyle: const TextStyle(color: Color(0xff8F9BA1)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true, // Set filled to true
                    fillColor: const Color(0xFFEAEAEA),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Konfirmasi Pembayaran',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0), // Add padding as needed
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Email',
                    hintStyle: const TextStyle(color: Color(0xff8F9BA1)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true, // Set filled to true
                    fillColor: const Color(0xFFEAEAEA),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Doa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Cantumkan Doa Terbaik Untuk Diri dan Keluarga',
                      hintStyle: const TextStyle(color: Color(0xff8F9BA1)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      filled: true, // Set filled to true
                      fillColor: const Color(0xFFEAEAEA),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nominal Donasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: TextFormField(
                  controller: nominalController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty) {
                        return newValue;
                      } else {
                        final int? parsedValue = int.tryParse(newValue.text);
                        if (parsedValue != null) {
                          final f = NumberFormat.currency(
                              locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
                          final formattedValue = f.format(parsedValue);
                          return TextEditingValue(
                            text: formattedValue,
                            selection: TextSelection.collapsed(
                                offset: formattedValue.length),
                          );
                        }
                      }
                      return newValue;
                    }),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xFFEAEAEA),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFEAEAEA),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedNominal,
                      hint: const Text('Pilih nominal donasi'),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedNominal = newValue!;
                          nominalController.text = 'Rp. $selectedNominal';
                        });
                      },
                      items: <String>['', '10000', '25000', '50000', '100000']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: value != ''
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text('Rp. $value'),
                                )
                              : const Text('Pilih nominal donasi',
                                  style: TextStyle(color: Colors.grey)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFEAEAEA),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedTujuan,
                      hint: const Text('Pilih tujuan donasi'),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTujuan = newValue!;
                        });
                      },
                      items: <String>['', 'Pembangunan', 'Santunan']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: value.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(value),
                                )
                              : const Text('Pilih tujuan donasi',
                                  style: TextStyle(color: Colors.grey)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA4C751),
                    minimumSize: const Size(370, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (selectedNominal != null && selectedTujuan != '') {
                      MidtransSDK().startPaymentUiFlow(token: 'TOKEN');
                    } else {
                      // Show error message or alert dialog if the user hasn't filled in all the required fields
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silahkan Isi Coloum yang Kosong!'),
                        ),
                      );
                    }
                  },
                  child: const Text('Bayar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
