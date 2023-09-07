part of '../views/home.dart';

class _Product_List_Tile_McDonald extends StatefulWidget {
  _Product_List_Tile_McDonald({
    super.key,
  });

  @override
  State<_Product_List_Tile_McDonald> createState() =>
      _Product_List_Tile_McDonaldState();
}

class _Product_List_Tile_McDonaldState
    extends State<_Product_List_Tile_McDonald> {
  ValueNotifier<List<Product>> productMcDonald =
      ValueNotifier<List<Product>>([]);

  final scrollController = ScrollController();

  final isMoreData = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isMoreData.value) {
        BlocProvider.of<ProductBloc>(context).add(
          GetProductsMcDonaldEvent('McDonald'),
        );
        BlocProvider.of<FavoritesBloc>(context).add(
          GetProductsFavoritesEvent(),
        );
      }
    });

    MyLogger.printInfo('_Product_List_Tile_McDonaldState');
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_Product_List_Tile_McDonald');

    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (context, state) {
        return state.status == Status.MCDONALDCOMPLETED;
      },
      listener: (context, state) {
        if (state.status == Status.MCDONALDCOMPLETED) {
          productMcDonald.value.addAll(state.products!);
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
          return state.status == Status.MCDONALDCOMPLETED;
        },
        builder: (context, state) {
          if (state.status == Status.MCDONALDCOMPLETED) {
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
                itemCount: productMcDonald.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = productMcDonald.value[index];
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
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrl,
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
                                  // Ink.image(
                                  //   image: NetworkImage(
                                  //     product.imageUrl,
                                  //   ),
                                  //   fit: BoxFit.cover,
                                  //   child: InkWell(
                                  //     onTap: () {},
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(product.name),
                            Text(product.price),
                            const SizedBox(
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
                          child: ButtonHeartMcDonald(id: product.id),
                        )
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
  }
}

class ButtonHeartMcDonald extends StatefulWidget {
  const ButtonHeartMcDonald({super.key, this.id = ''});

  final String id;

  @override
  State<ButtonHeartMcDonald> createState() => _ButtonHeartMcDonaldState();
}

class _ButtonHeartMcDonaldState extends State<ButtonHeartMcDonald> {
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
                context
                    .read<FavoritesBloc>()
                    .add(UpdateFavoritesProductEvent(widget.id));
              } else {
                context
                    .read<FavoritesBloc>()
                    .add(AddFavoritesProductEvent(widget.id));
              }

              context.read<FavoritesBloc>().add(GetProductsFavoritesEvent());
            },
          );
        },
        valueListenable: favoriteDocumentIds,
      ),
    );
  }
}
