part of '../views/home.dart';

class _FeaturedProducts extends StatelessWidget {
  const _FeaturedProducts();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
        listenWhen: (context, state) {
          return state.status == Status.FEATUREDPRODUCTSCOMPLETED;
        },
        listener: (context, state) {
          if (state.status == Status.ERROR) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error.toString()),
              duration: const Duration(seconds: 3),
            ));
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          buildWhen: (context, state) {
            return state.status == Status.FEATUREDPRODUCTSCOMPLETED;
          },
          builder: (context, state) {
            if (state.status == Status.FEATUREDPRODUCTSCOMPLETED) {
              return SizedBox(
                height: 200,
                child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final product = state.products![index];
                      return SizedBox(
                        width: 250,
                        child: Column(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 4 / 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Ink.image(
                                        image: CachedNetworkImageProvider(
                                          product.imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                        child: InkWell(
                                          onTap: () {},
                                        ),
                                      ),
                                      // child: CachedNetworkImage(
                                      //   fit: BoxFit.cover,
                                      //   imageUrl: product.imageUrl,
                                      //   progressIndicatorBuilder: (context, url,
                                      //           downloadProgress) =>
                                      //       Container(
                                      //           alignment: Alignment.center,
                                      //           width: 20,
                                      //           height: 20,
                                      //           child:
                                      //               CircularProgressIndicator()),
                                      //   errorWidget: (context, url, error) =>
                                      //       const Icon(Icons.error),
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              product.name,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                color: Color(0xffBA68C8),
                              )),
                            ),
                            Text(product.price)
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, _) => const SizedBox(
                          width: 6,
                        ),
                    itemCount: state.products!.length),
              );
            } else {
              return SizedBox(
                width: double.infinity,
                height: 160.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    separatorBuilder: (context, _) => const SizedBox(
                      width: 6,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 240,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300,
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ));
  }
}
