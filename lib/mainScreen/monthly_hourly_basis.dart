import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class MonthlyORHourlyBasis extends StatefulWidget {
  @override
  _MonthlyORHourlyBasisState createState() => _MonthlyORHourlyBasisState();
}

class _MonthlyORHourlyBasisState extends State<MonthlyORHourlyBasis> {
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _selectedType = 'Hourly';

  void _postVehicle() async {
    final id = DateTime.now().toIso8601String();
    final type = _selectedType;
    final fee = _feeController.text;
    final vehicleType = _vehicleTypeController.text;
    final vehicleModel = _vehicleModelController.text;
    final contact = _contactController.text;

    final url =
        'https://friendly-folio-425114-v9-default-rtdb.firebaseio.com/rental.json';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'id': id,
        'type': type,
        'fee': fee,
        'vehicle_type': vehicleType,
        'vehicle_model': vehicleModel,
        'contact': contact,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehicle posted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post vehicle.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Panel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Hourly'),
                  selected: _selectedType == 'Hourly',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = 'Hourly';
                    });
                  },
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text('Monthly'),
                  selected: _selectedType == 'Monthly',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = 'Monthly';
                    });
                  },
                ),
              ],
            ),
            TextField(
              controller: _feeController,
              decoration: InputDecoration(labelText: 'Fee'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _vehicleTypeController,
              decoration: InputDecoration(labelText: 'Vehicle Type'),
            ),
            TextField(
              controller: _vehicleModelController,
              decoration: InputDecoration(labelText: 'Vehicle Model'),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contact'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _postVehicle,
              child: Text('Post Vehicle'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with SingleTickerProviderStateMixin {
  List<dynamic> _hourlyVehicles = [];
  List<dynamic> _monthlyVehicles = [];
 late TabController _tabController;

  void _fetchVehicles() async {
    final url =
        'https://friendly-folio-425114-v9-default-rtdb.firebaseio.com/rental.json';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> vehicles = data.values.toList();
      final List<dynamic> hourlyVehicles = vehicles.where((vehicle) => vehicle['type'] == 'Hourly').toList();
      final List<dynamic> monthlyVehicles = vehicles.where((vehicle) => vehicle['type'] == 'Monthly').toList();

      setState(() {
        _hourlyVehicles = hourlyVehicles;
        _monthlyVehicles = monthlyVehicles;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch vehicles.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchVehicles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _callContact(String contact) async {
    final url = 'tel:$contact';
    if (await canLaunchUrl (Uri.parse(url))) {
      await launchUrl (Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
  Widget _buildVehicleList(List<dynamic> vehicles) {
    return vehicles.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.directions_car_filled ,size: 40,color: Colors.orangeAccent,),
                    title: Text('${vehicle['vehicle_type']}(${vehicle['vehicle_model']})',style: TextStyle(color: Colors.orangeAccent,fontSize: 19),),
                    subtitle: Text('Contact: ${vehicle['contact']}\nFee: ${vehicle['fee']}',style: TextStyle(fontSize: 16),),
                    trailing: IconButton(
                    icon: Icon(Icons.phone,),
                    onPressed: () => _callContact(vehicle['contact']),
                  ),
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Rent Car'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Hourly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVehicleList(_hourlyVehicles),
          _buildVehicleList(_monthlyVehicles),
        ],
      ),
    );
  }
}
