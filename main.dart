import 'package:flutter/material.dart';

void main() {
  runApp(SmartGridApp()); // Запускаємо головний застосунок
}

// Головний клас застосунку, який є StatelessWidget
// Він створює MaterialApp з темою та головною сторінкою DeviceInputPage
class SmartGridApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Grid', // Назва застосунку
      theme: ThemeData(primarySwatch: Colors.blue), // Тема оформлення
      home: DeviceInputPage(), // Головна сторінка
    );
  }
}

// Клас Device моделює пристрій у системі
// Має назву, потужність, час роботи та тип енергії
class Device {
  String name;
  double power;
  double hours;
  String energyType;

  // Конструктор для створення пристрою
  Device(this.name, this.power, this.hours, this.energyType);

  // Метод для розрахунку добового споживання
  double getConsumption() {
    return power * hours;
  }
}

// Сторінка введення параметрів пристроїв
class DeviceInputPage extends StatefulWidget {
  @override
  _DeviceInputPageState createState() => _DeviceInputPageState();
}

// Стан сторінки DeviceInputPage
class _DeviceInputPageState extends State<DeviceInputPage> {
  // Контролери для введення даних
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  // Тип енергії за замовчуванням
  String _selectedEnergyType = "electric";

  // Список пристроїв
  List<Device> devices = [];

  // Результат розрахунку
  String _result = "";

  // Метод для додавання пристрою у список
  void _addDevice() {
    String name = _nameController.text;
    double power = double.tryParse(_powerController.text) ?? 0;
    double hours = double.tryParse(_hoursController.text) ?? 0;

    // Створюємо новий пристрій
    Device device = Device(name, power, hours, _selectedEnergyType);

    // Оновлюємо стан: додаємо пристрій і очищуємо поля вводу
    setState(() {
      devices.add(device);
      _nameController.clear();
      _powerController.clear();
      _hoursController.clear();
    });
  }

  // Метод для розрахунку загального споживання
  void _calculateTotalConsumption() {
    double electricConsumption = 0;
    double thermalConsumption = 0;
    double solarConsumption = 0;

    // Проходимо по всіх пристроях і додаємо їх споживання до відповідного типу енергії
    for (var d in devices) {
      double consumption = d.getConsumption();
      if (d.energyType == "electric") {
        electricConsumption += consumption;
      } else if (d.energyType == "thermal") {
        thermalConsumption += consumption;
      } else if (d.energyType == "solar") {
        solarConsumption += consumption;
      }
    }

    // Загальне споживання
    double totalConsumption =
        electricConsumption + thermalConsumption + solarConsumption;

    // Оновлюємо результат
    setState(() {
      _result =
          "Електрична енергія: $electricConsumption Вт·год\n"
          "Теплова енергія: $thermalConsumption Вт·год\n"
          "Сонячна енергія: $solarConsumption Вт·год\n"
          "Загальне споживання: $totalConsumption Вт·год";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smart Grid - Пристрої")), // Заголовок сторінки
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле для введення назви пристрою
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Назва пристрою"),
            ),
            // Поле для введення потужності
            TextField(
              controller: _powerController,
              decoration: InputDecoration(labelText: "Потужність (Вт)"),
              keyboardType: TextInputType.number,
            ),
            // Поле для введення часу роботи
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(labelText: "Час роботи (год)"),
              keyboardType: TextInputType.number,
            ),
            // Вибір типу енергії через Dropdown
            DropdownButton<String>(
              value: _selectedEnergyType,
              items: [
                DropdownMenuItem(value: "electric", child: Text("Електрична")),
                DropdownMenuItem(value: "thermal", child: Text("Теплова")),
                DropdownMenuItem(value: "solar", child: Text("Сонячна")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedEnergyType = value!;
                });
              },
            ),
            SizedBox(height: 20),
            // Кнопка для додавання пристрою
            ElevatedButton(
              onPressed: _addDevice,
              child: Text("Додати пристрій"),
            ),
            SizedBox(height: 20),
            // Кнопка для розрахунку загального споживання
            ElevatedButton(
              onPressed: _calculateTotalConsumption,
              child: Text("Розрахувати загальне споживання"),
            ),
            SizedBox(height: 20),
            // Список усіх доданих пристроїв
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final d = devices[index];
                  return ListTile(
                    title: Text("${d.name} (${d.energyType})"),
                    subtitle: Text(
                        "Потужність: ${d.power} Вт, Час: ${d.hours} год, Споживання: ${d.getConsumption()} Вт·год"),
                  );
                },
              ),
            ),
            // Вивід результатів розрахунку
            Text(
              _result,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
