import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'home_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _passwordController = TextEditingController();
  bool _isUpdating = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      imageQuality: 70,
    );
    if (pickedFile == null) return;

    setState(() => _isUpdating = true);
    try {
      final bytes = await pickedFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'photoBase64': base64Image,
        'email': user?.email,
      }, SetOptions(merge: true));

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Photo mise à jour !")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _changePassword() async {
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Min 6 caractères")));
      return;
    }
    setState(() => _isUpdating = true);
    try {
      await user?.updatePassword(_passwordController.text.trim());
      _passwordController.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mot de passe mis à jour !")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur : Reconnectez-vous pour cette action")));
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil"), backgroundColor: Colors.blueGrey),
      backgroundColor: Colors.blueGrey.shade900,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
              builder: (context, snapshot) {
                // 1. Initialisation par défaut (Icône)
                Widget profileWidget = const Icon(Icons.person, size: 80, color: Colors.white);
                ImageProvider? bgImage;

                // 2. Vérification de la donnée Firestore
                if (snapshot.hasData && snapshot.data!.exists) {
                  // Utilisation de .data() pour éviter les erreurs si le champ n'existe pas
                  final data = snapshot.data!.data() as Map<String, dynamic>?;

                  if (data != null && data.containsKey('photoBase64') && data['photoBase64'] != null) {
                    try {
                      bgImage = MemoryImage(base64Decode(data['photoBase64']));
                    } catch (e) {
                      debugPrint("Erreur décodage Base64: $e");
                    }
                  }
                }

                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blueGrey.shade700,
                      backgroundImage: bgImage,
                      child: bgImage == null ? profileWidget : null,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                        onPressed: _isUpdating ? null : _pickImage,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.white10,
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.orangeAccent),
                title: const Text("Email", style: TextStyle(color: Colors.white70)),
                subtitle: Text(user?.email ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(hintText: "Nouveau mot de passe", hintStyle: TextStyle(color: Colors.white30)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isUpdating ? null : _changePassword,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, minimumSize: const Size(double.infinity, 45)),
                    child: _isUpdating ? const CircularProgressIndicator() : const Text("CHANGER LE MOT DE PASSE", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ProfileHomePage()), (route) => false);
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text("SE DÉCONNECTER", style: TextStyle(color: Colors.redAccent)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent), minimumSize: const Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}