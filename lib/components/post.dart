import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  final String username;

  const PostPage({super.key, required this.username});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _idPokemonController = TextEditingController();

  String? _urlPreview;

  void _atualizarPreview(String valor) {
    if (valor.isEmpty) {
      setState(() => _urlPreview = null);
      return;
    }

    setState(() {
      _urlPreview =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$valor.png";
    });
  }

  Future<void> postValue() async {
    if (_idPokemonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite o número do Pokémon!")),
      );
      return;
    }

    String urlFinal =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${_idPokemonController.text}.png";

    await FirebaseFirestore.instance.collection("posts").add({
      "usuario": widget.username,
      "descricao": _descricaoController.text,
      "url_imagem": urlFinal,
      "likes": 0,
      "data": DateTime.now(),
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokegam"),
        actions: [
          TextButton(
            onPressed: postValue,
            child: const Text(
              "PUBLICAR",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho simples
            Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "@${widget.username}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // preview
            Center(
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: _urlPreview == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.catching_pokemon,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                        ],
                      )
                    : Image.network(
                        _urlPreview!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.error_outline,
                                size: 40,
                                color: Colors.red,
                              ),
                              Text(
                                "Pokémon não encontrado",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // poke
            TextField(
              controller: _idPokemonController,
              keyboardType: TextInputType.number,
              onChanged: _atualizarPreview,
              decoration: InputDecoration(
                labelText: "Número da Pokédex",
                hintText: "Ex: 25, 258, 131",
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[900],
              ),
            ),

            const SizedBox(height: 15),

            // legenda
            TextField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Legenda",
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
