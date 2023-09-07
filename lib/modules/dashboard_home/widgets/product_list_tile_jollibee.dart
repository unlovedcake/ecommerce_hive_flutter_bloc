part of '../views/home.dart';

class _Product_List_Tile_Jollibee extends StatefulWidget {
  _Product_List_Tile_Jollibee({
    super.key,
  });

  @override
  State<_Product_List_Tile_Jollibee> createState() =>
      _Product_List_Tile_JollibeeState();
}

class _Product_List_Tile_JollibeeState
    extends State<_Product_List_Tile_Jollibee> {
  ValueNotifier<List<Product>> productJollibee =
      ValueNotifier<List<Product>>([]);
  final ValueNotifier<List<String>> favoriteDocumentIds =
      ValueNotifier<List<String>>([]);
  final scrollController = ScrollController();

  late bool isMoreData;

  @override
  void initState() {
    super.initState();

    isMoreData = true;

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isMoreData) {
        // BlocProvider.of<ProductBloc>(context).add(
        //   GetProductsJolliBeeEvent('Jollibee'),
        // );
        //  BlocProvider.of<FavoritesBloc>(context).add(
        //   GetProductsFavoritesEvent(),
        // );

        context.read<ProductBloc>().add(GetProductsJolliBeeEvent('Jollibee'));

        // context.read<FavoritesBloc>().add(GetProductsFavoritesEvent());
      }
    });

    MyLogger.printInfo('_Product_List_Tile_JollibeeState');
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_Product_List_Tile_Jollibee');

    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (context, state) {
        return state.status == Status.JOLLIBEECOMPLETED;
      },
      listener: (context, state) {
        if (state.status == Status.JOLLIBEECOMPLETED) {
          productJollibee.value.addAll(state.products!);
          if (state.products!.length < 6) {
            isMoreData = false;

            MyLogger.printInfo('No More Data Jollibee');
          }
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
          return state.status == Status.JOLLIBEECOMPLETED;
        },
        builder: (context, state) {
          if (state.status == Status.JOLLIBEECOMPLETED) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                controller: scrollController,
                //physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: productJollibee.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = productJollibee.value[index];

                  return Card(
                    elevation: 4.0,
                    child: Ink(
                      decoration: BoxDecoration(color: Colors.white),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductProfile(
                                product: product,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 4 / 2,
                                    child: Hero(
                                      tag: product.id,
                                      child: CachedNetworkImage(
                                        imageUrl: product.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (
                                          context,
                                          url,
                                        ) =>
                                            Container(
                                                alignment: Alignment.center,
                                                width: 20,
                                                height: 20,
                                                child:
                                                    const CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(
                                        product.name,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                          color: const Color(0xffBA68C8),
                                        )),
                                      ),
                                      Text(product.price),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            _ButtonHeartJollibee(
                              id: product.id,
                              favoriteDocumentIds: favoriteDocumentIds,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  // return InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) => ProductProfile(
                  //           product: product,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: Card(
                  //     elevation: 4.0,
                  //     child: Stack(
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Expanded(
                  //               child: AspectRatio(
                  //                 aspectRatio: 4 / 2,
                  //                 child: Hero(
                  //                   tag: product.id,
                  //                   child: Material(
                  //                     child: Ink.image(
                  //                       image: CachedNetworkImageProvider(
                  //                         product.imageUrl,
                  //                       ),
                  //                       fit: BoxFit.cover,
                  //                       child: InkWell(
                  //                         onTap: () {
                  //                           Navigator.of(context).push(
                  //                             MaterialPageRoute(
                  //                               builder: (context) =>
                  //                                   ProductProfile(
                  //                                 product: product,
                  //                               ),
                  //                             ),
                  //                           );
                  //                         },
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   // child: CachedNetworkImage(
                  //                   //   imageUrl: product.imageUrl,
                  //                   //   placeholder: (
                  //                   //     context,
                  //                   //     url,
                  //                   //   ) =>
                  //                   //       Container(
                  //                   //           alignment: Alignment.center,
                  //                   //           width: 20,
                  //                   //           height: 20,
                  //                   //           child:
                  //                   //               const CircularProgressIndicator()),
                  //                   //   errorWidget: (context, url, error) =>
                  //                   //       const Icon(Icons.error),
                  //                   // ),
                  //                 ),
                  //               ),
                  //             ),
                  //             const SizedBox(
                  //               height: 8,
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.all(8),
                  //               child: Column(
                  //                 children: [
                  //                   Text(
                  //                     product.name,
                  //                     style: GoogleFonts.roboto(
                  //                         textStyle: TextStyle(
                  //                       color: const Color(0xffBA68C8),
                  //                     )),
                  //                   ),
                  //                   Text(product.price),
                  //                   const SizedBox(
                  //                     height: 8,
                  //                   ),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Positioned(
                  //             top: 8.0,
                  //             left: 4.0,
                  //             child: RichText(
                  //               text: const TextSpan(
                  //                 style: TextStyle(
                  //                     fontSize: 16.0,
                  //                     color: Colors.red,
                  //                     fontWeight: FontWeight.bold),
                  //                 children: <TextSpan>[
                  //                   TextSpan(text: 'Discount '),
                  //                   TextSpan(
                  //                     text: '10% ',
                  //                     style: TextStyle(
                  //                         color: Colors.black,
                  //                         fontWeight: FontWeight.bold,
                  //                         fontStyle: FontStyle.italic),
                  //                   ),
                  //                 ],
                  //               ),
                  //             )),
                  //         Positioned(
                  //           top: 4.0,
                  //           right: 0.0,
                  //           child: ButtonHeartJollibee(id: product.id),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: double.infinity,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: GridView.builder(
                          controller: scrollController,
                          //physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6),
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                            );
                          }))),
            );
          }
        },
      ),
    );
  }
}

class _ButtonHeartJollibee extends StatelessWidget {
  const _ButtonHeartJollibee({this.id = '', this.favoriteDocumentIds});
  final String id;
  final ValueNotifier<List<String>>? favoriteDocumentIds;
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
          favoriteDocumentIds!.value = state.documentFavoriteId!;
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
          return Positioned(
            top: 4.0,
            right: 0.0,
            child: IconButton(
              icon: val.contains(id)
                  ? const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
              onPressed: () async {
                if (val.contains(id)) {
                  context
                      .read<FavoritesBloc>()
                      .add(UpdateFavoritesProductEvent(id));
                } else {
                  // BlocProvider.of<FavoritesBloc>(context).add(
                  //   AddFavoritesProductEvent(id),
                  // )
                  context
                      .read<FavoritesBloc>()
                      .add(AddFavoritesProductEvent(id));
                }

                context.read<FavoritesBloc>().add(GetProductsFavoritesEvent());
              },
            ),
          );
        },
        valueListenable: favoriteDocumentIds!,
      ),
    );
  }
}
