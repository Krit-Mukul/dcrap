import 'package:flutter/material.dart';
import 'package:dcrap/core/services/api_service.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ordersData = await ApiService.getOrders();
      setState(() {
        _orders = ordersData.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
      print('❌ Failed to load orders: $e');
    }
  }

  String _formatDate(dynamic timestamp) {
    try {
      if (timestamp == null) return 'Unknown';
      DateTime date;
      if (timestamp is String) {
        date = DateTime.parse(timestamp);
      } else if (timestamp is int) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        return 'Unknown';
      }
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Unknown';
    }
  }

  List<Map<String, dynamic>> get filteredOrders {
    if (_searchText.isEmpty) return _orders;
    final query = _searchText.toLowerCase();
    return _orders.where((order) {
      // Search in date, orderId, scrapType, status
      final orderId = order['orderId']?.toString().toLowerCase() ?? '';
      final scrapType = order['scrapType']?.toString().toLowerCase() ?? '';
      final status = order['status']?.toString().toLowerCase() ?? '';
      final address = order['pickupAddress']?.toString().toLowerCase() ?? '';

      return orderId.contains(query) ||
          scrapType.contains(query) ||
          status.contains(query) ||
          address.contains(query);
    }).toList();
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'in transit':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
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
                      hintText: 'Search by order ID, type, or status',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
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
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _loadOrders,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load orders',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadOrders,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchText.isEmpty
                                ? 'No orders yet'
                                : 'No matching orders',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          if (_searchText.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Start selling scrap to see your orders here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.separated(
                        itemCount: filteredOrders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _formatDate(
                                          order['orderedAt'] ??
                                              order['createdAt'],
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            order['status'],
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          order['status'] ?? 'Unknown',
                                          style: TextStyle(
                                            color: _getStatusColor(
                                              order['status'],
                                            ),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order['orderId'] ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.recycling,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        order['scrapType'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text('${order['weight'] ?? 0}kg'),
                                      const SizedBox(width: 12),
                                      Text(
                                        '₹${order['estimatedPrice'] ?? order['finalPrice'] ?? 0}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (order['pickupAddress'] != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            order['pickupAddress'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (order['customerName'] != null ||
                                      order['customerPhone'] != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${order['customerName'] ?? 'Customer'} • ${order['customerPhone'] ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if ((order['imageUrls'] as List?)
                                          ?.isNotEmpty ==
                                      true) ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${(order['imageUrls'] as List).length} image(s)',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (order['paymentMethod'] != null) ...[
                                    const Divider(height: 20),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.receipt_long_rounded,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Payment: ${order['paymentMethod']}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (order['paymentStatus'] != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  order['paymentStatus'] ==
                                                      'Paid'
                                                  ? Colors.green.withOpacity(
                                                      0.1,
                                                    )
                                                  : Colors.orange.withOpacity(
                                                      0.1,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              order['paymentStatus'],
                                              style: TextStyle(
                                                color:
                                                    order['paymentStatus'] ==
                                                        'Paid'
                                                    ? Colors.green
                                                    : Colors.orange,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
