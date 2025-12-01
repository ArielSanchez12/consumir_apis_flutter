import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(PokemonApp());
}

class PokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumir APIs',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    PokemonSearch(),
    PhoneValidation(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokémon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Validar Número telefónico',
          ),
        ],
      ),
    );
  }
}

// POKEMON API
class PokemonSearch extends StatefulWidget {
  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _pokemon;
  bool _isLoading = false;
  String? _error;

  Future<void> searchPokemon(String name) async {
    if (name.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _pokemon = null;
    });

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase().trim()}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _pokemon = {
            'name': data['name'],
            'image': data['sprites']['front_default'],
            'height': data['height'],
            'weight': data['weight'],
            'types': (data['types'] as List)
                .map((t) => t['type']['name'])
                .join(', '),
            'abilities': (data['abilities'] as List)
                .map((a) => a['ability']['name'])
                .join(', '),
            'stats': (data['stats'] as List)
                .map((s) => '${s['stat']['name']}: ${s['base_stat']}')
                .join('\n'),
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Pokémon no encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nombre del Pokémon (ej: pikachu)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: searchPokemon,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => searchPokemon(_controller.text),
                  child: Text('Buscar'),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_pokemon != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _pokemon!['name'].toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (_pokemon!['image'] != null)
                            Image.network(_pokemon!['image'], height: 150),
                          SizedBox(height: 16),
                          Text('Altura: ${_pokemon!['height']}'),
                          Text('Peso: ${_pokemon!['weight']}'),
                          Text('Tipos: ${_pokemon!['types']}'),
                          Text('Habilidades: ${_pokemon!['abilities']}'),
                          SizedBox(height: 8),
                          Text(
                            'Estadísticas:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(_pokemon!['stats']),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// PHONE VALIDATION API
class PhoneValidation extends StatefulWidget {
  @override
  _PhoneValidationState createState() => _PhoneValidationState();
}

class _PhoneValidationState extends State<PhoneValidation> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _phoneData;
  bool _isLoading = false;
  String? _error;
  String _selectedPrefix = '593'; // Ecuador por defecto

  final String _apiKey = 'b0b2d4c349899b15752b174f1ad57fea';

  // Lista de países con sus prefijos
  final List<Map<String, String>> _countries = [
    {'name': 'Ecuador', 'prefix': '593'},
    {'name': 'Estados Unidos', 'prefix': '1'},
    {'name': 'México', 'prefix': '52'},
    {'name': 'España', 'prefix': '34'},
    {'name': 'Argentina', 'prefix': '54'},
    {'name': 'Colombia', 'prefix': '57'},
    {'name': 'Perú', 'prefix': '51'},
    {'name': 'Chile', 'prefix': '56'},
    {'name': 'Venezuela', 'prefix': '58'},
    {'name': 'Brasil', 'prefix': '55'},
    {'name': 'Bolivia', 'prefix': '591'},
    {'name': 'Paraguay', 'prefix': '595'},
    {'name': 'Uruguay', 'prefix': '598'},
    {'name': 'Panamá', 'prefix': '507'},
    {'name': 'Costa Rica', 'prefix': '506'},
    {'name': 'Guatemala', 'prefix': '502'},
    {'name': 'Honduras', 'prefix': '504'},
    {'name': 'El Salvador', 'prefix': '503'},
    {'name': 'Nicaragua', 'prefix': '505'},
    {'name': 'Cuba', 'prefix': '53'},
    {'name': 'Rep. Dominicana', 'prefix': '1809'},
    {'name': 'Puerto Rico', 'prefix': '1787'},
    {'name': 'Canadá', 'prefix': '1'},
    {'name': 'Reino Unido', 'prefix': '44'},
    {'name': 'Francia', 'prefix': '33'},
    {'name': 'Alemania', 'prefix': '49'},
    {'name': 'Italia', 'prefix': '39'},
    {'name': 'Portugal', 'prefix': '351'},
    {'name': 'China', 'prefix': '86'},
    {'name': 'Japón', 'prefix': '81'},
    {'name': 'India', 'prefix': '91'},
    {'name': 'Australia', 'prefix': '61'},
  ];

  Future<void> validatePhone(String number) async {
    if (number.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _phoneData = null;
    });

    // Combinar prefijo con número
    final fullNumber = '$_selectedPrefix$number';

    final url = Uri.parse(
      'http://apilayer.net/api/validate?access_key=$_apiKey&number=$fullNumber'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['valid'] != null) {
          setState(() {
            _phoneData = {
              'valid': data['valid'] ?? false,
              'number': data['number'] ?? 'N/A',
              'local_format': data['local_format'] ?? 'N/A',
              'international_format': data['international_format'] ?? 'N/A',
              'country_prefix': data['country_prefix'] ?? 'N/A',
              'country_code': data['country_code'] ?? 'N/A',
              'country_name': data['country_name'] ?? 'N/A',
              'location': data['location'] ?? 'N/A',
              'carrier': data['carrier'] ?? 'N/A',
              'line_type': data['line_type'] ?? 'N/A',
            };
            _isLoading = false;
          });
        } else if (data['error'] != null) {
          setState(() {
            _error = data['error']['info'] ?? 'Error desconocido';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Error en la solicitud';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validar número telefónico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown para seleccionar país
            DropdownButtonFormField<String>(
              value: _selectedPrefix,
              decoration: InputDecoration(
                labelText: 'País',
                border: OutlineInputBorder(),
              ),
              items: _countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country['prefix'],
                  child: Text('${country['name']} (+${country['prefix']})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPrefix = value!;
                });
              },
            ),
            SizedBox(height: 12),
            // Campo de número y botón
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+$_selectedPrefix',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ingresa un número sin prefijo (ej: 987654321)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    onSubmitted: validatePhone,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => validatePhone(_controller.text),
                  child: Text('Validar'),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_phoneData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Icon(
                              _phoneData!['valid'] ? Icons.check_circle : Icons.cancel,
                              color: _phoneData!['valid'] ? Colors.green : Colors.red,
                              size: 60,
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              _phoneData!['valid'] ? 'VÁLIDO' : 'NO VÁLIDO',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _phoneData!['valid'] ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text('Número: ${_phoneData!['number']}'),
                          Text('Formato local: ${_phoneData!['local_format']}'),
                          Text('Formato internacional: ${_phoneData!['international_format']}'),
                          Text('Prefijo país: ${_phoneData!['country_prefix']}'),
                          Text('Código país: ${_phoneData!['country_code']}'),
                          Text('País: ${_phoneData!['country_name']}'),
                          Text('Operador: ${_phoneData!['carrier']}'),
                          Text('Tipo de línea: ${_phoneData!['line_type']}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}