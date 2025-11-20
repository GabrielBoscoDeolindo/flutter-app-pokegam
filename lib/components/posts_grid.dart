import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../post_detail.dart';

class Posts extends StatelessWidget {
  final String username;

  const Posts({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .where("usuario", isEqualTo: username)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Erro ao carregar"));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.docs;

        if (data.isEmpty) {
          return const Center(child: Text("Nenhuma publicação."));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final doc = data[index];
            final postMap = doc.data() as Map<String, dynamic>;
            final String postId = doc.id; // ID necessário para deletar

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(
                      postId: postId, 
                      postData: postMap
                    )
                  )
                );
              },
              child: Image.network(
                postMap["url_imagem"] ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }
}