import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum PhotoType { dog, landscapes }

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() =>
      _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  String? _imageUrl;
  bool _isLoading = false;
  String? _errorMessage;
  PhotoType _animalType = PhotoType.dog;

  Future<void> _fetchPhoto() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _imageUrl = null;
    });
    try {
      String url;
      http.Response response;

      if (_animalType == PhotoType.dog) {
        url = 'https://dog.ceo/api/breeds/image/random';
        response = await http.get(Uri.parse(url));
        Map<String, dynamic> data = jsonDecode(
          response.body,
        );
        _imageUrl = data['message'];
      } else {
        final random =
            DateTime.now().millisecondsSinceEpoch;
        _imageUrl =
            'https://picsum.photos/seed/$random/800/800';
      }
    } catch (e) {
      _errorMessage = 'не удалось загрузить фото. \nПроверьте подключения к интерену.';
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('фото дня'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildAnimalToggle(),
          const SizedBox(height: 20),
          _buildContent(),
          const SizedBox(height: 20),
          _buildButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAnimalToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('dog'),
          selected: _animalType == PhotoType.dog,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _animalType = PhotoType.dog;
                _imageUrl = null;
                _errorMessage = null;
              });
            }
          },
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text('пейзаж'),
          selected:
              _animalType == PhotoType.landscapes,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _animalType =
                    PhotoType.landscapes;
                _imageUrl = null;
                _errorMessage = null;
              });
            }
          },
        ),
      ],
    );
  }
}
