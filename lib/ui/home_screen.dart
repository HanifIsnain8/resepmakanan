import 'package:flutter/material.dart';
import 'package:resepmakanan/models/recipe_model.dart';
import 'package:resepmakanan/services/recipe_service.dart';
import 'package:resepmakanan/ui/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _recipeService.getAllRecipe();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: FutureBuilder<List<RecipeModel>>(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Gagal Load Data : $snapshot.error");
            } else if (!snapshot.hasData) {
              return Text("Data Tidak Ditemukan");
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final recipe = snapshot.data![index];
                  return CustomCard(
                      id: recipe.id,
                      img: recipe.photoUrl,
                      title: recipe.title,
                      likes_count: recipe.likesCount,
                      comments_count: recipe.commentsCount,
                      recipe: recipe);
                },
              );
            }
          }),
    );
  }
}

class CustomCard extends StatelessWidget {
  final int id;
  final String img;
  final String title;
  final int likes_count;
  final int comments_count;

  const CustomCard(
      {required this.id,
      required this.img,
      required this.title,
      required this.likes_count,
      required this.comments_count,
      required this.recipe});
  final RecipeModel recipe;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(recipe: recipe),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Image.network(
              '$img',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100,
            ),
            Text(
              "$title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [Icon(Icons.star), Text('$likes_count')],
                ),
                Row(
                  children: [Icon(Icons.comment), Text('$comments_count')],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
