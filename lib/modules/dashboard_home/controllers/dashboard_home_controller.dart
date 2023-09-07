part of '../views/home.dart';

extension on _HomeState {
  void _getProductsEvent() {
    lastDocumentSnapshotJolliBee = null;
    lastDocumentSnapshotChowKing = null;
    lastDocumentSnapshotMcDonald = null;

    BlocProvider.of<ProductBloc>(context).add(
      GetProductsFeaturedEvent(),
    );

    BlocProvider.of<ProductBloc>(context).add(
      GetProductsJolliBeeEvent('Jollibee'),
    );

    BlocProvider.of<ProductBloc>(context).add(
      GetProductsChowkingEvent('Chowking'),
    );

    BlocProvider.of<ProductBloc>(context).add(
      GetProductsMcDonaldEvent('McDonald'),
    );
    BlocProvider.of<FavoritesBloc>(context).add(
      GetProductsFavoritesEvent(),
    );
  }
  // void favoritesDocumentId() {
  //   _getDocumentIdFavorites();
  //   final bloc = BlocProvider.of<FavoritesBloc>(context);

  //   bloc.stream.listen((state) {
  //     if (state is ProductsFavoriteErrorState) {
  //       print('ds');
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(state.error),
  //         duration: Duration(seconds: 3),
  //       ));
  //     } else if (state is ProductsFavoriteLoadedState) {
  //       favoriteDocumentIds.value = state.documentIdFavorites!;
  //     }
  //   });
  // }
}
