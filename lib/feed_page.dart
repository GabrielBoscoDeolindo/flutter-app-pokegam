import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedBody extends StatelessWidget {
  const FeedBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("posts").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Erro"));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final data = snapshot.data!.docs;
        if (data.isEmpty) return const Center(child: Text("Feed vazio."));

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final doc = data[index];
            final post = doc.data() as Map<String, dynamic>;
            final String donoDoPost = post["usuario"] ?? "";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(donoDoPost)
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          String? fotoUsuario;
                          
                          if (userSnapshot.hasData && userSnapshot.data!.exists) {
                            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                            fotoUsuario = userData['foto_perfil'];
                          }

                          return Container(
                            width: 32, 
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey[800], 
                              shape: BoxShape.circle,
                              image: fotoUsuario != null 
                                  ? DecorationImage(
                                      image: NetworkImage(fotoUsuario),
                                      fit: BoxFit.cover
                                    )
                                  : null,
                            ),
                            child: fotoUsuario == null 
                                ? const Icon(Icons.person, size: 20, color: Colors.white) 
                                : null,
                          );
                        },
                      ),

                      const SizedBox(width: 10),
                      Text(
                        donoDoPost, 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                    ],
                  ),
                ),

                AspectRatio(
                  aspectRatio: 1.0, 
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[900], 
                    child: Image.network(
                      post["url_imagem"] ?? "",
                      fit: BoxFit.cover, 
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        children: const [
                          Icon(Icons.favorite_border, color: Colors.white, size: 26),
                          SizedBox(width: 16),
                          Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(text: "$donoDoPost ", style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: post["descricao"] ?? ""),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}