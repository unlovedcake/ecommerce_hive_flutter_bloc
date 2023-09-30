import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/bloc/Internet/internet_bloc.dart';
import 'package:hive/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:hive/bloc/auth/auth_bloc.dart';
import 'package:hive/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:hive/bloc/product_bloc/product_bloc.dart';
import 'package:hive/constants/sendbird_instance.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive/modules/cart_item/views/cart_item.dart';
import 'package:hive/modules/product_profile/views/product_profile.dart';
import 'package:hive/modules/sign_in/sign_in.dart';
import 'package:hive/routes/app_router.dart';
import 'package:hive/widgets/circular_avatar_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;
part '../controllers/dashboard_home_controller.dart';
part '../widgets/product_list_tile_jollibee.dart';
part '../widgets/product_list_tile_chowking.dart';
part '../widgets/product_list_tile_mcdonald.dart';
part '../widgets/product_list_tile_featured.dart';
part '../widgets/index_stack_with_fade_animation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _getProductsEvent();
    MyLogger.printInfo('Home');
  }

  // void _addDummyDataProducts() async {
  //   try {
  //     for (int i = 0; i < 5; i++) {
  //       final productId = await FirebaseFirestore.instance
  //           .collection('featured_products')
  //           .doc();

  //       final product = Product(
  //         id: productId.id,
  //         name: 'Chickenjoy Bucket with Joly Spagheti',
  //         price: '143.00',
  //         category: 'Jollibee',
  //         description: 'description$i',
  //         imageUrl:
  //             'https://img.freepik.com/premium-vector/business-global-economy_24877-41082.jpg',
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       );

  //       productId.set(product.toMap());

  //       print('Added');
  //     }
  //   } catch (error) {
  //     print('Error adding product: $error');
  //   }
  // }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final totalQuantity = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    // super.build(context);

    totalQuantity.value = addToCartsListItem.fold(
      0,
      (int previousValue, product) =>
          previousValue + (int.parse(product['quantity'])),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffBA68C8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              firebaseAuth.currentUser?.displayName.toString() ?? '',
              style: const TextStyle(color: Colors.black38, fontSize: 14),
            ),
          ],
        ),
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: CircularAvatarWidget(
        //     imageUrl: firebaseAuth.currentUser!.photoURL.toString(),
        //     outerRadius: 27,
        //     innerRadius: 26,
        //   ),
        // ),
        actions: [
          BlocConsumer<AddToCartBloc, AddToCartState>(
            listenWhen: (context, state) {
              return state.status == AddToCartStatus.COMPLETED;
            },
            listener: (context, state) {
              if (state.status == AddToCartStatus.COMPLETED) {
              } else if (state.status == AddToCartStatus.ERROR) {}
            },
            buildWhen: (context, state) {
              return state.status == AddToCartStatus.COMPLETED;
            },
            builder: (context, state) {
              if (state.status == AddToCartStatus.COMPLETED) {
                return state.quantityItem == null || state.quantityItem == 0
                    ? const Icon(Icons.shopping_cart)
                    : badges.Badge(
                        position: badges.BadgePosition.topEnd(top: 0, end: 3),
                        badgeAnimation: const badges.BadgeAnimation.fade(
                          disappearanceFadeAnimationDuration:
                              Duration(milliseconds: 200),
                          curve: Curves.easeInCubic,
                        ),
                        showBadge: true,
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Colors.red,
                        ),
                        badgeContent: Text(
                          state.quantityItem.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              BlocProvider.of<AddToCartBloc>(context).add(
                                AddCartQuantityItemEvent(addToCartsListItem),
                              );
                              Navigator.push(
                                  context,
                                  RouterPageAnimation.goToPage(
                                      const CartItem()));
                            }),
                      );
              } else {
                return const Icon(Icons.shopping_cart);
              }
            },
          ),
          // ValueListenableBuilder(
          //   builder: (BuildContext context, value, Widget? child) {
          //     return badges.Badge(
          //       position: badges.BadgePosition.topEnd(top: 0, end: 3),
          //       badgeAnimation: badges.BadgeAnimation.slide(
          //           // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
          //           // curve: Curves.easeInCubic,
          //           ),
          //       showBadge: true,
          //       badgeStyle: badges.BadgeStyle(
          //         badgeColor: Colors.blue,
          //       ),
          //       badgeContent: Text(
          //         totalQuantity.value.toString(),
          //         style: TextStyle(color: Colors.white),
          //       ),
          //       child: IconButton(
          //           icon: Icon(Icons.shopping_cart), onPressed: () {}),
          //     );
          //   },
          //   valueListenable: totalQuantity,
          // ),
          // badges.Badge(
          //   position: badges.BadgePosition.topEnd(top: 0, end: 3),
          //   badgeAnimation: badges.BadgeAnimation.slide(
          //       // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
          //       // curve: Curves.easeInCubic,
          //       ),
          //   showBadge: true,
          //   badgeStyle: badges.BadgeStyle(
          //     badgeColor: Colors.blue,
          //   ),
          //   badgeContent: Text(
          //     totalQuantity.toString(),
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   child:
          //       IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
          // ),

          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil('/', (Route route) => false);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                  (route) => false,
                );
              }
            },
            child: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    SignOutRequested(),
                  );
                }),
          ),

          // IconButton(
          //     icon: const Icon(Icons.app_registration_rounded),
          //     onPressed: () => Navigator.pushNamed(context, '/register')),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "What's New",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          //_InternetConnectionWidget(),
          const _FeaturedProducts(),
          DefaultTabController(
              length: 5,
              child: TabBar(
                indicatorColor: const Color(0xffBA68C8),
                onTap: (index) {
                  _index.value = index;
                  // if (index == 0) {
                  //   // context
                  //   //     .read<ProductBloc>()
                  //   //     .add(GetProductsEvent('Jollibee'));
                  // } else if (index == 1) {
                  // context
                  //     .read<ProductBloc>()
                  //     .add(GetProductsChowkingEvent('Chowking'));
                  // }
                },
                isScrollable: true,
                tabs: const [
                  Tab(
                    child: Text(
                      'Jollibee',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child:
                        Text('Chowking', style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child: Text('Mc Donald',
                        style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child: Text('Mang Inasal',
                        style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child:
                        Text('DimSum', style: TextStyle(color: Colors.black)),
                  ),
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
              builder: (BuildContext context, int value, Widget? child) {
                return _IndexStackWithFadeAnimation(
                  index: value,
                  children: [
                    _Product_List_Tile_Jollibee(),
                    _Product_List_Tile_Chowking(),
                    _Product_List_Tile_McDonald(),
                  ],
                );

                // IndexedStack(
                //   index: value,
                //   children: [
                //     _Product_List_Tile_Jollibee(),
                //     _Product_List_Tile_Chowking(),
                //     _Product_List_Tile_McDonald(),
                //   ],
                // );
              },
              valueListenable: _index,
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}

class _InternetConnectionWidget extends StatelessWidget {
  const _InternetConnectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<InternetBloc>(context).add(
    //   InternetConnectedEvent(),
    // );

    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state.status == InternetStatus.DISCONNECTED) {
          print('disconnected');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Disconnected'),
            duration: Duration(seconds: 3),
          ));
        } else if (state.status == InternetStatus.CONNECTED) {
          print('connected');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Connected'),
            duration: Duration(seconds: 3),
          ));
        }
      },
      child: const SizedBox(),
      // child: BlocBuilder<InternetBloc, InternetState>(
      //   // buildWhen: (context, state) {
      //   //   print(state.status);
      //   //   print('status');
      //   //   return state.status == InternetStatus.DISCONNECTED;
      //   // },
      //   builder: (context, state) {
      //     print(state.status);
      //     print('statuz');
      //     if (state.status == InternetStatus.DISCONNECTED) {
      //       return Container(child: Text('disconnected'));
      //     } else if (state.status == InternetStatus.CONNECTED) {
      //       return Container(child: Text('connected'));
      //     } else {
      //       return Container(child: Text('none'));
      //     }
      //   },
      // ),
    );
    // return Builder(
    //   builder: (context) {

    //     BlocProvider.of<InternetBloc>(context).add(
    //       InternetConnectedEvent(),
    //     );
    //     final internetState = context.watch<InternetBloc>().state;

    //     if (internetState.status == InternetStatus.DISCONNECTED) {
    //       return Text(
    //         'Disconected',
    //         style: Theme.of(context).textTheme.headline6,
    //       );
    //     } else {
    //       return Text('Connected');
    //     }
    //   },
    // );
  }
}
