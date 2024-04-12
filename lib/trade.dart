import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'balance_model.dart'; // Import your BalanceModel class

class TradeScreen extends StatefulWidget {
  final Map<String, dynamic> companyData;
  final double balance;
  final Function(double) updateBalance;

  TradeScreen({
    required this.companyData,
    required this.balance,
    required this.updateBalance,
  });

  @override
  _TradeScreenState createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  late double totalCost;
  late TextEditingController quantityController;
  bool isBuyingTransactionCompleted = false; // Add this line

  @override
  void initState() {
    super.initState();
    totalCost = 0;
    quantityController = TextEditingController();
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trades'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<BalanceModel>(
              builder: (context, balanceModel, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Company Symbol: ${widget.companyData['symbol']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Company Name: ${widget.companyData['name']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Latest Price: ${widget.companyData['price']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Date: ${widget.companyData['last_update_utc']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Balance: P${balanceModel.balance.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.pink[50],
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Buy ${widget.companyData['name']} Stocks',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Company Symbol: ${widget.companyData['symbol']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Company Name: ${widget.companyData['name']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Latest Price: ${widget.companyData['price']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        controller: quantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Quantity',
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            totalCost = (double.tryParse(value) ?? 0) * widget.companyData['price'];
                                          });
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Total Cost: ${totalCost.toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          double quantity = double.tryParse(quantityController.text) ?? 0;
                                          double totalCost = widget.companyData['price'] * quantity;
                                          if (totalCost <= balanceModel.balance) {
                                            double newBalance = balanceModel.balance - totalCost;
                                            // Call the updateBalance function to update the balance
                                            widget.updateBalance(newBalance); // <-- Update the balance
                                            setState(() {
                                              isBuyingTransactionCompleted = true; // Set the flag to true
                                            });
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Insufficient balance!'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text('Buy'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Buy'),
                        ),
                        ElevatedButton(
                          onPressed: isBuyingTransactionCompleted
                              ? () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.pink[50],
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Sell ${widget.companyData['name']} Stocks',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Company Symbol: ${widget.companyData['symbol']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Company Name: ${widget.companyData['name']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Latest Price: ${widget.companyData['price']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        controller: quantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Quantity',
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            totalCost = (double.tryParse(value) ?? 0) * widget.companyData['price'];
                                          });
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Total Value: ${totalCost.toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Get the quantity to sell
                                          double quantityToSell = double.tryParse(quantityController.text) ?? 0;

                                          // Calculate the total value of the stocks to sell
                                          double totalValueToSell = widget.companyData['price'] * quantityToSell;

                                          // Add the total value of sold stocks to the balance
                                          double newBalance = balanceModel.balance + totalValueToSell;

                                          // Call the updateBalance function to update the balance
                                          widget.updateBalance(newBalance);

                                          // Close the modal bottom sheet
                                          Navigator.pop(context);
                                        },
                                        child: Text('Sell'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                              : null,
                          child: Text('Sell'),
                        ),
                      ],
                    ),
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
