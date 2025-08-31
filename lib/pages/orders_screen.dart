import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

enum OrderFilterType { none, date, amount, item, price }

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  OrderFilterType _filterType = OrderFilterType.none;

  final List<Map<String, dynamic>> orders = [
    {
      'date': 'Aug 28, 2025',
      'items': [
        {'name': 'Copper', 'weight': '5kg', 'price': '₹1200'},
        {'name': 'Plastic', 'weight': '3kg', 'price': '₹180'},
      ],
      'total': '₹1380',
      'payment': 'UPI',
      'id': 'ORD12345',
    },
    {
      'date': 'Aug 15, 2025',
      'items': [
        {'name': 'Aluminium', 'weight': '2kg', 'price': '₹400'},
        {'name': 'Iron', 'weight': '10kg', 'price': '₹700'},
      ],
      'total': '₹1100',
      'payment': 'Cash',
      'id': 'ORD12344',
    },
    {
      'date': 'Aug 2, 2025',
      'items': [
        {'name': 'Paper', 'weight': '8kg', 'price': '₹320'},
        {'name': 'Plastic', 'weight': '5kg', 'price': '₹300'},
        {'name': 'Copper', 'weight': '1kg', 'price': '₹240'},
      ],
      'total': '₹860',
      'payment': 'Card',
      'id': 'ORD12343',
    },
    {
      'date': 'Jul 25, 2025',
      'items': [
        {'name': 'E-waste', 'weight': '3kg', 'price': '₹900'},
      ],
      'total': '₹900',
      'payment': 'UPI',
      'id': 'ORD12342',
    },
    {
      'date': 'Jul 10, 2025',
      'items': [
        {'name': 'Plastic', 'weight': '2kg', 'price': '₹120'},
        {'name': 'Aluminium', 'weight': '1kg', 'price': '₹200'},
      ],
      'total': '₹320',
      'payment': 'Cash',
      'id': 'ORD12341',
    },
  ];

  List<Map<String, dynamic>> get filteredOrders {
    List<Map<String, dynamic>> filtered = orders;
    final query = _searchText.toLowerCase();

    // Search logic
    if (_searchText.isNotEmpty) {
      filtered = filtered.where((order) {
        if (order['date'].toString().toLowerCase().contains(query) ||
            order['total'].toString().toLowerCase().contains(query) ||
            order['payment'].toString().toLowerCase().contains(query) ||
            order['id'].toString().toLowerCase().contains(query)) {
          return true;
        }
        for (final item in order['items'] as List) {
          if (item['name'].toString().toLowerCase().contains(query) ||
              item['weight'].toString().toLowerCase().contains(query) ||
              item['price'].toString().toLowerCase().contains(query)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    // Filter logic
    switch (_filterType) {
      case OrderFilterType.date:
        filtered.sort((a, b) => b['date'].compareTo(a['date']));
        break;
      case OrderFilterType.amount:
        filtered.sort((a, b) {
          int totalA = int.tryParse(a['total'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          int totalB = int.tryParse(b['total'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          return totalB.compareTo(totalA);
        });
        break;
      case OrderFilterType.item:
        filtered.sort((a, b) => (b['items'] as List).length.compareTo((a['items'] as List).length));
        break;
      case OrderFilterType.price:
        filtered.sort((a, b) {
          int maxA = (a['items'] as List)
              .map((item) => int.tryParse(item['price'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0)
              .fold(0, (prev, curr) => curr > prev ? curr : prev);
          int maxB = (b['items'] as List)
              .map((item) => int.tryParse(item['price'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0)
              .fold(0, (prev, curr) => curr > prev ? curr : prev);
          return maxB.compareTo(maxA);
        });
        break;
      case OrderFilterType.none:
        break;
    }
    return filtered;
  }

  void _showFilterDialog() async {
    final selected = await showDialog<OrderFilterType>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Filter Orders'),
          children: [
            SimpleDialogOption(
              child: const Text('None'),
              onPressed: () => Navigator.pop(context, OrderFilterType.none),
            ),
            SimpleDialogOption(
              child: const Text('By Date (Newest First)'),
              onPressed: () => Navigator.pop(context, OrderFilterType.date),
            ),
            SimpleDialogOption(
              child: const Text('By Amount (Highest First)'),
              onPressed: () => Navigator.pop(context, OrderFilterType.amount),
            ),
            SimpleDialogOption(
              child: const Text('By Item Count (Most First)'),
              onPressed: () => Navigator.pop(context, OrderFilterType.item),
            ),
            SimpleDialogOption(
              child: const Text('By Max Price Item (Highest First)'),
              onPressed: () => Navigator.pop(context, OrderFilterType.price),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() {
        _filterType = selected;
      });
    }
  }

  Color _getItemColor(String item) {
    switch (item.toLowerCase()) {
      case 'copper':
        return const Color(0xFFFBE9E7); // very light copper
      case 'plastic':
        return const Color(0xFFE3F2FD); // very light blue
      case 'aluminium':
        return const Color(0xFFF1F8E9); // very light green
      case 'iron':
        return const Color(0xFFF5F5F5); // very light grey
      case 'paper':
        return const Color(0xFFFFFDE7); // very light yellow
      case 'e-waste':
        return const Color(0xFFF3E5F5); // very light purple
      case 'glass':
        return const Color(0xFFE1F5FE); // very light blue
      case 'steel':
        return const Color(0xFFECEFF1); // very light steel
      case 'cardboard':
        return const Color(0xFFFFF8E1); // very light brown
      default:
        return Colors.white;
    }
  }

  Color _getDominantItemColor(List items) {
    if (items.isEmpty) return Colors.white;
    // Find item with max price (remove ₹ and parse as int)
    items.sort((a, b) {
      int priceA = int.tryParse(a['price'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      int priceB = int.tryParse(b['price'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      return priceB.compareTo(priceA);
    });
    return _getItemColor(items.first['name']);
  }

  Widget _buildOrderBackground(List items, Widget child) {
    final color = _getDominantItemColor(items);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by item, weight, price, or date',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: () {
                    _showFilterDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  final items = order['items'] as List;
                  return _buildOrderBackground(
                    items,
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      color: Colors.transparent,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  order['date'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  order['id'].toString(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...List.generate(items.length, (i) {
                              final item = items[i];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Text(
                                      item['name'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    Text(item['weight'] ?? ''),
                                    const SizedBox(width: 12),
                                    Text(
                                      item['price'] ?? '',
                                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  order['total'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.receipt_long_rounded, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  'Payment: ${order['payment']}',
                                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}