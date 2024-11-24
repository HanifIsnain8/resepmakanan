import 'package:flutter/material.dart';
import 'package:resepmakanan/models/recipe_model.dart';

class DetailScreen extends StatelessWidget {
  final RecipeModel recipe;

  const DetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Resep
            Image.network(
              recipe.photoUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey,
                child: Center(child: Icon(Icons.image, size: 50)),
              ),
            ),
            SizedBox(height: 10),

            // Judul Resep
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),

            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text('${recipe.likesCount} likes')
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.comment),
                    Text('${recipe.commentsCount} comments')
                  ],
                ),
              ],
            ),

            // Deskripsi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),

            // Bahan (Ingredients)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Ingredients",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe.ingredients,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),

            // Metode Memasak (Cooking Method)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "step",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe.cookingMethod,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
