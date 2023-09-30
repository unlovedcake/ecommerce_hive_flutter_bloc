import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:hive/constants/sendbird_instance.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Item'),
      ),
      body: Column(
        children: [
          Text('Cart Item'),

          // BlocConsumer<AddToCartBloc, AddToCartState>(
          //   listenWhen: (context, state) {
          //     return state.status == AddToCartStatus.COMPLETED;
          //   },
          //   listener: (context, state) {
          //     if (state.status == AddToCartStatus.COMPLETED) {
          //     } else if (state.status == AddToCartStatus.ERROR) {}
          //   },
          //   buildWhen: (context, state) {
          //     return state.status == AddToCartStatus.COMPLETED;
          //   },
          //   builder: (context, state) {
          //     if (state.status == AddToCartStatus.COMPLETED) {
          //       return Expanded(
          //         child: ListView.builder(
          //           itemCount: state.addToCartsListItem!.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               leading: Image.network(
          //                   state.addToCartsListItem![index]['imageUrl']),
          //               title: Text(
          //                 state.addToCartsListItem![index]['name'],
          //               ),
          //               subtitle: Text(
          //                 state.addToCartsListItem![index]['price'],
          //               ),
          //               trailing: IconButton(
          //                   onPressed: () {
          //                     state.addToCartsListItem!.removeWhere((item) =>
          //                         item["id"] ==
          //                         state.addToCartsListItem![index]['id']);

          //                     int totalQuantity =
          //                         state.addToCartsListItem!.fold(
          //                       0,
          //                       (int previousValue, product) =>
          //                           previousValue +
          //                           (int.parse(product['quantity'])),
          //                     );

          //                     BlocProvider.of<AddToCartBloc>(context).add(
          //                       CancelledCartQuantityItemEvent(
          //                           state.addToCartsListItem, index),
          //                     );

          //                     BlocProvider.of<AddToCartBloc>(context).add(
          //                       CartQuantityItemEvent(totalQuantity),
          //                     );
          //                   },
          //                   icon: Icon(Icons.delete)),
          //             );
          //           },
          //         ),
          //       );
          //     } else {
          //       return const Text('No Item');
          //     }
          //   },
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: addToCartsListItem.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(addToCartsListItem[index]['imageUrl']),
                  title: Text(
                    addToCartsListItem[index]['name'],
                  ),
                  subtitle: Text(
                    addToCartsListItem[index]['price'],
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        addToCartsListItem.removeWhere((item) =>
                            item["id"] == addToCartsListItem[index]['id']);

                        int totalQuantity = addToCartsListItem.fold(
                          0,
                          (int previousValue, product) =>
                              previousValue + (int.parse(product['quantity'])),
                        );

                        BlocProvider.of<AddToCartBloc>(context).add(
                          CartQuantityItemEvent(totalQuantity),
                        );

                        setState(() {});
                      },
                      icon: Icon(Icons.delete)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
