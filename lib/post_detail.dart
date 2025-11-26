import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  const PostDetailPage({
    super.key,
    required this.postId,
    required this.postData,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late String _descricaoAtual;

  @override
  void initState() {
    super.initState();
    _descricaoAtual = widget.postData["descricao"] ?? "";
  }

  // DELETE 
  Future<void> deleteValue() async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postId)
        .delete();
    
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post deletado!")),
    );
  }

  // UPDATE
  Future<void> _updateValue(String novaDescricao) async {
    try {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.postId)
          .update({
        "descricao": novaDescricao,
      });

      setState(() {
        _descricaoAtual = novaDescricao;
      });

      if (!mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Descrição atualizada!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _showEditDialog() {
    final TextEditingController controller = TextEditingController(text: _descricaoAtual);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Editar Legenda", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Escreva a nova legenda...",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => _updateValue(controller.text),
              child: const Text("Salvar", style: TextStyle(color: Color(0xFFB241FF))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Publicação"),
        actions: [
          // botao de editar
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: _showEditDialog,
          ),
          // botao de deletarr
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: deleteValue,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 400,
              child: Image.network(
                widget.postData["url_imagem"] ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.error, color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 20, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.postData["usuario"] ?? "Anônimo",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _descricaoAtual,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}