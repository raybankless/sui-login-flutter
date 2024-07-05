import 'package:flutter/material.dart';
import 'package:sui/sui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sui Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sui Login Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SuiAccount? _account;
  String _network = "devnet";
  late SuiClient _client;

  @override
  void initState() {
    super.initState();
    _client = SuiClient(SuiUrls.devnet);
  }

  void _connectToNetwork(String network) {
    setState(() {
      switch (network) {
        case 'devnet':
          _client = SuiClient(SuiUrls.devnet);
          _network = 'devnet';
          break;
        case 'testnet':
          _client = SuiClient(SuiUrls.testnet);
          _network = 'testnet';
          break;
        case 'mainnet':
          _client = SuiClient(SuiUrls.mainnet);
          _network = 'mainnet';
          break;
      }
    });
  }

  Future<void> _createAccount() async {
    final account = SuiAccount.ed25519Account();
    setState(() {
      _account = account;
    });
    // Optionally, save account details securely
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          DropdownButton<String>(
            value: _network,
            items: ['devnet', 'testnet', 'mainnet'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _connectToNetwork(newValue);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_account == null)
              ElevatedButton(
                onPressed: _createAccount,
                child: const Text('Create Account'),
              ),
            if (_account != null)
              Column(
                children: [
                  Text('Account Address: ${_account!.getAddress()}'),
                  ElevatedButton(
                    onPressed: () async {
                      final faucet = FaucetClient(SuiUrls.faucetDev);
                      final response = await faucet.requestSuiFromFaucetV0(_account!.getAddress());
                      print('Faucet response: $response');
                    },
                    child: const Text('Request SUI from Faucet'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
