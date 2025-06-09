//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double result = 0.0;
  bool isLoading = false;
  String selectedCurrency = 'USD';
  final TextEditingController textEditingController = TextEditingController();

  // Mock exchange rates (1 unit of currency = X INR)
  final Map<String, double> exchangeRates = {
    'USD': 83.50, // 1 USD = 83.50 INR
    'EUR': 90.75, // 1 EUR = 90.75 INR
    'GBP': 106.20, // 1 GBP = 106.20 INR
    'JPY': 0.55, // 1 JPY = 0.55 INR
  };

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void convertCurrency() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        try {
          final input = double.tryParse(textEditingController.text);
          if (input != null && exchangeRates.containsKey(selectedCurrency)) {
            result = input * exchangeRates[selectedCurrency]!;
          } else {
            result = 0.0;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a valid number')),
            );
          }
        } catch (e) {
          result = 0.0;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred during conversion'),
            ),
          );
        } finally {
          isLoading = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.tealAccent,
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(30),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reset',
            onPressed: () {
              setState(() {
                textEditingController.clear();
                result = 0.0;
                selectedCurrency = 'USD';
              });
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Color(0xFF00695C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    '₹ ${result.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Indian Rupees (INR)',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  DropdownButton<String>(
                    value: selectedCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCurrency = newValue!;
                        result = 0.0; // Reset result when currency changes
                      });
                    },
                    items:
                        exchangeRates.keys.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                    dropdownColor: Colors.teal,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    underline: Container(height: 2, color: Colors.tealAccent),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.tealAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textEditingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter amount in $selectedCurrency',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.tealAccent,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      focusedBorder: border,
                      enabledBorder: border,
                      errorBorder: border.copyWith(
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: border.copyWith(
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : convertCurrency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.teal,
                                ),
                              ),
                            )
                            : const Text(
                              'Convert to INR',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
