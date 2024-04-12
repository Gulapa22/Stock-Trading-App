import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart'; // Import your HomeScreen widget
import 'transaction.dart'; // Import your Transaction widget
import 'trade.dart'; // Import your TradeScreen widget
import 'balance_model.dart'; // Import your BalanceModel class
import 'package:provider/provider.dart'; // Import provider package

class Quotes extends StatefulWidget {
  @override
  _QuotesState createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  int _selectedIndex = 1;
  List<dynamic>? _quoteDataList; // Variable to store fetched data

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
  }

  // Function to fetch data from the API for multiple companies
  Future<void> fetchData() async {
    try {
      List<String> symbols = ['AAPL', 'MBT', 'AXP', 'HMC', 'SNE', 'AMZN'];
      List<dynamic> combinedData = [];

      for (String symbol in symbols) {
        final response = await http.get(
          Uri.parse(
              'https://real-time-finance-data.p.rapidapi.com/search?query=$symbol&language=en'),
          headers: {
            'X-RapidAPI-Key': '5a88e3094amsh03f63afb212ddbap10e3c3jsn79cff40b8609',
            'X-RapidAPI-Host': 'real-time-finance-data.p.rapidapi.com',
          },
        );

        if (response.statusCode == 200) {
          var responseData = json.decode(response.body)['data']['stock'];
          combinedData.addAll(responseData);
        } else {
          throw Exception(
              'Failed to load data for $symbol: ${response.statusCode}');
        }
      }

      setState(() {
        _quoteDataList = combinedData;
        print('Quote Data List: $_quoteDataList'); // Debug print
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
      // Do nothing, already on the Quotes screen
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Transaction()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Stock Trading App'),
      ),
      body: Center(
        child: _quoteDataList == null
            ? CircularProgressIndicator() // Show loading indicator while fetching data
            : Consumer<BalanceModel>(
          builder: (context, balanceModel, _) => ListView.builder(
            itemCount: _quoteDataList!.length,
            itemBuilder: (context, index) {
              var quoteData = _quoteDataList![index];
              return ListTile(
                title: Text('Company Symbol: ${quoteData['symbol']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company Name: ${quoteData['name']}'),
                    Text('Latest Price: ${quoteData['price']}'),
                    Text('Date: ${quoteData['last_update_utc']}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TradeScreen(
                          companyData: quoteData,
                          balance: balanceModel.balance, // Pass the actual balance from the BalanceModel
                          updateBalance: (double newBalance) {
                            // Update the balance here in the parent widget
                            balanceModel.updateBalance(newBalance);
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('More'),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink[100],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transaction',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
