import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/bloc/search_bloc/search_bloc.dart';
import 'package:hive/bloc/search_bloc/search_bloc.dart';
import 'package:hive/models/nearby_response.dart';
import 'package:hive/repositories/search_repository.dart';
import 'package:http/http.dart' as http;
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../../../instances/firebase_instances.dart';
part '../controllers/dashboard_search_controller.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String googleApiKey = "AIzaSyDNQDYD_Gf_z1nyammhkEPwOBeP_fP6VYc";

  //GoogleMapController? mapController;

  // ValueNotifier<GoogleMapController?> mapController =
  //     ValueNotifier<GoogleMapController?>(null);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  CameraPosition? cameraPosition;

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  Position? _currentUserPosition;
  LatLng startLocation = const LatLng(10.2640, 123.8425);
  LatLng endLocation = const LatLng(10.3157, 123.8854);

  final ValueNotifier<List<Marker>> _markers = ValueNotifier<List<Marker>>([]);

  @override
  void initState() {
    super.initState();

    nearbyPlacesResponse.results = [];

    BlocProvider.of<SearchBloc>(context).add(
      GetMarkerUserEvent(),
    );

    //_userMaker();
    _determinePosition();

    MyLogger.printInfo('Search');
  }

  // _userMaker() async {
  //   String imgUrlMyLocation = 'https://www.fluttercampus.com/img/car.png';
  //   Uint8List bytesMyLocation =
  //       (await NetworkAssetBundle(Uri.parse(imgUrlMyLocation))
  //               .load(imgUrlMyLocation))
  //           .buffer
  //           .asUint8List();
  //   _markers.value.add(
  //     const Marker(
  //       markerId: MarkerId('user'),
  //       position: LatLng(10.2524, 123.8392),
  //       //_currentUserPosition.latitude, _currentUserPosition.longitude,
  //       infoWindow: InfoWindow(
  //         title: 'Love',
  //         snippet: 'Your Current Location',
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ),
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
    //mapController?.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Search'),
      // ),
      body: SafeArea(
        child: BlocListener<SearchBloc, SearchState>(
          // listenWhen: (context, state) {
          //   return state.status == SearchStatus.COMPLETED;
          // },
          // listenWhen: (context, state) {
          //   return state.status == SearchStatus.COMPLETED;
          // },

          listener: (context, state) {
            if (state.status == SearchStatus.LOADING) {
              isLoading.value = true;
            } else if (state.status == SearchStatus.COMPLETED) {
              isLoading.value = false;
              print('isloading');
              print(isLoading.value);
              _markers.value = state.markers!;
            } else if (state.status == SearchStatus.ERROR) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error.toString())));
            }
          },
          child: ValueListenableBuilder<List<Marker>>(
            builder: (BuildContext context, List<Marker> val, Widget? child) {
              return Stack(
                children: [
                  GoogleMap(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.55),
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: startLocation,
                      zoom: 14.0,
                    ),
                    markers: Set<Marker>.of(_markers.value),
                    //polylines: Set<Polyline>.of(polylines),
                    // circles: {
                    //   Circle(
                    //       circleId: CircleId('1'),
                    //       center: startLocation,
                    //       radius: 500,
                    //       strokeWidth: 2,
                    //       fillColor: Colors.black12.withOpacity(0.2))
                    // },

                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      //mapController = controller;
                      mapController.complete(controller);
                    },
                    // onCameraMove: (CameraPosition cameraPositions) {
                    //   cameraPosition = cameraPositions;
                    // },
                  ),
                  Positioned(
                    top: 16, // Adjust the top position of the chips
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context).add(
                              GetMarkersEvent('jollibee'),
                            );
                          },
                          child: Chip(
                            labelPadding: const EdgeInsets.all(2.0),
                            avatar: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://www.clipartmax.com/png/middle/133-1332451_jollibee-clipart-classic-jollibee-fast-food-logo.png'),
                            ),
                            label: const Text(
                              'Jollibee',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.red,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context).add(
                              GetMarkersEvent('chowking'),
                            );
                          },
                          child: Chip(
                            labelPadding: const EdgeInsets.all(2.0),
                            avatar: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://e7.pngegg.com/pngimages/657/208/png-clipart-chowking-logo-chowking-restaurant-philippines-logo-menu-menu-food-text-thumbnail.png'),
                            ),
                            label: const Text(
                              'Chowking',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.blue,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context).add(
                              GetMarkersEvent('mcdonald'),
                            );
                          },
                          child: Chip(
                            labelPadding: const EdgeInsets.all(2.0),
                            avatar: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://e7.pngegg.com/pngimages/676/74/png-clipart-fast-food-mcdonald-s-logo-golden-arches-restaurant-mcdonalds-mcdonald-s-logo-miscellaneous-food-thumbnail.png'),
                            ),
                            label: const Text(
                              'McDonald',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.orange,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BlocBuilder<SearchBloc, SearchState>(
                  //   buildWhen: (context, state) {
                  //     return state.status == SearchStatus.COMPLETED;
                  //   },
                  //   builder: (context, state) {
                  //     if (state.status == SearchStatus.LOADING) {
                  //       return Container(
                  //           height: double.infinity,
                  //           width: double.infinity,
                  //           color: Colors.black.withOpacity(0.7),
                  //           child: const SpinKitCircle(
                  //             color: Colors.black,
                  //             size: 60,
                  //           ));
                  //     } else {
                  //       return Positioned(
                  //           bottom: 0, // Adjust the top position of the chips
                  //           left: 0,
                  //           right: 0,
                  //           child: nearbyPlacesResponse.results!.isEmpty
                  //               ? Container(
                  //                   height: 100,
                  //                   color: Colors.white,
                  //                   child: const Center(
                  //                       child: Text('No Store Found')),
                  //                 )
                  //               : Container(
                  //                   color: Colors.white,
                  //                   height: 200,
                  //                   child: ListView.separated(
                  //                     itemCount:
                  //                         nearbyPlacesResponse.results!.length,
                  //                     itemBuilder:
                  //                         (BuildContext context, int index) {
                  //                       nearbyPlacesResponse.results?.sort(
                  //                           (a, b) => a.distanceKilometer!
                  //                               .compareTo(
                  //                                   b.distanceKilometer!));

                  //                       var urlLogo = nearbyPlacesResponse
                  //                                   .results?[index].name
                  //                                   .toString() ==
                  //                               'Jollibee'
                  //                           ? 'https://upload.wikimedia.org/wikipedia/en/thumb/8/84/Jollibee_2011_logo.svg/1200px-Jollibee_2011_logo.svg.png'
                  //                           : nearbyPlacesResponse
                  //                                       .results?[index].name
                  //                                       .toString() ==
                  //                                   "McDonald's"
                  //                               ? 'https://logos-world.net/wp-content/uploads/2020/04/McDonalds-Emblem.png'
                  //                               : 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d6/Chowking_logo.svg/800px-Chowking_logo.svg.png';

                  //                       return ListTile(
                  //                         contentPadding:
                  //                             const EdgeInsets.all(8),
                  //                         style: ListTileStyle.drawer,
                  //                         leading: CircleAvatar(
                  //                           backgroundColor: Colors.transparent,
                  //                           backgroundImage:
                  //                               NetworkImage(urlLogo),
                  //                         ),
                  //                         title: Text(nearbyPlacesResponse
                  //                                 .results?[index].name
                  //                                 .toString() ??
                  //                             ''),
                  //                         subtitle: Column(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             Text(nearbyPlacesResponse
                  //                                     .results?[index].vicinity
                  //                                     .toString() ??
                  //                                 ''),
                  //                             Text(
                  //                                 '${nearbyPlacesResponse.results?[index].distanceKilometer!.toStringAsFixed(1)} km'),
                  //                           ],
                  //                         ),
                  //                         onTap: () {
                  //                           // Handle tile tap if needed
                  //                         },
                  //                       );
                  //                     },
                  //                     separatorBuilder:
                  //                         (BuildContext context, int index) =>
                  //                             const SizedBox(
                  //                       height: 6,
                  //                     ),
                  //                   ),
                  //                 ));
                  //     }
                  //   },
                  // ),
                  ValueListenableBuilder<bool>(
                    builder: (BuildContext context, bool val, Widget? child) {
                      return isLoading.value
                          ? Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.black.withOpacity(0.7),
                              child: const SpinKitCircle(
                                color: Colors.white,
                                size: 60,
                              ))
                          : Positioned(
                              bottom: 0, // Adjust the top position of the chips
                              left: 0,
                              right: 0,
                              child: nearbyPlacesResponse.results!.isEmpty
                                  ? Container(
                                      height: 100,
                                      color: Colors.white,
                                      child: const Center(
                                          child: Text('No Store Found')),
                                    )
                                  : Container(
                                      color: Colors.white,
                                      height: 200,
                                      child: ListView.separated(
                                        itemCount: nearbyPlacesResponse
                                            .results!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          nearbyPlacesResponse.results?.sort(
                                              (a, b) => a.distanceKilometer!
                                                  .compareTo(
                                                      b.distanceKilometer!));

                                          var urlLogo = nearbyPlacesResponse
                                                      .results?[index].name
                                                      .toString() ==
                                                  'Jollibee'
                                              ? 'https://upload.wikimedia.org/wikipedia/en/thumb/8/84/Jollibee_2011_logo.svg/1200px-Jollibee_2011_logo.svg.png'
                                              : nearbyPlacesResponse
                                                          .results?[index].name
                                                          .toString() ==
                                                      "McDonald's"
                                                  ? 'https://logos-world.net/wp-content/uploads/2020/04/McDonalds-Emblem.png'
                                                  : 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d6/Chowking_logo.svg/800px-Chowking_logo.svg.png';

                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            style: ListTileStyle.drawer,
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage:
                                                  NetworkImage(urlLogo),
                                            ),
                                            title: Text(nearbyPlacesResponse
                                                    .results?[index].name
                                                    .toString() ??
                                                ''),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(nearbyPlacesResponse
                                                        .results?[index]
                                                        .vicinity
                                                        .toString() ??
                                                    ''),
                                                Text(
                                                    '${nearbyPlacesResponse.results?[index].distanceKilometer!.toStringAsFixed(1)} km'),
                                              ],
                                            ),
                                            onTap: () {
                                              // Handle tile tap if needed
                                            },
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const SizedBox(
                                          height: 6,
                                        ),
                                      ),
                                    ));
                    },
                    valueListenable: isLoading,
                  )
                ],
              );
            },
            valueListenable: _markers,
          ),
        ),
      ),

      // BlocConsumer<SearchBloc, SearchState>(
      //   // listenWhen: (context, state) {
      //   //   return state.status == SearchStatus.COMPLETED;
      //   // },
      //   buildWhen: (context, state) {
      //     return state.status == SearchStatus.COMPLETED;
      //   },
      //   listener: (context, state) {
      //     if (state.status == SearchStatus.COMPLETED) {
      //       //_markers.value = state.markers!;
      //     } else if (state.status == SearchStatus.ERROR) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(content: Text(state.error.toString())));
      //     }
      //   },

      //   builder: (context, state) {
      //     if (state.status == SearchStatus.COMPLETED) {
      //       return Stack(
      //         children: [
      //           GoogleMap(
      //             padding: const EdgeInsets.only(bottom: 20),
      //             zoomGesturesEnabled: true,
      //             initialCameraPosition: CameraPosition(
      //               target: startLocation,
      //               zoom: 14.0,
      //             ),
      //             markers: Set<Marker>.of(state.markers ?? []),
      //             // circles: {
      //             //   Circle(
      //             //       circleId: CircleId('1'),
      //             //       center: startLocation,
      //             //       radius: 500,
      //             //       strokeWidth: 2,
      //             //       fillColor: Colors.black12.withOpacity(0.2))
      //             // },
      //             mapType: MapType.normal,
      //             onMapCreated: (controller) {
      //               mapController.value = controller;
      //             },
      //             onCameraMove: (CameraPosition cameraPositions) {
      //               cameraPosition = cameraPositions;
      //             },
      //           ),
      //           Positioned(
      //             top: 16, // Adjust the top position of the chips
      //             left: 0,
      //             right: 0,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     BlocProvider.of<SearchBloc>(context).add(
      //                       GetMarkersEvent('jollibee'),
      //                     );
      //                   },
      //                   child: Chip(
      //                     labelPadding: const EdgeInsets.all(2.0),
      //                     avatar: CircleAvatar(
      //                       backgroundImage: NetworkImage(
      //                           'https://www.clipartmax.com/png/middle/133-1332451_jollibee-clipart-classic-jollibee-fast-food-logo.png'),
      //                     ),
      //                     label: const Text(
      //                       'Jollibee',
      //                       style: TextStyle(
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                     backgroundColor: Colors.red,
      //                     elevation: 6.0,
      //                     shadowColor: Colors.grey[60],
      //                     padding: const EdgeInsets.all(8.0),
      //                   ),
      //                 ),
      //                 InkWell(
      //                   onTap: () {
      //                     BlocProvider.of<SearchBloc>(context).add(
      //                       GetMarkersEvent('chowking'),
      //                     );
      //                   },
      //                   child: Chip(
      //                     labelPadding: const EdgeInsets.all(2.0),
      //                     avatar: CircleAvatar(
      //                       backgroundImage: NetworkImage(
      //                           'https://e7.pngegg.com/pngimages/657/208/png-clipart-chowking-logo-chowking-restaurant-philippines-logo-menu-menu-food-text-thumbnail.png'),
      //                     ),
      //                     label: const Text(
      //                       'Chowking',
      //                       style: TextStyle(
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                     backgroundColor: Colors.blue,
      //                     elevation: 6.0,
      //                     shadowColor: Colors.grey[60],
      //                     padding: const EdgeInsets.all(8.0),
      //                   ),
      //                 ),
      //                 InkWell(
      //                   onTap: () {},
      //                   child: Chip(
      //                     labelPadding: const EdgeInsets.all(2.0),
      //                     avatar: CircleAvatar(
      //                       backgroundImage: NetworkImage(
      //                           'https://e7.pngegg.com/pngimages/676/74/png-clipart-fast-food-mcdonald-s-logo-golden-arches-restaurant-mcdonalds-mcdonald-s-logo-miscellaneous-food-thumbnail.png'),
      //                     ),
      //                     label: const Text(
      //                       'McDonald',
      //                       style: TextStyle(
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                     backgroundColor: Colors.orange,
      //                     elevation: 6.0,
      //                     shadowColor: Colors.grey[60],
      //                     padding: const EdgeInsets.all(8.0),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       );
      //     } else {
      //       return Container(child: const Text('No State'));
      //     }
      //   },
      // ),
    );
  }
}
