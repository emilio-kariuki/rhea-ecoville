import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecoville/models/order_model.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/app_contants.dart';
import 'package:ecoville/utilities/extension.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<OrderModel> orders = [];
  List<OrderModel> filteredOrders = [];
  bool isShowSearch = false;
  String merchantId = '';
  String userId = '';
  int amount = 0;
  bool isPaying = false;
  bool isPaymentConfirming = false;
  bool isPaymentInitiated = false;

  @override
  void initState() {
    super.initState();
    _fetchAndSetOrders();
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndSetOrders() async {
    try {
      final response = await Dio().get('$API_URL/admin/orders');
      if (response.statusCode == 200) {
        final List<OrderModel> orderResponse =
            (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
        setState(() {
          orders = orderResponse;
          filteredOrders = orderResponse;
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> _initializePayment() async {
    if (isPaying) return;

    setState(() {
      isPaying = true;
    });

    try {
      final request = {
        'orderId': _orderIdController.text,
        'userId': userId,
        'amount': 1,
        'phone': _phoneController.text,
      };

      final response = await Dio().post(
        '$API_URL/mpesa/initiatestkpush',
        data: jsonEncode(request),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to initiate payment');
      }
      
    } catch (e) {
      print('Error initiating payment: $e');
    } finally {
      setState(() {
        isPaying = false;
      });
    }
  }

  void _searchOrders(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredOrders = orders;
        isShowSearch = false;
      });
      return;
    }

    final results = orders
        .where(
            (element) => element.id.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredOrders = results;
      isShowSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ecoville Admin'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InputField(
                controller: _orderIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter order ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  _searchOrders(value!);
                },
              ),
              const SizedBox(height: 8),
              if (isShowSearch)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _orderIdController.text = order.id;
                          userId = order.userId;
                          amount = order.totalPrice;
                          isShowSearch = false;
                        });
                      },
                      title: Text(
                        order.id,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        order.status,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 8),
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      controller: _phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CompleteButton(
                    height: 50,
                    width: 150,
                    text: Text(
                      isPaying ? 'Paying' : 'Pay',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    function: () => _initializePayment(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
