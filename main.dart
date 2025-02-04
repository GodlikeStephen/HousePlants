import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



void main() => runApp(PlantCareApp());

class PlantCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Care',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PlantListScreen(),
    );
  }
}

class Plant {
  String name;
  String type;
  DateTime lastWatered;
  int waterFrequency;
  String imageUrl;

  Plant({
    required this.name,
    required this.type,
    required this.lastWatered,
    required this.waterFrequency,
    this.imageUrl = 'assets/default_plant.png',
  });

  String get nextWatering {
    final nextDate = lastWatered.add(Duration(days: waterFrequency));
    return DateFormat('dd MMM yyyy').format(nextDate);
  }
}

class PlantListScreen extends StatefulWidget {
  @override
  _PlantListScreenState createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  final List<Plant> plants = [
    Plant(
      name: "Монстера",
      type: "Декоративно растение",
      lastWatered: DateTime.now().subtract(Duration(days: 2)),
      waterFrequency: 7,
    ),
    Plant(
      name: "Кактус",
      type: "Сукулент",
      lastWatered: DateTime.now().subtract(Duration(days: 5)),
      waterFrequency: 14,
    ),
  ];

  void _addNewPlant(Plant newPlant) {
    setState(() {
      plants.add(newPlant);
    });
  }

  void _markAsWatered(Plant plant) {
    setState(() {
      plant.lastWatered = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Моите растения'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (ctx, index) {
          final plant = plants[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(plant.imageUrl),
              ),
              title: Text(plant.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.type),
                  Text(
                    'Следващо поливане: ${plant.nextWatering}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.opacity),
                color: Colors.blue,
                onPressed: () => _markAsWatered(plant),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlantDetailScreen(plant: plant),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddPlantScreen(addPlant: _addNewPlant),
          ),
        ),
      ),
    );
  }
}

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  PlantDetailScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plant.name)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(plant.imageUrl, height: 200, width: double.infinity),
            SizedBox(height: 20),
            Text('Вид: ${plant.type}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Последно поливане: ${DateFormat('dd MMM yyyy').format(plant.lastWatered)}'),
            SizedBox(height: 10),
            Text('Поливане на всеки ${plant.waterFrequency} дни'),
          ],
        ),
      ),
    );
  }
}

class AddPlantScreen extends StatefulWidget {
  final Function(Plant) addPlant;

  AddPlantScreen({required this.addPlant});

  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = '';
  int _waterFrequency = 7;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.addPlant(
        Plant(
          name: _name,
          type: _type,
          lastWatered: DateTime.now(),
          waterFrequency: _waterFrequency,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добави ново растение')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Име на растение'),
                validator: (value) => value!.isEmpty ? 'Въведете име' : null,
                onChanged: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Вид'),
                validator: (value) => value!.isEmpty ? 'Въведете вид' : null,
                onChanged: (value) => _type = value,
              ),
              DropdownButtonFormField<int>(
                value: _waterFrequency,
                items: [7, 10, 14, 21, 30]
                    .map((days) => DropdownMenuItem(
                          value: days,
                          child: Text('На всеки $days дни'),
                        ))
                    .toList(),
                onChanged: (value) => _waterFrequency = value!,
                decoration: InputDecoration(labelText: 'Честота на поливане'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Добави растение'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}