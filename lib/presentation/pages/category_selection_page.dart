// presentation/pages/category_selection_page.dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp1_quizz_app/presentation/pages/user_profile_page.dart';
import '../../business_logic/blocs/quizz_cubit.dart';
import 'quizz_page.dart';
import 'add_question_page.dart';

// --- (La classe CategoryStyle reste identique) ---
class CategoryStyle {
  final IconData icon;
  final Color color;
  CategoryStyle(this.icon, this.color);
  static CategoryStyle getStyle(String categoryName) {
    switch (categoryName) {
      case "Fitness": return CategoryStyle(Icons.fitness_center, Colors.orange);
      case "Nutrition": return CategoryStyle(Icons.restaurant, Colors.green);
      case "Anatomie": return CategoryStyle(Icons.accessibility_new, Colors.blue);
      case "Aléatoire": return CategoryStyle(Icons.shuffle, Colors.purple);
      default: return CategoryStyle(Icons.category, Colors.teal);
    }
  }
}

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  void _showQuantityDialog(BuildContext context, String categoryName) {
    final List<int> quantities = [5, 10, 15, 20, 25];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nombre de questions ($categoryName)"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: quantities.map((number) {
              return ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.purple),
                title: Text("$number questions"),
                onTap: () {
                  context.read<QuizCubit>().loadQuestions(category: categoryName, limit: number);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizzPage(title: "Quizz")));
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir un Quiz"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfilePage())
              ),
              // StreamBuilder pour écouter les changements de profil (photoURL)
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                builder: (context, snapshot) {
                  ImageProvider? bgImage;

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null && data['photoBase64'] != null) {
                      try {
                        bgImage = MemoryImage(base64Decode(data['photoBase64']));
                      } catch (_) {}
                    }
                  }

                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.purple.shade200,
                    backgroundImage: bgImage,
                    child: bgImage == null
                        ? const Icon(Icons.person, size: 20, color: Colors.white)
                        : null,
                  );
                },
              )
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('questions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          final categoryNames = docs.map((d) => d['category'] as String).toSet().toList();
          if (!categoryNames.contains("Aléatoire")) categoryNames.add("Aléatoire");

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: categoryNames.length,
              itemBuilder: (context, index) {
                final name = categoryNames[index];
                final style = CategoryStyle.getStyle(name);

                return InkWell(
                  onTap: () {
                    if (name == "Aléatoire") {
                      _showQuantityDialog(context, name);
                    } else {
                      context.read<QuizCubit>().loadQuestions(category: name);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuizzPage(title: name)));
                    }
                  },
                  child: Card(
                    color: style.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(style.icon, size: 50, color: Colors.white),
                        const SizedBox(height: 10),
                        Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddQuestionPage())),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}