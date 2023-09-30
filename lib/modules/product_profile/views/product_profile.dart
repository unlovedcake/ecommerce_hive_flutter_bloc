import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:hive/bloc/product_bloc/product_bloc.dart';
import 'package:hive/constants/sendbird_instance.dart';
import 'package:hive/models/product_model.dart';
import 'package:badges/badges.dart' as badges;

class ProductProfile extends StatefulWidget {
  const ProductProfile({super.key, this.product});

  final Product? product;

  @override
  State<ProductProfile> createState() => _ProductProfileState();
}

class _ProductProfileState extends State<ProductProfile> {
  final count = ValueNotifier<int>(0);
  final totalPrice = ValueNotifier<double>(0.0);

  double calculateTotalPrice(int quantity, double price) {
    return totalPrice.value = quantity * price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffBA68C8),
        title: const Text('Product Profile'),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        actions: [
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeAnimation: badges.BadgeAnimation.fade(
                    // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                    // curve: Curves.easeInCubic,
                    ),
                showBadge: count.value == 0 ? false : true,
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.red,
                ),
                badgeContent: Text(
                  count.value.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                    icon: Icon(Icons.shopping_cart), onPressed: () {}),
              );
            },
            valueListenable: count,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio: 6 / 5,
                child: Hero(
                  tag: widget.product!.id,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.product!.imageUrl,
                    placeholder: (
                      context,
                      url,
                    ) =>
                        Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            child: const CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              initialRating: 4,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product!.name,
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      textStyle: const TextStyle(
                        color: Color(0xffBA68C8),
                      )),
                ),
                Text(
                  ' \$ ${widget.product!.price}',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      textStyle: const TextStyle(
                        color: Colors.black,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Details',
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  textStyle: const TextStyle(
                    color: Colors.black,
                  )),
            ),
            Text(
              widget.product!.description,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  textStyle: const TextStyle(
                    color: Color(0xffBA68C8),
                  )),
            ),
            const SizedBox(
              height: 26,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(40, 50),
                      backgroundColor: const Color(0xffBA68C8),
                      shape: const StadiumBorder()),
                  onPressed: () {
                    if (count.value > 0) {
                      count.value--;

                      calculateTotalPrice(
                          count.value, double.parse(widget.product!.price));
                    }
                  },
                  child: const Icon(Icons.remove),
                ),
                ValueListenableBuilder(
                  builder: (BuildContext context, value, Widget? child) {
                    return TextButton(
                        onPressed: null,
                        child: Text(
                          count.value.toString(),
                          style: const TextStyle(fontSize: 24),
                        ));
                  },
                  valueListenable: count,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(40, 50),
                      backgroundColor: const Color(0xffBA68C8),
                      shape: const StadiumBorder()),
                  onPressed: () {
                    count.value++;

                    calculateTotalPrice(
                        count.value, double.parse(widget.product!.price));
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            ValueListenableBuilder(
              builder: (BuildContext context, value, Widget? child) {
                return Center(
                  child: Text(
                    totalPrice.value.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
              valueListenable: totalPrice,
            ),
            const SizedBox(
              height: 26,
            ),
            ValueListenableBuilder(
              builder: (BuildContext context, value, Widget? child) {
                return Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color(0xffBA68C8),
                          shape: const StadiumBorder()),
                      onPressed: count.value == 0
                          ? null
                          : () {
                              List<Map<String, dynamic>> itemCart = [];
                              Map<String, dynamic> productData = {
                                'id': widget.product!.id,
                                'name': widget.product!.name,
                                'imageUrl': widget.product!.imageUrl,
                                'quantity': count.value.toString(),
                                'description': widget.product!.description,
                                'price': widget.product!.price,
                                'totalPrice': totalPrice.value.toString()
                              };

                              // addToCart = Map.from(addToCart)
                              //   ..addAll(productData);

                              addToCartsListItem.add(productData);

                              itemCart.add(productData);

                              int totalQuantity = addToCartsListItem.fold(
                                0,
                                (int previousValue, product) =>
                                    previousValue +
                                    (int.parse(product['quantity'])),
                              );

                              BlocProvider.of<AddToCartBloc>(context).add(
                                CartQuantityItemEvent(totalQuantity),
                              );
                            },
                      child: const Text('Add To Cart')),
                );
              },
              valueListenable: totalPrice,
            ),
            TextButton(
                onPressed: () {
                  addToCartsListItem.clear();
                  print(addToCartsListItem.length);
                  print('addToCart');
                  print(addToCartsListItem);
                  double totalPriceSum = addToCartsListItem.fold(
                    0.0,
                    (double previousValue, product) =>
                        previousValue + (double.parse(product['totalPrice'])),
                  );

                  int totalQuantity = addToCartsListItem.fold(
                    0,
                    (int previousValue, product) =>
                        previousValue + (int.parse(product['quantity'])),
                  );

                  BlocProvider.of<AddToCartBloc>(context).add(
                    CartQuantityItemEvent(totalQuantity),
                  );

                  print(
                      'Total Price Sum: \$${totalPriceSum.toStringAsFixed(2)}');
                  print('Total Quantity: ${totalQuantity.toString()}');
                },
                child: Text('add')),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      // bottomSheet: Container(
      //     height: 400,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(40),
      //         topRight: Radius.circular(40),
      //       ),
      //       color: Colors.blue,
      //     )),
    );
  }
}
