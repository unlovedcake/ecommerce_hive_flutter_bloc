import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/models/product_model.dart';

class ProductRepository {
  static const String _products = 'products';
  static const String _featuredProducts = 'featured_products';

  static Future<List<Product>> getAllFeaturedProducts() async {
    final collectionRef = fireStore.collection(_featuredProducts);
    final result = await collectionRef.get();
    try {
      final products = result.docs.map((doc) {
        final map = doc.data();

        return Product.fromMap(map);
      }).toList();

      MyLogger.printInfo('Fetched Featured Products');

      return products;
    } catch (e) {
      MyLogger.printError(e);
      rethrow;
    }
  }

  static Future<List<Product>> fetchProductsJolliBee(String category) async {
    try {
      const limit = 6;
      final collectionRef = fireStore.collection(_products);

      Query query =
          collectionRef.where('category', isEqualTo: category).limit(limit);
      if (lastDocumentSnapshotJolliBee != null) {
        query = query.startAfterDocument(lastDocumentSnapshotJolliBee!);
      } else {
        query = query;
      }

      final result = await query.get();
      if (result.docs.isNotEmpty) {
        lastDocumentSnapshotJolliBee = result.docs.last;
      }

      final products = result.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        return Product.fromMap(map);
      }).toList();

      return products;
    } catch (_) {
      rethrow;
    }
  }

  static Future<List<Product>> fetchProductsChowKing(String category) async {
    try {
      const limit = 6;
      final collectionRef = fireStore.collection(_products);

      Query query =
          collectionRef.where('category', isEqualTo: category).limit(limit);
      if (lastDocumentSnapshotChowKing != null) {
        query = query.startAfterDocument(lastDocumentSnapshotChowKing!);
      } else {
        query = query;
      }

      final result = await query.get();
      if (result.docs.isNotEmpty) {
        lastDocumentSnapshotChowKing = result.docs.last;
      }

      final products = result.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        return Product.fromMap(map);
      }).toList();

      return products;
    } catch (_) {
      rethrow;
    }
  }

  static Future<List<Product>> fetchProductsMcDonald(String category) async {
    try {
      const limit = 6;
      final collectionRef = fireStore.collection(_products);

      Query query =
          collectionRef.where('category', isEqualTo: category).limit(limit);
      if (lastDocumentSnapshotMcDonald != null) {
        query = query.startAfterDocument(lastDocumentSnapshotMcDonald!);
      } else {
        query = query;
      }

      final result = await query.get();
      if (result.docs.isNotEmpty) {
        lastDocumentSnapshotMcDonald = result.docs.last;
      }

      final products = result.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        return Product.fromMap(map);
      }).toList();

      return products;
    } catch (_) {
      rethrow;
    }
  }

  static Future<List<String>> fetchFavoriteDocumentIds() async {
    try {
      QuerySnapshot querySnapshot = await fireStore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('favourites')
          .where('is_heart', isEqualTo: true)
          .get();

      MyLogger.printInfo('Fetched Favorites Document ID');

      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      MyLogger.printError(e);
      rethrow;
    }
  }

  static Future<void> updateIsHeartField(String documentId) async {
    try {
      SetOptions(merge: true);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('favourites')
          .doc(documentId)
          .update(
        {
          'is_heart': false,
        },
      );
      MyLogger.printInfo('Updated Heart Button to false');
    } catch (e) {
      MyLogger.printError(e);
      rethrow;
    }
  }

  static Future<void> addFavorites(String documentId) async {
    try {
      final userRef = fireStore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('favourites')
          .doc(documentId);

      userRef.set({'is_heart': true, 'product_id': documentId});
      MyLogger.printInfo('Added Heart Button to true');
    } catch (e) {
      MyLogger.printError(e);
      rethrow;
    }
  }
}
