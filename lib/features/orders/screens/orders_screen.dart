import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

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
    if (_searchText.isEmpty) return orders;
    final query = _searchText.toLowerCase();
    return orders.where((order) {
      // Search in date, total, payment, id
      if (order['date'].toString().toLowerCase().contains(query) ||
          order['total'].toString().toLowerCase().contains(query) ||
          order['payment'].toString().toLowerCase().contains(query) ||
          order['id'].toString().toLowerCase().contains(query)) {
        return true;
      }
      // Search in items
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
                    // TODO: Implement filter logic
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
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
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
                          ...List.generate(((order['items'] as List?)?.length ?? 0), (i) {
                            final item = (order['items'] as List?)?[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    item?['name'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Text(item?['weight'] ?? ''),
                                  const SizedBox(width: 12),
                                  Text(
                                    item?['price'] ?? '',
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