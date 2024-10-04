import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'levels_page.dart';

class CategoryPage extends StatelessWidget {
  final CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(title: const Text('Categories'),
        backgroundColor: Colors.lightGreen[50],
      ),

      body: StreamBuilder(
        stream: categories.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GridView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var category = snapshot.data!.docs[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LevelsPage(
                          categoryId: category.id,
                          categoryName: category['name'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(category['image']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        category['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            ),
          );
        },
      ),
    );
  }
}