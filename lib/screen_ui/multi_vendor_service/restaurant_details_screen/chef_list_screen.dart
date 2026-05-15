import 'package:flutter/material.dart';
import 'hire_chef_form.dart';

class ChefListScreen extends StatelessWidget {
  const ChefListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chefs = [
      {
        "name": "Chef John",
        "specialty": "Continental",
        "price": 15000,
        "image": "https://via.placeholder.com/150",
      },
      {
        "name": "Chef Maria",
        "specialty": "Italian",
        "price": 12000,
        "image": "https://via.placeholder.com/150",
      },
      {
        "name": "Chef Ahmed",
        "specialty": "Middle Eastern",
        "price": 18000,
        "image": "https://via.placeholder.com/150",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hire a Chef"),
        backgroundColor: const Color(0xFF30588C),
      ),
      body: ListView.builder(
        itemCount: chefs.length,
        itemBuilder: (context, index) {
          final chef = chefs[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chef["image"] as String),
            ),
            title: Text(chef["name"] as String),
            subtitle: Text("Specialty: ${chef["specialty"]}"),
            trailing: Text("₦${chef["price"]}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HireChefForm(chef: chef)),
              );
            },
          );
        },
      ),
    );
  }
}
