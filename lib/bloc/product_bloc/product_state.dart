// ignore_for_file: constant_identifier_names

part of 'product_bloc.dart';

enum Status {
  INITIAL,
  LOADING,
  FEATUREDPRODUCTSCOMPLETED,
  JOLLIBEECOMPLETED,
  CHOWKINGCOMPLETED,
  MCDONALDCOMPLETED,
  ERROR
}

class ProductState extends Equatable {
  final Status status;
  final String? error;
  final List<Product>? products;

  const ProductState({required this.status, this.error, this.products});

  factory ProductState.initial() {
    return const ProductState(status: Status.INITIAL);
  }

  ProductState copyWith(
      {required Status status, String? error, List<Product>? product}) {
    return ProductState(status: status, error: error, products: product);
  }

  @override
  List<Object?> get props => [status, error, products];
}
