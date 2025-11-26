import 'dart:math';
import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  final Function(String newImageUrl)? onImageChanged;
  final String? initialImage; 

  const ProfilePicture({
    super.key, 
    this.onImageChanged, 
    this.initialImage
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.initialImage;
  }

  @override
  void didUpdateWidget(ProfilePicture oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImage != oldWidget.initialImage) {
      setState(() {
        _currentImageUrl = widget.initialImage;
      });
    }
  }

  void _gerarPokemonAleatorio() {
    int randomId = Random().nextInt(1010) + 1;
    String newUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$randomId.png";

    setState(() {
      _currentImageUrl = newUrl;
    });

    if (widget.onImageChanged != null) {
      widget.onImageChanged!(newUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _gerarPokemonAleatorio,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey[900],
            backgroundImage: _currentImageUrl != null 
                ? NetworkImage(_currentImageUrl!) 
                : null,
            child: _currentImageUrl == null 
                ? const Icon(Icons.catching_pokemon, size: 40, color: Colors.white) 
                : null,
          ),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFB241FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.refresh, size: 16, color: Colors.white),
          )
        ],
      ),
    );
  }
}