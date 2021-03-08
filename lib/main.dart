import 'package:cocktail_party/cocktail_detail_page.dart';
import 'package:cocktail_party/models.dart';
import 'package:cocktail_party/src/model/cocktail.dart';
import 'package:cocktail_party/src/repository/sync_cocktail_repository.dart';
import 'package:cocktail_party/style/colors.dart';
import 'package:cocktail_party/style/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: mainThemeData,
      themeMode: ThemeMode.dark,
      home: CocktailList(),
    );
  }
}

class CocktailList extends StatefulWidget {
  @override
  _CocktailListState createState() => _CocktailListState();

  final repository = SyncCocktailRepository();
}

class _CocktailListState extends State<CocktailList> {
  @override
  Widget build(BuildContext context) {
    final _categoryNotifier =
        ValueNotifier<CocktailCategory>(CocktailCategory.values.first);

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _categoryNotifier,
          builder: (ctx, value, child){
            return  CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 21)),
                SliverPersistentHeader(
                  floating: true,
                  delegate: CategoryFilterBar(
                    CocktailCategory.values,
                    onCategorySelected: (category) {
                      _categoryNotifier.value = category;
                    },
                    selectedCategory:
                        _categoryNotifier.value,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: widget.repository
                      .fetchPopularCocktails()
                      .map((e) => CocktailGridItem(e))
                      .toList(),
                )
              ],
            );
          },),

      ),
    );
  }
}

class CocktailGridItem extends StatelessWidget {
  final Cocktail cocktail;

  CocktailGridItem(this.cocktail);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CocktailDetailPage(cocktail))),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          image: DecorationImage(
              fit: BoxFit.fill, image: NetworkImage(cocktail.drinkThumbUrl)),
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
                    Colors.black,
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Text(cocktail.name),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilterBar extends SliverPersistentHeaderDelegate {
  CategoryFilterBar(this.categories,
      {required this.onCategorySelected, required this.selectedCategory});

  final Iterable<CocktailCategory> categories;

  final ValueChanged<CocktailCategory> onCategorySelected;

  final CocktailCategory selectedCategory;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (ctx, index) => _categoryItemBuilder(
            context,
            categories.elementAt(index),
            categories.elementAt(index) == selectedCategory),
        separatorBuilder: _separatorBuilder,
        itemCount: categories.length);
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  Widget _categoryItemBuilder(
      BuildContext context, CocktailCategory category, bool isSelected) {
    return FilterChip(
      selected: isSelected,
      selectedColor: CustomColors.filter_item_selected_color,
      backgroundColor: CustomColors.filter_item_color,
      onSelected: (value) {
        if (value) {
          onCategorySelected.call(category);
        }
      },
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      showCheckmark: false,
      label: Text(
        category.value,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    return const SizedBox(width: 10);
  }
}
