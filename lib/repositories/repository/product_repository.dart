import 'package:dio/dio.dart';
import 'package:payvidence/datasource/data/product_datasource.dart';
import 'package:payvidence/model/product_model.dart';

abstract class IProductRepository {
  Future<List<Product>> fetchAllProduct(String businessId,
      {String? brandId, String? name, String? categoryId});

  Future<Product> addProduct(FormData requestData);

  Future<void> deleteProduct(String productId);

  Future<Product> updateProduct(FormData requestData, String productId);

  Future<Product> restockProduct(String productId, int quantity);
}

class ProductRepository extends IProductRepository {
  final IProductDatasource productDatasource;

  ProductRepository(this.productDatasource);

  @override
  Future<List<Product>> fetchAllProduct(String businessId,
      {String? brandId, String? name, String? categoryId}) {
    return productDatasource.fetchAllProducts(businessId,
        name: name, categoryId: categoryId, brandId: brandId);
  }

  @override
  Future<Product> addProduct(FormData requestData) {
    return productDatasource.addProduct(requestData);
  }

  @override
  Future<void> deleteProduct(String productId) {
    return productDatasource.deleteProduct(productId);
  }

  @override
  Future<Product> updateProduct(FormData requestData, String productId) {
    return productDatasource.updateProduct(requestData, productId);
  }

  @override
  Future<Product> restockProduct(String productId, int quantity) {
    return productDatasource.restockProduct(productId, quantity);
  }
}
