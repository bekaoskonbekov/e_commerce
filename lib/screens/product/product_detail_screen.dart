import 'package:e_commerce1/const/routes.dart';
import 'package:e_commerce1/const/utils.dart';
import 'package:e_commerce1/models/product/product_model.dart';
import 'package:e_commerce1/provider/app_provider.dart';
import 'package:e_commerce1/screens/by_product/checkout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetailScreen({Key? key, required this.singleProduct})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          CupertinoButton(
            onPressed: () {
              Routes.instance.push(widget: CartScreen(), context: context);
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                widget.singleProduct.image,
                height: 280,
                width: double.infinity,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.singleProduct.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.singleProduct.isFavourite =
                            !widget.singleProduct.isFavourite;
                      });
                      if (widget.singleProduct.isFavourite) {
                        appProvider.addFavoriteProduct(widget.singleProduct);
                      } else {
                        appProvider.removeFavoriteProduct(widget.singleProduct);
                      }
                    },
                    icon: Icon(
                      widget.singleProduct.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Text(widget.singleProduct.description),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        qty--;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: CircleAvatar(
                      child: Icon(Icons.remove),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    qty.toString(),
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        qty++;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: CircleAvatar(
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ProductModel productModel =
                          widget.singleProduct.copyWith(qty: qty);
                      appProvider.addCartProduct(productModel);
                      showMessage('Add to Cart');
                    },
                    child: Text('ADD TO CARD'),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  SizedBox(
                    height: 38,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        ProductModel productModel =
                            widget.singleProduct.copyWith(qty: qty);
                        Routes.instance.push(
                            widget: Checkout(
                              singleProduct: productModel,
                            ),
                            context: context);
                      },
                      child: Text('Buy'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
