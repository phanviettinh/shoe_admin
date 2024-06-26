import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/admin/screen/home/home_admin.dart';
import 'package:shoe_admin/admin/screen/products/show_product_admin.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/products/product_reposotory.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/features/shop/controllers/category_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/product_controller.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/features/shop/models/category_model.dart';
import 'package:shoe_admin/features/shop/models/product_attribute_model.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/features/shop/models/product_variation_model.dart';
import 'package:shoe_admin/utils/constants/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AllProductController extends GetxController {
  static AllProductController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final salePriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final thumbnailController = TextEditingController();
  final categoryIdController = TextEditingController();
  final categoryNameController = TextEditingController();
  final sku = TextEditingController();

  final Rx<ProductType> selectedProductType = ProductType.single.obs;

  final RxList<TextEditingController> images = <TextEditingController>[].obs;
  final RxBool isFeatured = false.obs;

  ///variation
  final brandIdController = TextEditingController();
  final brandNameController = TextEditingController();
  final brandImageController = TextEditingController();
  final brandProductsCountController = TextEditingController();
  final RxBool brandIsFeatured = false.obs;
  final RxList<ProductAttributeModel> attributes = <ProductAttributeModel>[].obs;
  final RxList<TextEditingController> values = <TextEditingController>[].obs; // For managing attribute values

  final RxList<ProductVariationModel> variations = <ProductVariationModel>[].obs;

  final id = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController();
  final stock = TextEditingController();
  final color = TextEditingController();
  final size = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final CategoryController categoryController = CategoryController.instance;
  final BrandController brandController = BrandController.instance;

  final RxString selectedProductId = ''.obs;

  TextEditingController searchController = TextEditingController(); // Added
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs; // Added
  var isLoading = true.obs;
  final RxString imageUrl = ''.obs; // Quan sát URL hình ảnh

  @override
  void onInit() {
    listenToProduct();
    super.onInit();
  }

  ///fetch controller
  void listenToProduct() {
    repository.getProductStream().listen((products) {
      allProducts.assignAll(products);
      products.assignAll(allProducts.where((products) => products.isFeatured ));
      filteredProducts.assignAll(allProducts); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      // Fetch products from your data source
      List<ProductModel> products = await ProductRepository.instance.getAllFeaturedProductsNotIsFeatured();
      assignProducts(products);
    } catch (e) {
      // Handle error
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void addImage() {
    images.add(TextEditingController());
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  void addValue(int attributeIndex) {
    attributes[attributeIndex].values?.add('');
  }

  void removeValue(int attributeIndex, int valueIndex) {
    attributes[attributeIndex].values?.removeAt(valueIndex);
  }

  void addAttribute() {
    attributes.add(ProductAttributeModel(name: '', values: <String>[].obs));
  }

  void removeAttribute(int index) {
    attributes.removeAt(index);
  }

  void showBrandPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Brand'),
          content: SingleChildScrollView(
            child: ListBody(
              children: brandController.allBrands.map((brand) {
                return ListTile(
                  leading: Image.network(brand.image, width: 50, height: 50),
                  title: Text(brand.name),
                  onTap: () {
                    final localImagePath = 'assets/icons/brands/${brand.name}.jpg';
                    brandImageController.text = localImagePath;
                    brandNameController.text = brand.name;
                    brandIdController.text = brand.id;
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void showCategoryPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: categoryController.allCategories.map((category) {
                return ListTile(
                  leading: Image.network(category.image, width: 50, height: 50),
                  title: Text(category.name),
                  onTap: () {
                    categoryIdController.text = category.id;
                    categoryNameController.text = category.name;

                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Hàm chọn và tải lên nhiều hình ảnh
  Future<void> pickAndUploadImagesForProduct() async {
    try {
      // Chọn nhiều hình ảnh từ thư viện
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var pickedFile in pickedFiles) {
          // Tạo File từ đường dẫn đã chọn
          final file = File(pickedFile.path);

          // Lấy phần mở rộng của tệp
          final fileExtension = pickedFile.path.split('.').last;

          // Tạo tham chiếu đến Firebase Storage
          final ref = storage.ref().child('Products/Images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension');

          // Tải tệp lên Firebase Storage
          final uploadTask = ref.putFile(file);
          final snapshot = await uploadTask.whenComplete(() => {});

          // Lấy URL tải xuống từ Firebase Storage
          final downloadUrl = await snapshot.ref.getDownloadURL();

          // Tạo một TextEditingController mới với URL đã tải xuống
          final imageController = TextEditingController(text: downloadUrl);

          // Thêm TextEditingController vào danh sách `images`
          images.add(imageController);

          // Làm mới danh sách để cập nhật giao diện
          images.refresh();
        }
      }
    } catch (e) {
      // Xử lý các lỗi xảy ra trong quá trình tải lên
      print('Error uploading images: $e');
      Get.snackbar('Error', 'Failed to upload images. Please try again.');
    }
  }
  Future<void> pickAndUploadImageForThumbnail() async {
    try {
      // Chọn hình ảnh từ thư viện
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Tạo File từ đường dẫn đã chọn
        final file = File(pickedFile.path);

        // Lấy phần mở rộng của tệp
        final fileExtension = pickedFile.path.split('.').last;

        // Tạo tham chiếu đến Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('Products/Thumbnail/Images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension');

        // Tải tệp lên Firebase Storage
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => {});

        // Lấy URL tải xuống của tệp đã tải lên
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Cập nhật URL hình ảnh và TextEditingController
        imageUrl.value = downloadUrl;
        thumbnailController.text = downloadUrl;
        // Làm mới danh sách để cập nhật giao diện
        imageUrl.refresh();
        print('Image uploaded successfully: $downloadUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image. Please try again.');
    }
  }
  // Hàm chọn và tải lên ảnh cho biến thể
  Future<void> pickAndUploadImageForVariation(int index) async {
    try {
      // Chọn ảnh từ thư viện
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Tạo File từ đường dẫn đã chọn
        final file = File(pickedFile.path);

        // Lấy phần mở rộng của tệp
        final fileExtension = pickedFile.path.split('.').last;

        // Tạo tham chiếu đến Firebase Storage
        final ref = storage.ref().child('Products/Variations/Images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension');

        // Tải lên tệp
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => {});

        // Lấy đường dẫn URL của tệp đã tải lên
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Cập nhật URL hình ảnh cho biến thể
        if (index < variations.length) {
          variations[index].image = downloadUrl;
        } else {
          variations[index].image = downloadUrl;
        }

        // Cập nhật giao diện
        variations.refresh();
      }
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image. Please try again.');
    }
  }
  void setProductData(ProductModel product) {
    titleController.text = product.title;
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    salePriceController.text = product.salePrice.toString();
    descriptionController.text = product.description!;
    thumbnailController.text = product.thumbnail;
    categoryIdController.text = product.categoryId!;
    selectedProductType.value = product.productType == 'ProductType.single' ? ProductType.single : ProductType.variable;
    isFeatured.value = product.isFeatured;

    imageUrl.value = product.thumbnail;
    images.clear();
    product.images?.forEach((image) {
      images.add(TextEditingController(text: image));
    });

    attributes.clear();
    product.productAttributes?.forEach((attribute) {
      attributes.add(ProductAttributeModel(name: attribute.name, values: attribute.values?.toList()));
    });

    variations.clear();
    product.productVariations?.forEach((variation) {
      variations.add(ProductVariationModel(
        id: variation.id,
        stock: variation.stock,
        price: variation.price,
        salePrice: variation.salePrice,
        sku: variation.sku,
        image: variation.image,
        description: variation.description,
        attributeValues: variation.attributeValues,
      ));
    });

    brandIdController.text = product.brand!.id;
    brandNameController.text = product.brand!.name;
    brandImageController.text = product.brand!.image;
    brandIsFeatured.value = product.brand!.isFeatured!;
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await repository.deleteProduct(productId);
      filteredProducts.removeWhere((product) => product.id == productId);
      Get.back(result: true);
      Get.snackbar('Success', 'Product deleted successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }


  /// search products by name
  void assignProducts2(List<ProductModel> products) {
    allProducts.assignAll(products);
    filteredProducts.assignAll(products);
  }

  void filterProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  Future<void> updateProductData(ProductModel product) async {
   final productId = selectedProductId.value = product.id;
   assignVariationIds();
    if (productId.isEmpty) {
      Get.snackbar('Error', 'No product selected for update');
      return;
    }

    final data =  {
      'Title': titleController.text,
      'Price': double.tryParse(priceController.text) ?? 0.0,
      'Stock': int.tryParse(stockController.text) ?? 0,
      'SalePrice': double.tryParse(salePriceController.text) ?? 0.0,
      'Description': descriptionController.text,
      'Thumbnail': thumbnailController.text,
      'CategoryId': categoryIdController.text,
      'ProductType': selectedProductType.value.toString(),
      'IsFeatured': isFeatured.value,
      'Images': images.map((controller) => controller.text).toList(),
      'Brand': {
        'Id': brandIdController.text,
        'Name': brandNameController.text,
        'Image': brandImageController.text,
        'IsFeatured': brandIsFeatured.value,
      },
      'ProductAttributes': attributes.map((attribute) => {
        'Name': attribute.name,
        'Values': attribute.values?.toList(), // Convert RxList to List
      }).toList(),
      'ProductVariations': variations.map((variation) => {
        'Id': variation.id,
        'Stock': variation.stock,
        'Price': variation.price,
        'SalePrice': variation.salePrice,
        'SKU': variation.sku,
        'Image': variation.image,
        'Description': variation.description,
        'AttributeValues': variation.attributeValues,
      }).toList(),
    };

    try {
      print('Updating product with ID: $productId'); // Log productId
      print('Data: $data'); // Log data
      await repository.updateProduct(productId, data);
      Get.back(result: true); // Trả kết quả thành công

      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      print('Error updating product: $e'); // Log chi tiết lỗi
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  void addVariation() {
    variations.add(ProductVariationModel(
      id: '',
      stock: 0,
      price: 0.0,
      salePrice: 0.0,
      sku: '',
      image: '',
      description: '',
      attributeValues: {
        'Color': color.text,
        'Size': size.text
      },
    ));
  }

  void resetProductData() {
    titleController.clear();
    priceController.clear();
    salePriceController.clear();
    stockController.clear();
    descriptionController.clear();
    thumbnailController.clear();
    categoryIdController.clear();
    categoryNameController.clear();
    brandImageController.clear();
    brandNameController.clear();
    selectedProductType.value = ProductType.single;
    isFeatured.value = false;
    images.clear();
    imageUrl.value = '';

    attributes.clear();
    variations.clear();
  }

  void removeVariation(int index) {
    variations.removeAt(index);
  }

  Future<String> getNextProductId() async {
    final allProducts = await repository.getAllFeaturedProducts();
    int maxId = 0;

    for (var product in allProducts) {
      int currentId = int.tryParse(product.id) ?? 0;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    int nextId = maxId + 1;
    return nextId.toString().padLeft(3, '0');
  }

  void assignVariationIds() {
    for (int i = 0; i < variations.length; i++) {
      variations[i].id = (i + 1).toString(); // Gán ID từ 1 trở đi
    }
  }
  ///id 001


  Future<List<ProductModel>> getProductsByIds(List<String> productIds) async {
    final productQuery = await FirebaseFirestore.instance
        .collection('Products')
        .where(FieldPath.documentId, whereIn: productIds)
        .get();
    return productQuery.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
  }

  Future<String> generateProductId() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Products').get();
    final productCount = querySnapshot.size;
    return (productCount + 1).toString().padLeft(3, '0');
  }


  Future<void> saveProduct() async {
    assignVariationIds();
    final productId = await generateProductId();

    final brand = BrandModel(
      id: brandIdController.text,
      name: brandNameController.text,
      image: brandImageController.text,
      productsCount: 1,
      isFeatured: brandIsFeatured.value,
    );

    final cleanedAttributes = removeEmptyAttributes(attributes);
    final cleanedVariations = removeEmptyVariations(variations);

    ///get model
// Tạo đối tượng ProductModel
    final product = ProductModel(
      id: productId,
      title: titleController.text,
      stock: int.tryParse(stockController.text) ?? 0, // Sử dụng ?? để gán giá trị mặc định nếu không thể chuyển đổi hoặc có giá trị null
      price: double.tryParse(priceController.text) ?? 0.0,
      isFeatured: isFeatured.value,
      thumbnail: thumbnailController.text,
      productType: selectedProductType.value.toString(),
      description: descriptionController.text,
      salePrice: double.tryParse(salePriceController.text) ?? 0.0,
      categoryId: categoryIdController.text,
      images: images.map((controller) => controller.text).toList(),
      brand: brand,
      productAttributes: attributes,
      productVariations: variations,
    );

    try {
      await repository.addProduct(product);
      Get.back(result: true); // Trả kết quả thành công
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

// Loại bỏ các attribute có giá trị rỗng hoặc null
  List<ProductAttributeModel> removeEmptyAttributes(List<ProductAttributeModel> attributes) {
    return attributes.where((attribute) => attribute.values!.isNotEmpty).toList();
  }

// Loại bỏ các variation có giá trị rỗng hoặc null
  List<ProductVariationModel> removeEmptyVariations(List<ProductVariationModel> variations) {
    return variations.where((variation) => variation.attributeValues.isNotEmpty).toList();
  }


  Future<List<ProductModel>> fetchProductByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await repository.fetchProductByQuery(query);

      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  void assignProducts(List<ProductModel> products) {
    this.products.assignAll(products);
    sortProducts('Name');
  }



}
