import 'package:cocktail_party/src/model/cocktail.dart';
import 'package:cocktail_party/src/model/ingredient_definition.dart';
import 'package:cocktail_party/style/colors.dart';
import 'package:flutter/material.dart';

class CocktailDetailPage extends StatelessWidget {
  final Cocktail _cocktail;

  CocktailDetailPage(Cocktail cocktail) : _cocktail = cocktail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 400.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(_cocktail.name),
                  background: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(_cocktail.drinkThumbUrl)),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.withOpacity(0.0),
                                Colors.grey.withOpacity(0.0),
                                Theme.of(context).backgroundColor,
                              ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 24.0,),
                  CategoryTile(
                      title: 'Категория коктейля',
                      value: _cocktail.category.value),
                  CategoryTile(
                      title: 'Тип коктейля', value: _cocktail.cocktailType.value),
                  CategoryTile(
                      title: 'Тип стекла', value: _cocktail.glassType.value),
                  Ingredients(_cocktail.ingredients),
                  Recept(_cocktail.instruction),
                  SizedBox(height: 400.0,),
                ],
              ))
            ],
          ),
        ),

    );
  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  final String value;

  const CategoryTile({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 14.0, color: Color(0xffEAEAEA)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48.0, top: 14.0, bottom: 24.0),
          child: Text(
            value,
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 15.0),
          ),
        ),
      ],
    );
  }
}

class Ingredients extends StatelessWidget {
  final Iterable<IngredientDefinition> ingredients;

  Ingredients(this.ingredients);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'Ингредиенты:',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 16.0, color: Color(0xffB1AFC6)),
          ),
        ),
      ]..addAll(ingredients.map((e) => ingredientRow(e))),
    );
  }

  Widget ingredientRow(IngredientDefinition ingredient) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(ingredient.ingredientName),
          Text(ingredient.measure),
        ],
      ),
    );
  }
}

class Recept extends StatelessWidget {
  final String instruction;

  Recept(this.instruction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text('Рецепт'),
          ),
          Text(instruction.trim()),
        ],
      ),
    );
  }
}
