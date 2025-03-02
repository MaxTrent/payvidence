import 'package:payvidence/datasource/data/product_datasource.dart';
import 'package:payvidence/model/product_model.dart';

abstract class IProductRepository {
  Future<List<Product>> fetchAllProduct(String businessId,
      {String? brandId, String? name, String? categoryId});
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
}
