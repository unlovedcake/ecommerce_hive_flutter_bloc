part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddProductEvent extends ProductEvent {
  final Product? products;

  AddProductEvent(this.products);
}

class GetProductsFeaturedEvent extends ProductEvent {
  GetProductsFeaturedEvent();
}

class GetProductsJolliBeeEvent extends ProductEvent {
  final String? category;

  GetProductsJolliBeeEvent(this.category);
}

class GetProductsChowkingEvent extends ProductEvent {
  final String? category;

  GetProductsChowkingEvent(this.category);
}

class GetProductsMcDonaldEvent extends ProductEvent {
  final String? category;

  GetProductsMcDonaldEvent(this.category);
}

class GetProductByIDEvent extends ProductEvent {
  final String id;
  GetProductByIDEvent(this.id);
}
