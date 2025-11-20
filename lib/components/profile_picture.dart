import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  final Function(XFile)? onImageChanged;

  const ProfilePicture({super.key, this.onImageChanged});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  XFile? _arquivoFoto;

  Future<void> _trocarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        _arquivoFoto = imagem;
      });
      
      if (widget.onImageChanged != null) {
        widget.onImageChanged!(imagem);
      }
    }
  }

  ImageProvider? _getImagemPerfil() {
    if (_arquivoFoto == null) return null;
    if (kIsWeb) return NetworkImage(_arquivoFoto!.path);
    return FileImage(File(_arquivoFoto!.path));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _trocarFoto,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey[800],
            backgroundImage: _getImagemPerfil(),
            child: _arquivoFoto == null 
                ? const Icon(Icons.person, size: 50, color: Colors.white) 
                : null,
          ),

          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.blue, 
              shape: BoxShape.circle
            ),
            child: const Icon(Icons.add, size: 15, color: Colors.white),
          )
        ],
      ),
    );
  }
}