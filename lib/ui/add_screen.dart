import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resepmakanan/models/recipe_model.dart';
import 'package:resepmakanan/services/recipe_service.dart';

class UploadRecipeScreen extends StatefulWidget {
  final RecipeModel? recipe; 
  final Function()
      onRecipeCreated; 
  const UploadRecipeScreen({
    Key? key,
    this.recipe, 
    required this.onRecipeCreated,
  }) : super(key: key);

  @override
  _UploadRecipeScreenState createState() => _UploadRecipeScreenState();
}

class _UploadRecipeScreenState extends State<UploadRecipeScreen> {
  final RecipeService _recipeService = RecipeService();
  final _formKey = GlobalKey<FormState>();

  File? _image;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingMethodController = TextEditingController();
  final _ingredientsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _titleController.text = widget.recipe!.title;
      _descriptionController.text = widget.recipe!.description;
      _cookingMethodController.text = widget.recipe!.cookingMethod;
      _ingredientsController.text = widget.recipe!.ingredients;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> submitRecipe() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('pilih gambar terlebih dahulu')),
        );
        return;
      }

      try {
        if (widget.recipe != null) {
          await _recipeService.updateRecipe(
            id: widget.recipe!.id, 
            title: _titleController.text,
            description: _descriptionController.text,
            cookingMethod: _cookingMethodController.text,
            ingredients: _ingredientsController.text,
            photo: _image!,
          );
        } else {
          await _recipeService.createRecipe(
            title: _titleController.text,
            description: _descriptionController.text,
            cookingMethod: _cookingMethodController.text,
            ingredients: _ingredientsController.text,
            photo: _image!,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil')),
        );

        widget.onRecipeCreated(); 
        Navigator.pop(context); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe != null ? 'Edit Recipe' : 'Upload Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cookingMethodController,
                  decoration: InputDecoration(labelText: 'Cooking Method'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a cooking method';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: InputDecoration(labelText: 'Ingredients'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ingredients';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _image == null
                    ? Text('belum ada gambar yang di pilih')
                    : Image.file(_image!, height: 200, width: 200),
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('pilih gambar'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: submitRecipe,
                  child: Text(widget.recipe != null
                      ? 'Update Recipe'
                      : 'add Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
