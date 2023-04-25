import 'package:e_commerce1/const/routes.dart';
import 'package:e_commerce1/provider/app_provider.dart';
import 'package:e_commerce1/screens/category/category_screen.dart';
import 'package:e_commerce1/screens/product/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../firebase_helper/firebase_firestore_helper.dart';
import '../../models/category/category_model.dart';
import '../../models/product/product_model.dart';
import '../../widgets/top_titles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productModelList = [];

  bool isLoading = false;
  @override
  void initState() {
    getCategoryList();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });

    categoriesList = await FirebaseFirestoreHelper.instanse.getCategories();
    productModelList =
        await FirebaseFirestoreHelper.instanse.getBestCategories();
    FirebaseFirestoreHelper.instanse.updateTokenFromFirebase();

    productModelList.shuffle();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];
  void searchProducts(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && searchList.isNotEmpty) {
      return false;
    } else if (searchList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TopTitles(subtitle: "", title: "E Commerce"),
                        TextFormField(
                          controller: search,
                          onChanged: (String value) {
                            searchProducts(value);
                          },
                          decoration:
                              const InputDecoration(hintText: "Search...."),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  categoriesList.isEmpty
                      ? const Center(
                          child: Text("Categories is empty"),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoriesList
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Routes.instance.push(
                                            widget: CategoryScreen(
                                                categoryModel: e),
                                            context: context);
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(e.image),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  !isSearched()
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12.0, left: 12.0),
                          child: Text(
                            "Best Products",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SizedBox.fromSize(),
                  const SizedBox(
                    height: 12.0,
                  ),
                  search.text.isNotEmpty && searchList.isEmpty
                      ? const Center(
                          child: Text("No Product Found"),
                        )
                      : searchList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GridView.builder(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: searchList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 20,
                                          childAspectRatio: 0.7,
                                          crossAxisCount: 2),
                                  itemBuilder: (ctx, index) {
                                    ProductModel singleProduct =
                                        productModelList[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          Image.network(
                                            singleProduct.image,
                                            height: 100,
                                            width: 100,
                                          ),
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          Text(
                                            singleProduct.name,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "Price: \$${singleProduct.price}"),
                                          const SizedBox(
                                            height: 30.0,
                                          ),
                                          // SizedBox(
                                          //   height: 45,
                                          //   width: 140,
                                          //   child: OutlinedButton(
                                          //     onPressed: () {
                                          //       Routes.instance.push(
                                          //           widget: ProductDetailScreen(
                                          //               singleProduct:
                                          //                   singleProduct),
                                          //           context: context);
                                          //     },
                                          //     child: const Text(
                                          //       "Buy",
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : productModelList.isEmpty
                              ? const Center(
                                  child: Text("Best Product is empty"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GridView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: productModelList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 20,
                                              childAspectRatio: 0.7,
                                              crossAxisCount: 2),
                                      itemBuilder: (ctx, index) {
                                        ProductModel singleProduct =
                                            productModelList[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              Image.network(
                                                singleProduct.image,
                                                height: 100,
                                                width: 100,
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              Text(
                                                singleProduct.name,
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "Price: \$${singleProduct.price}"),
                                              const SizedBox(
                                                height: 30.0,
                                              ),
                                              SizedBox(
                                                height: 45,
                                                width: 140,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Routes.instance.push(
                                                        widget:
                                                            ProductDetailScreen(
                                                                singleProduct:
                                                                    singleProduct),
                                                        context: context);
                                                  },
                                                  child: const Text(
                                                    "Buy",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
    );
  }
}
