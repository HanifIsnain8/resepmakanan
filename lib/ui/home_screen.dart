import 'package:flutter/material.dart';
import 'package:resepmakanan/models/recipe_model.dart';
import 'package:resepmakanan/services/recipe_service.dart';
import 'package:resepmakanan/ui/detail_screen.dart';
import 'package:resepmakanan/ui/add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;

  int currentPage = 1;
  int itemsPerPage = 12;

  @override
  void initState() {
    super.initState();
    futureRecipes = _recipeService.getAllRecipe();
  }

  List<RecipeModel> _getPaginatedData(List<RecipeModel> recipes) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, recipes.length);
    return recipes.sublist(startIndex, endIndex);
  }

  void _nextPage(List<RecipeModel> recipes) {
    if ((currentPage * itemsPerPage) < recipes.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  void _refreshRecipes() {
    setState(() {
      currentPage = 1;
      futureRecipes = _recipeService.getAllRecipe();
    });
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
            return Center(child: Text("Gagal load data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada data"));
          } else {
            final paginatedData = _getPaginatedData(snapshot.data!);
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: paginatedData.length,
                    itemBuilder: (context, index) {
                      final recipe = paginatedData[index];
                      return CustomCard(
                        id: recipe.id,
                        img: recipe.photoUrl,
                        title: recipe.title,
                        likes_count: recipe.likesCount,
                        comments_count: recipe.commentsCount,
                        recipe: recipe,
                        onDelete: () async {
                          try {
                            await _recipeService.deleteRecipe(recipe.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Recipe deleted successfully")),
                            );
                            _refreshRecipes();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadRecipeScreen(
                                recipe: recipe,
                                onRecipeCreated: _refreshRecipes,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadRecipeScreen(
                            onRecipeCreated: _refreshRecipes,
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String img;
  final String title;
  final int likes_count;
  final int comments_count;
  final int id;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CustomCard(
      {required this.id,
      required this.img,
      required this.title,
      required this.likes_count,
      required this.comments_count,
      required this.onDelete,
      required this.onEdit,
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
              img,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              height: 50,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
