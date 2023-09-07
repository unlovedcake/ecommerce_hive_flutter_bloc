import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/models/product_model.dart';

class ProductProfile extends StatefulWidget {
  const ProductProfile({super.key, this.product});

  final Product? product;

  @override
  State<ProductProfile> createState() => _ProductProfileState();
}

class _ProductProfileState extends State<ProductProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffBA68C8),
        title: Text('Product Profile'),
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
            RatingBar.builder(
              initialRating: 4,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Description',
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  textStyle: TextStyle(
                    color: const Color(0xffBA68C8),
                  )),
            ),
            Text(
              widget.product!.description,
            ),
            SizedBox(
              height: 26,
            ),
            Text(
              'Price',
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  textStyle: TextStyle(
                    color: const Color(0xffBA68C8),
                  )),
            ),
            Text(
              widget.product!.price,
            ),
            Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xffBA68C8),
                    shape: const StadiumBorder()),
                onPressed: () {},
                child: Text('Add To Cart')),
            SizedBox(
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
