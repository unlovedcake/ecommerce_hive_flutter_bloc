import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/models/nearby_response.dart';

final firebaseAuth = FirebaseAuth.instance;
final fireStore = FirebaseFirestore.instance;

final firebaseStorage = FirebaseStorage.instance;

late DocumentSnapshot? lastDocumentSnapshotJolliBee;
late DocumentSnapshot? lastDocumentSnapshotChowKing;
late DocumentSnapshot? lastDocumentSnapshotMcDonald;

//Map<PolylineId, Polyline> polylines = {};
List<Polyline> polylines = [];
NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
