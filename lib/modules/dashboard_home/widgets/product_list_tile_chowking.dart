part of '../views/home.dart';

class _Product_List_Tile_Chowking extends StatefulWidget {
  _Product_List_Tile_Chowking({
    super.key,
  });

  @override
  State<_Product_List_Tile_Chowking> createState() =>
      _Product_List_Tile_ChowkingState();
}

class _Product_List_Tile_ChowkingState
    extends State<_Product_List_Tile_Chowking> {
  ValueNotifier<List<Product>> productChowking =
      ValueNotifier<List<Product>>([]);
  final ValueNotifier<List<String>> favoriteDocumentIds =
      ValueNotifier<List<String>>([]);
  final scrollController = ScrollController();

  final isMoreData = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    // favoritesDocumentId();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   BlocProvider.of<ProductBloc>(context).add(
    //     GetProductsChowkingEvent('Chowking'),
    //   );
    //   BlocProvider.of<FavoritesBloc>(context).add(
    //     GetProductsFavoritesEvent(),
    //   );
    // });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isMoreData.value) {
        BlocProvider.of<ProductBloc>(context).add(
          GetProductsChowkingEvent('Chowking'),
        );
        BlocProvider.of<FavoritesBloc>(context).add(
          GetProductsFavoritesEvent(),
        );
      }
    });

    MyLogger.printInfo('_Product_List_Tile_ChowkingState');
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_Product_List_Tile_Chowking');

    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (context, state) {
        return state.status == Status.CHOWKINGCOMPLETED;
      },
      listener: (context, state) {
        if (state.status == Status.CHOWKINGCOMPLETED) {
          productChowking.value.addAll(state.products!);
        } else if (state.status == Status.ERROR) {
          //ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error.toString()),
            duration: const Duration(seconds: 3),
          ));
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (context, state) {
          return state.status == Status.CHOWKINGCOMPLETED;
        },
        builder: (context, state) {
          if (state.status == Status.CHOWKINGCOMPLETED) {
            if (state.products!.length < 6) {
              isMoreData.value = false;
              MyLogger.printInfo('No More Data');
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                controller: scrollController,
                //physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: productChowking.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = productChowking.value[index];
                  return Card(
                    elevation: 4.0,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Material(
                                  // child: CachedNetworkImage(
                                  //   imageUrl: product.imageUrl,
                                  //   placeholder: (
                                  //     context,
                                  //     url,
                                  //   ) =>
                                  //       Container(
                                  //           alignment: Alignment.center,
                                  //           width: 20,
                                  //           height: 20,
                                  //           child:
                                  //               const CircularProgressIndicator()),
                                  //   errorWidget: (context, url, error) =>
                                  //       const Icon(Icons.error),
                                  // ),
                                  child: Ink.image(
                                    image: NetworkImage(
                                      product.imageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                    child: InkWell(
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(product.name),
                            Text(product.price),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        Positioned(
                            top: 8.0,
                            left: 2.0,
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Discount '),
                                  TextSpan(
                                    text: '10% ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            )),

                        Positioned(
                          top: 4.0,
                          right: 0.0,
                          child: ButtonHeartChowking(id: product.id),
                        )
                        // Positioned(
                        //     top: 4.0,
                        //     right: 0.0,
                        //     child: BlocListener<FavoritesBloc, FavoritesState>(
                        //       // listenWhen: (context, state) {
                        //       //   return state.status == FavoriteStatus.COMPLETED;
                        //       // },
                        //       listener: (context, state) {
                        //         if (state.status == FavoriteStatus.COMPLETED) {
                        //           if (state.documentFavoriteId == null) {
                        //             return;
                        //           }
                        //           favoriteDocumentIds.value =
                        //               state.documentFavoriteId!;
                        //         } else if (state.status ==
                        //             FavoriteStatus.ERROR) {
                        //           // ScaffoldMessenger.of(context)
                        //           //     .hideCurrentSnackBar();
                        //           ScaffoldMessenger.of(context)
                        //               .showSnackBar(SnackBar(
                        //             content: Text(state.error.toString()),
                        //             duration: const Duration(seconds: 3),
                        //           ));
                        //         }
                        //       },
                        //       child: ValueListenableBuilder<List<String>>(
                        //         builder: (BuildContext context,
                        //             List<String> val, Widget? child) {
                        //           return IconButton(
                        //             icon: val.contains(product.id)
                        //                 ? const Icon(
                        //                     Icons.favorite_border,
                        //                     color: Colors.red,
                        //                   )
                        //                 : const Icon(Icons.favorite_border),
                        //             onPressed: () async {
                        //               if (val.contains(product.id)) {
                        //                 BlocProvider.of<FavoritesBloc>(context)
                        //                     .add(
                        //                   UpdateFavoritesProductEvent(
                        //                       product.id),
                        //                 );

                        //                 BlocProvider.of<FavoritesBloc>(context)
                        //                     .add(
                        //                   GetProductsFavoritesEvent(),
                        //                 );
                        //               } else {
                        //                 BlocProvider.of<FavoritesBloc>(context)
                        //                     .add(
                        //                   AddFavoritesProductEvent(product.id),
                        //                 );

                        //                 BlocProvider.of<FavoritesBloc>(context)
                        //                     .add(
                        //                   GetProductsFavoritesEvent(),
                        //                 );
                        //               }
                        //             },
                        //           );
                        //         },
                        //         valueListenable: favoriteDocumentIds,
                        //       ),
                        //     ))
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );

    // BlocListener<ProductBloc, ProductState>(listener: (context, state) {
    //   if (state is ProductsErrorState) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(state.error)));
    //   }
    // }, child:
    //     BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
    //   if (state is ProductsLoadedState) {
    //     final products = state.products;

    //     int numberOfRows = (products!.length / 2).ceil();

    //     double totalGridViewHeight = 187 * numberOfRows.toDouble();
    //     return Container(
    //       height: totalGridViewHeight,
    //       color: Colors.grey.shade100,
    //       child: GridView.builder(
    //         physics: const NeverScrollableScrollPhysics(),
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //         ),
    //         itemCount: products.length,
    //         itemBuilder: (BuildContext context, int index) {
    //           final product = products[index];
    //           return Card(
    //             elevation: 4.0,
    //             child: Stack(
    //               children: [
    //                 Column(
    //                   children: [
    //                     Image.network(
    //                       product.imageUrl,
    //                       fit: BoxFit.cover,
    //                       width: double.infinity,
    //                       height: 140,
    //                     ),
    //                     Text(product.name),
    //                     Text(product.price)
    //                   ],
    //                 ),
    //                 const Positioned(
    //                     top: 8.0, left: 2.0, child: Text('Discount 10%')),
    //                 Positioned(
    //                     top: 4.0,
    //                     right: 0.0,
    //                     child: BlocListener<FavoritesBloc, FavoritesState>(
    //                       // listenWhen: (context, state) {
    //                       //   return state is ProductsFavoriteLoadedState;
    //                       // },
    //                       listener: (context, state) {
    //                         if (state is ProductsFavoriteLoadedState) {
    //                           favoriteDocumentIds.value =
    //                               state.documentIdFavorites!;
    //                         } else if (state
    //                             is ProductsFavoriteErrorState) {
    //                           ScaffoldMessenger.of(context)
    //                               .hideCurrentSnackBar();
    //                           ScaffoldMessenger.of(context)
    //                               .showSnackBar(SnackBar(
    //                             content: Text(state.error),
    //                             duration: Duration(seconds: 3),
    //                           ));
    //                         }
    //                       },
    //                       child: ValueListenableBuilder<List<String>>(
    //                         builder: (BuildContext context,
    //                             List<String> val, Widget? child) {
    //                           return IconButton(
    //                             icon: val.contains(product.id)
    //                                 ? const Icon(
    //                                     Icons.favorite_border,
    //                                     color: Colors.red,
    //                                   )
    //                                 : const Icon(Icons.favorite_border),
    //                             onPressed: () async {
    //                               if (val.contains(product.id)) {
    //                                 print(product.id);
    //                                 BlocProvider.of<FavoritesBloc>(context)
    //                                     .add(
    //                                   UpdateFavoritesProductEvent(
    //                                       product.id),
    //                                 );
    //                                 //favoritesDocumentId();
    //                                 BlocProvider.of<FavoritesBloc>(context)
    //                                     .add(
    //                                   GetProductsFavoritesEvent(),
    //                                 );
    //                               } else {
    //                                 BlocProvider.of<FavoritesBloc>(context)
    //                                     .add(
    //                                   AddFavoritesProductEvent(product.id),
    //                                 );
    //                                 //favoritesDocumentId();
    //                                 BlocProvider.of<FavoritesBloc>(context)
    //                                     .add(
    //                                   GetProductsFavoritesEvent(),
    //                                 );
    //                               }
    //                             },
    //                           );
    //                         },
    //                         valueListenable: favoriteDocumentIds,
    //                       ),
    //                     )
    //                     // child: BlocBuilder<FavoritesBloc, FavoritesState>(
    //                     //   buildWhen: (context, state) {
    //                     //     return state is ProductsFavoriteLoadedState;
    //                     //   },

    //                     //   builder: (context, state) {
    //                     //     if (state is ProductsFavoriteLoadedState) {
    //                     //       return IconButton(
    //                     //         icon: state.documentIdFavorites!
    //                     //                 .contains(product.id)
    //                     //             ? const Icon(
    //                     //                 Icons.favorite_border,
    //                     //                 color: Colors.red,
    //                     //               )
    //                     //             : const Icon(Icons.favorite_border),
    //                     //         onPressed: () async {
    //                     //           if (state.documentIdFavorites!
    //                     //               .contains(product.id)) {
    //                     //             BlocProvider.of<FavoritesBloc>(context)
    //                     //                 .add(
    //                     //               UpdateFavoritesProductEvent(
    //                     //                   product.id),
    //                     //             );
    //                     //             ExtensionHome.favoritesDocumentId(
    //                     //                 context);
    //                     //           } else {
    //                     //             BlocProvider.of<FavoritesBloc>(context)
    //                     //                 .add(
    //                     //               AddFavoritesProductEvent(product.id),
    //                     //             );
    //                     //             ExtensionHome.favoritesDocumentId(
    //                     //                 context);
    //                     //           }
    //                     //         },
    //                     //       );
    //                     //     } else {
    //                     //       return Container(
    //                     //           child: Text('Waiting for an order'));
    //                     //     }
    //                     //   },),

    //                     // child: ValueListenableBuilder<List<String>>(
    //                     //   builder: (BuildContext context, List<String> val,
    //                     //       Widget? child) {
    //                     //     return IconButton(
    //                     //       icon: val.contains(product.id)
    //                     //           ? const Icon(
    //                     //               Icons.favorite_border,
    //                     //               color: Colors.red,
    //                     //             )
    //                     //           : const Icon(Icons.favorite_border),
    //                     //       onPressed: () async {
    //                     //         if (val.contains(product.id)) {
    //                     //           BlocProvider.of<FavoritesBloc>(context)
    //                     //               .add(
    //                     //             UpdateFavoritesProductEvent(product.id),
    //                     //           );
    //                     //           favoritesDocumentId();
    //                     //         } else {
    //                     //           BlocProvider.of<FavoritesBloc>(context)
    //                     //               .add(
    //                     //             AddFavoritesProductEvent(product.id),
    //                     //           );
    //                     //           favoritesDocumentId();
    //                     //         }
    //                     //       },
    //                     //     );
    //                     //   },
    //                     //   valueListenable: favoriteDocumentIds,
    //                     // ),
    //                     )
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   } else {
    //     return Center(child: Text('Something went wrong'));
    //   }
    // })),
  }
}

class ButtonHeartChowking extends StatefulWidget {
  const ButtonHeartChowking({super.key, this.id = ''});

  final String id;

  @override
  State<ButtonHeartChowking> createState() => _ButtonHeartChowkingState();
}

class _ButtonHeartChowkingState extends State<ButtonHeartChowking> {
  final ValueNotifier<List<String>> favoriteDocumentIds =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavoritesBloc>(context).add(
      GetProductsFavoritesEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listenWhen: (context, state) {
        return state.status == FavoriteStatus.COMPLETED;
      },
      listener: (context, state) {
        if (state.status == FavoriteStatus.COMPLETED) {
          if (state.documentFavoriteId == null) {
            return;
          }
          favoriteDocumentIds.value = state.documentFavoriteId!;
        } else if (state.status == FavoriteStatus.ERROR) {
          // ScaffoldMessenger.of(context)
          //     .hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error.toString()),
            duration: const Duration(seconds: 3),
          ));
        }
      },
      child: ValueListenableBuilder<List<String>>(
        builder: (BuildContext context, List<String> val, Widget? child) {
          return IconButton(
            icon: val.contains(widget.id)
                ? const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border),
            onPressed: () async {
              if (val.contains(widget.id)) {
                // BlocProvider.of<FavoritesBloc>(context).add(
                //   UpdateFavoritesProductEvent(id),
                // );
                context
                    .read<FavoritesBloc>()
                    .add(UpdateFavoritesProductEvent(widget.id));
              } else {
                // BlocProvider.of<FavoritesBloc>(context).add(
                //   AddFavoritesProductEvent(id),
                // );
                context
                    .read<FavoritesBloc>()
                    .add(AddFavoritesProductEvent(widget.id));
              }

              // BlocProvider.of<FavoritesBloc>(context).add(
              //   GetProductsFavoritesEvent(),
              // );
              context.read<FavoritesBloc>().add(GetProductsFavoritesEvent());
            },
          );
        },
        valueListenable: favoriteDocumentIds,
      ),
    );
  }
}
