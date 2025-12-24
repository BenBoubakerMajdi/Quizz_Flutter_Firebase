import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/question.dart';
import '../../data/repositories/quizz_repository.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _newCategoryController = TextEditingController();

  String _selectedCategory = 'Fitness';
  bool _isCorrect = true;
  bool _isCreatingNew = false;

  File? _imageFile; // Stocke l'image choisie
  final ImagePicker _picker = ImagePicker();

  final List<String> _existingCategories = ['Fitness', 'Nutrition', 'Anatomie'];

  // Fonction pour sélectionner une image dans la galerie
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Compresse légèrement l'image
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      // Note : Dans un environnement de production, vous devriez uploader
      // le fichier _imageFile vers Firebase Storage ici.
      // Pour ce TP, nous enregistrons le chemin local ou une URL par défaut.

      String finalCategory = _isCreatingNew
          ? _newCategoryController.text.trim()
          : _selectedCategory;

      final newQuestion = Question(
        id: '',
        questionText: _textController.text.trim(),
        isCorrect: _isCorrect,
        // Si imageFile est nul, on met une image par défaut
        imageUrl: _imageFile?.path ?? "https://cdn.pixabay.com/photo/2017/02/02/15/28/images-2032980_1280.jpg",
        category: finalCategory,
      );

      try {
        await QuizRepository().addQuestion(newQuestion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Question ajoutée avec succès !')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouvelle Question")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION IMAGE ---
              const Text("Image de la question", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 50, color: Colors.purple),
                      SizedBox(height: 8),
                      Text("Sélectionner depuis la galerie"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- SECTION TEXTE ---
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'Ex: Le squat travaille les quadriceps ?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (v) => v!.isEmpty ? 'Veuillez saisir une question' : null,
              ),
              const SizedBox(height: 20),

              // --- SECTION CATÉGORIE ---
              const Text("Catégorie", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: _isCreatingNew
                        ? TextFormField(
                      controller: _newCategoryController,
                      decoration: const InputDecoration(hintText: "Nom de la nouvelle catégorie"),
                      validator: (v) => _isCreatingNew && v!.isEmpty ? 'Nom requis' : null,
                    )
                        : DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _existingCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isCreatingNew ? Icons.cancel : Icons.add_circle, color: Colors.purple),
                    onPressed: () => setState(() => _isCreatingNew = !_isCreatingNew),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- SECTION RÉPONSE ---
              SwitchListTile(
                title: const Text("La réponse correcte est VRAI"),
                value: _isCorrect,
                onChanged: (v) => setState(() => _isCorrect = v),
                activeColor: Colors.purple,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("ENREGISTRER LA QUESTION",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}