import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  double dinero;
  String res = '';
  HomeScreen({Key? key, required this.dinero}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> currencies = [];
  List<dynamic> valores = [];
  List<MapEntry<String, dynamic>> ida = [];
  List<MapEntry<String, dynamic>> vuelta = [];
  final controllerText = TextEditingController();
  String arriba = 'USD';
  String abajo = 'BRL';

  @override
  void initState() {
    controllerText.text = '1';
    fetchCurrencies();
    super.initState();
  }

  Future<void> fetchCurrencies() async {
    final url = Uri.https(
      'api.frankfurter.app',
      'currencies',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<String> codigo = data.keys.toList();
      final List<dynamic> valor = data.values.toList();

      for (int i = 0; i < codigo.length; i++) {
        ida.add(MapEntry(codigo[i], valor[i]));
        vuelta.add(MapEntry(codigo[i], valor[i]));
      }
      setState(() {
        currencies = codigo;
        valores = valor;
      });
    } else {
      throw Exception('falla de conexion');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[100],
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DIVISAS'),
                SizedBox(height: 2),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.lock_clock),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: arriba,
                      onChanged: (String? newValue) {
                        setState(() {
                          arriba = newValue!;
                        });
                      },
                      items: ida.map<DropdownMenuItem<String>>((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text('${entry.value}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Conveertir a :'),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: abajo,
                      onChanged: (String? newValue) {
                        setState(() {
                          abajo = newValue!;
                        });
                      },
                      items: vuelta.map<DropdownMenuItem<String>>((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text('${entry.value}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: controllerText,
                      decoration: const InputDecoration(
                        labelText: 'Ingrese su texto',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(
                          () async {
                            if (arriba != abajo) {
                              if (controllerText.text != '0') {
                                final url = Uri.https(
                                  'api.frankfurter.app',
                                  'latest',
                                  {
                                    'amount': controllerText.text,
                                    'from': arriba,
                                    'to': abajo
                                  },
                                );

                                final response2 = await http.get(url);
                                if (response2.statusCode == 200) {
                                  final Map<String, dynamic> data1 =
                                      json.decode(response2.body);
                                  log('message--->${data1.values.last[abajo]}');
                                  String va = '';
                                  if (controllerText.text.isEmpty) {
                                    va = 'valor ingresado invalido';
                                  } else {
                                    va = data1.values.last[abajo].toString();
                                  }

                                  //log('url----$va[]');
                                  setState(() {
                                    widget.res = va;
                                  });
                                } else {
                                  throw Exception('falla de conexion');
                                }
                              } else {
                                String va = 'no se puedes convertir 0';
                                setState(() {
                                  widget.res = va;
                                });
                              }
                            } else {
                              String va = 'no se puede convertir';
                              setState(() {
                                widget.res = va;
                              });
                            }
                          },
                        );
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.money_outlined),
                          SizedBox(
                              height: 0), // Espacio entre el icono y el texto
                          Text(
                            'Calcular',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Resultado: ${widget.res}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(dinero: 0.0),
  ));
}
