import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Réservations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReservationList(),
    );
  }
}

class ReservationList extends StatefulWidget {
  const ReservationList({Key? key}) : super(key: key);

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  final List<Map<String, dynamic>> reservations = [
    {
      'structureName': 'Ruby Marie Hotel Wien',
      'description': '1 chambre, 1 salle de bain',
      'ownerName': 'Jean Dupont',
      'location': 'Vienne, Autriche',
      'mapUrl': 'https://www.google.com/maps/place/Royal+Beach+Hotel+Ouagadougou/@12.3909772,-1.4928515,15z/data=!4m14!1m2!2m1!1sRoyal+Beach+Hotel+Ouagadougou!3m10!1s0xe2ebf02e037d3bb:0x5545b5ee663d7a76!5m3!1s2024-12-27!4m1!1i2!8m2!3d12.3909772!4d-1.4737971!15sCh1Sb3lhbCBCZWFjaCBIb3RlbCBPdWFnYWRvdWdvdVofIh1yb3lhbCBiZWFjaCBob3RlbCBvdWFnYWRvdWdvdZIBBWhvdGVsmgEjQ2haRFNVaE5NRzluUzBWSlEwRm5TVU5ITW1ZeWNFSm5FQUXgAQD6AQQIABBE!16s%2Fg%2F11cn92yk0z?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D',
      'imagePath': 'assets/images/image1.avif',
      'startDate': DateTime(2024, 4, 1),
      'endDate': DateTime(2024, 4, 9),
      'price': 904.40,
      'nights': 8,
      'taxes': 126.14,
    },
    {
      'structureName': 'Villa Soleil',
      'description': '2 chambres, 1 cuisine équipée',
      'ownerName': 'Marie Curie',
      'location': 'Côte d\'Azur, France',
      'mapUrl': 'https://maps.app.goo.gl/W2n2D9m2muCwKwq57',
      'imagePath': 'assets/images/image2.jpg',
      'startDate': DateTime(2025, 1, 15),
      'endDate': DateTime(2025, 1, 20),
      'price': 1200.0,
      'nights': 5,
      'taxes': 200.0,
    },
    {
      'structureName': 'Camping Nature',
      'description': 'Tente de luxe, vue montagne',
      'ownerName': 'Paul Martin',
      'location': 'Les Alpes, Suisse',
      'mapUrl': 'https://maps.app.goo.gl/skKtrc1AFAeLixow9',
      'imagePath': 'assets/images/image3.jpg',
      'startDate': DateTime(2025, 3, 5),
      'endDate': DateTime(2025, 3, 12),
      'price': 500.0,
      'nights': 7,
      'taxes': 50.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Réservations'),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return ReservationCard(
            structureName: reservation['structureName'] as String,
            description: reservation['description'] as String,
            ownerName: reservation['ownerName'] as String,
            location: reservation['location'] as String,
            mapUrl: reservation['mapUrl'] as String,
            imagePath: reservation['imagePath'] as String,
            startDate: reservation['startDate'] as DateTime,
            endDate: reservation['endDate'] as DateTime,
            price: reservation['price'] as double,
            nights: reservation['nights'] as int,
            taxes: reservation['taxes'] as double,
          );
        },
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String structureName;
  final String description;
  final String ownerName;
  final String location;
  final String mapUrl;
  final String imagePath; // Chemin de l'image locale
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final int nights;
  final double taxes;

  const ReservationCard({
    required this.structureName,
    required this.description,
    required this.ownerName,
    required this.location,
    required this.mapUrl,
    required this.imagePath,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.nights,
    required this.taxes,
    Key? key,
  }) : super(key: key);

  Future<void> _launchMap(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedStartDate =
        DateFormat('EEE d MMM', 'fr_FR').format(startDate);
    final formattedEndDate = DateFormat('EEE d MMM', 'fr_FR').format(endDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image et titre
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath, // Charge l'image locale
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        structureName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     
                      const SizedBox(height: 4),
                      Text(
                        "👤 Propriétaire : $ownerName",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => _launchMap(mapUrl),
                        child: Text(
                          "📍 Localisation : $location",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
              Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                      ),
            // Détails
            Text(
              "📅 Arrivée : $formattedStartDate\n📅 Départ : $formattedEndDate\n🕒 Séjour de $nights nuits",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),

            // Prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chambre :', style: TextStyle(fontSize: 14)),
                Text('${nights} nuits', style: const TextStyle(fontSize: 14)),
                Text('${price - taxes} xof', style: const TextStyle(fontSize: 14)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Frais :', style: TextStyle(fontSize: 14)),
                Text('${taxes.toStringAsFixed(2)} xof',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Montant total :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${price.toStringAsFixed(2)} xof',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
