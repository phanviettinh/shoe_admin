import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/shop/models/banner_model.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/features/shop/models/category_model.dart';
import 'package:shoe_admin/features/shop/models/product_attribute_model.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/features/shop/models/product_variation_model.dart';
import 'package:shoe_admin/routes/routes.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';

class TDummyData {
  static final List<BannerModel> banners = [
    BannerModel(
        imageUrl: TImages.banner1, targetScreen: TRoutes.order, active: false),
    BannerModel(
        imageUrl: TImages.banner2, targetScreen: TRoutes.cart, active: true),
    BannerModel(
        imageUrl: TImages.banner3,
        targetScreen: TRoutes.favourites,
        active: true),
    BannerModel(
        imageUrl: TImages.banner1, targetScreen: TRoutes.search, active: true),
    BannerModel(
        imageUrl: TImages.banner2,
        targetScreen: TRoutes.settings,
        active: true),
    BannerModel(
        imageUrl: TImages.banner3,
        targetScreen: TRoutes.userAddress,
        active: true),
    BannerModel(
        imageUrl: TImages.banner1,
        targetScreen: TRoutes.checkout,
        active: false),
  ];

  static final List<CategoryModel> categories = [
    CategoryModel(
        id: '1', name: 'Sports', image: TImages.climbing, isFeatured: true),
    CategoryModel(
        id: '5', name: 'Furniture', image: TImages.climbing, isFeatured: true),
    CategoryModel(
        id: '3',
        name: 'Electronics',
        image: TImages.climbing,
        isFeatured: true),
    CategoryModel(
        id: '4', name: 'Cloth', image: TImages.climbing, isFeatured: true),
    CategoryModel(
        id: '6', name: 'Shoe', image: TImages.climbing, isFeatured: true),
    CategoryModel(
        id: '7', name: 'Cosmetics', image: TImages.climbing, isFeatured: true),
    CategoryModel(
        id: '14', name: 'JeweleryI', image: TImages.climbing, isFeatured: true),
  ];
  static final List<BrandModel> brands = [
    BrandModel(
        id: '1', name: 'Nike', image: TImages.climbing, isFeatured: true),
  ];

  static final List<ProductModel> products = [
    ///product1
    ProductModel(
        id: '001',
        title: 'White Adidas sports shoe',
        stock: 15,
        price: 135,
        isFeatured: true,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.variable',
        description: 'White Adidas sports shoe',
        brand: BrandModel(
            id: '1',
            name: 'Adidas',
            image: TImages.adidasIcon,
            productsCount: 265,
            isFeatured: true
        ),
        images: [
          TImages.adidasRm1,
          TImages.adidasRm2,
          TImages.adidasRm3,
          TImages.adidasRm3
        ],
        salePrice: 30,
        sku: 'ABR4568',
        categoryId: '1',
        productAttributes: [
          ProductAttributeModel(
              name: 'Color', values: ['Green', 'Black', 'Red']),
          ProductAttributeModel(
              name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
        ],
        productVariations: [
          ProductVariationModel(
              id: '1',
              stock: 34,
                price: 134,
              salePrice: 126.6,
              sku: '',
              image: TImages.adidasRm1,
              description: 'This is a Product description for Green Nike sports shoe.',
              attributeValues: {'Color': 'Green', 'Size': 'EU 34'}),
          ProductVariationModel(
              id: '2',
              stock: 15,
              price: 132,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '3',
              stock: 0,
              price: 234,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 34'}
          ),
          ProductVariationModel(
              id: '4',
              stock: 223,
              price: 232,
              image: TImages.adidasRm1,
              attributeValues: {'Color': 'Green', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '5',
              stock: 0,
              price: 334,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '6',
              stock: 0,
              price: 234,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}
          ),

        ]
    ),
    ///product2
    ProductModel(
        id: '002',
        title: 'Puma Future Rider Neon Play Fizzy Yellow Shoes',
        stock: 15,
        price: 35,
        isFeatured: true,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.single',
        description:
        'Puma Future Rider Neon Play Fizzy Yellow shoes are made from selected high-quality materials, strong stitching, high durability, pampering your every step. The sturdy rubber sole has good friction, is anti-slip, and can move on many terrains. Puma shoes easily coordinate with everyday outfits, suitable for going to school, going out, walking around, exercising... Don\'t miss the opportunity to own them through Sneaker Daily Shop ^^',
        brand: BrandModel(
            id: '2',
            name: 'Puma',
            image: TImages.adidasIcon,
        ),
        images: [
          TImages.adidasRm1,
          TImages.adidasRm2,
          TImages.adidasRm3,
        ],
        salePrice: 30,
        sku: 'ABR4568',
        categoryId: '5',
        productAttributes: [
          ProductAttributeModel(
              name: 'Color', values: ['Green', 'Black', 'Red']),
          ProductAttributeModel(
              name: 'Size', values: ['EU 30', 'EU 32']),
        ],
    ),

    ///product3
    ProductModel(
        id: '003',
        title: 'New Balance 550 White Team Red Shoes',
        stock: 15,
        price: 380,
        isFeatured: false,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.variable',
        description:
        'New Balance is a fashion and sports shoe brand from America. For more than 100 years, New Balance has always understood the needs of athletes to invest and design suitable products. New Balance always focuses on every movement of the human body to be able to "Making Excellent Happen"!',
        brand: BrandModel(
            id: '3',
            name: 'New Balance',
            image: TImages.adidasIcon,
        ),
        images: [
          TImages.adidasRm1,
          TImages.adidasRm2,
          TImages.adidasRm3,
          TImages.adidasRm3
        ],
        salePrice: 30,
        sku: 'ABR4568',
        categoryId: '5',
        productAttributes: [
          ProductAttributeModel(
              name: 'Color', values: ['Green', 'Black', 'Red']),
          ProductAttributeModel(
              name: 'Size', values: ['EU 32', 'EU 34']),
        ],
        productVariations: [
          ProductVariationModel(
              id: '1',
              stock: 34,
              price: 134,
              salePrice: 110.2,
              // sku: '',
              image: TImages.adidasRm1,
              description: '',
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}),
          ProductVariationModel(
              id: '2',
              stock: 15,
              price: 132,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '3',
              stock: 0,
              price: 234,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 34'}
          ),
          ProductVariationModel(
              id: '4',
              stock: 222,
              price: 232,
              image: TImages.adidasRm1,
              attributeValues: {'Color': 'Green', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '5',
              stock: 0,
              price: 334,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '6',
              stock: 0,
              price: 234,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}
          ),
        ]

    ),

    ///product4
    ProductModel(
        id: '004',
        title: 'Converse Chuck 70 Hi Desert Patchwork',
        stock: 15,
        price: 135,
        isFeatured: false,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.variable',
        description:
        'Converse is a famous sports shoe brand founded in 1908, formerly an American shoe company specializing in producing shoes with rubber materials. Through many ups and downs, in 2003, Converse became a subsidiary of Nike, Inc. Besides sports shoes, Converse also designs other fashion products such as t-shirts, watches, bags,...',
        brand: BrandModel(
            id: '4',
            name: 'Converse',
            image: TImages.adidasIcon,
            // productsCount: 265,
            // isFeatured: true
        ),
        images: [
          TImages.adidasRm1,
          TImages.adidasRm2,
          TImages.adidasRm3,
          TImages.adidasRm3
        ],
        salePrice: 30,
        sku: 'ABR4568',
        categoryId: '5',
        productAttributes: [
          ProductAttributeModel(
              name: 'Color', values: ['Green', 'Black', 'Red']),
          ProductAttributeModel(
              name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
        ],
        productVariations: [
          ProductVariationModel(
              id: '1',
              stock: 34,
              price: 134,
              salePrice: 126.6,
              // sku: '',
              image: TImages.adidasRm1,
              description: 'Converse is a famous sports shoe brand founded in 1908, formerly an American shoe company specializing in producing shoes with rubber materials.',
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}),
          ProductVariationModel(
              id: '2',
              stock: 15,
              price: 132,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '3',
              stock: 0,
              price: 234,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 34'}
          ),
          ProductVariationModel(
              id: '4',
              stock: 222,
              price: 232,
              image: TImages.adidasRm1,
              attributeValues: {'Color': 'Green', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '5',
              stock: 0,
              price: 334,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '6',
              stock: 0,
              price: 234,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}
          ),
        ]
    ),

    ///product5
    ProductModel(
        id: '005',
        title: 'Vans Old Skool Black Flame Shoes',
        stock: 15,
        price: 35,
        isFeatured: false,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.variable',
        description: 'Vans Old Skool Black Flame is now available at Sneaker Daily Shop, don\'t miss your chance!',
        brand: BrandModel(
            id: '5',
            name: 'Vans',
            image: TImages.adidasIcon,
            productsCount: 265,
            isFeatured: true
        ),
        images: [
          TImages.adidasRm1,
          TImages.adidasRm2,
          TImages.adidasRm3,
          TImages.adidasRm3
        ],
        salePrice: 30,
        sku: 'ABR4568',
        categoryId: '5',
        productAttributes: [
          ProductAttributeModel(
              name: 'Color', values: ['Green', 'Black', 'Red']),
          ProductAttributeModel(
              name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
        ],
        productVariations: [
          ProductVariationModel(
              id: '1',
              stock: 16,
              price: 36,
              salePrice: 12.6,
              sku: '',
              image: TImages.adidasRm1,
              description: 'Vans Old Skool Black Flame is now available at Sneaker Daily Shop, don\'t miss your chance!',
              attributeValues: {'Color': 'Orange', 'Size': 'EU 34'}),
          ProductVariationModel(
              id: '2',
              stock: 15,
              price: 35,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '3',
              stock: 0,
              price: 234,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 34'}
          ),
          ProductVariationModel(
              id: '4',
              stock: 223,
              price: 232,
              image: TImages.adidasRm1,
              attributeValues: {'Color': 'Green', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '5',
              stock: 0,
              price: 334,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '6',
              stock: 0,
              price: 234,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}
          ),
        ]
    ),

    ///product6
    ProductModel(
        id: '006',
        title: 'Nike Dunk Low By You Panda – Custom',
        stock: 15,
        price: 245,
        isFeatured: false,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.variable',
        description:
        'These shoes have high quality leather combined with soft fabric, bringing comfort and durability to the user. This design has the main color white throughout the shoe body, with harmonious black details, creating a perfect balance between colors.',
        brand: BrandModel(
            id: '6',
            name: 'Nike',
            image: TImages.adidasIcon,
            // productsCount: 265,
            // isFeatured: true
        ),
        images: [
          TImages.adidasRm1,
          TImages.adidasRm2,
          TImages.adidasRm3,
          TImages.adidasRm3
        ],
        salePrice: 50,
        sku: 'ABR4568',
        categoryId: '6',
        productAttributes: [
          ProductAttributeModel(
              name: 'Color', values: ['Green', 'Black', 'Red']),
          ProductAttributeModel(
              name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
        ],
        productVariations: [
          ProductVariationModel(
              id: '1',
              stock: 34,
              price: 134,
              salePrice: 110.2,
              // sku: '',
              image: TImages.adidasRm1,
              description: '',
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}),
          ProductVariationModel(
              id: '2',
              stock: 15,
              price: 132,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '3',
              stock: 0,
              price: 234,
              image: TImages.adidasRm2,
              attributeValues: {'Color': 'Black', 'Size': 'EU 34'}
          ),
          ProductVariationModel(
              id: '4',
              stock: 222,
              price: 232,
              image: TImages.adidasRm1,
              attributeValues: {'Color': 'Green', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '5',
              stock: 0,
              price: 334,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 32'}
          ),
          ProductVariationModel(
              id: '6',
              stock: 0,
              price: 234,
              image: TImages.adidasRm3,
              attributeValues: {'Color': 'Red', 'Size': 'EU 34'}
          ),
        ]

    ),

    ///product7
    ProductModel(
        id: '007',
        title: 'Nike Dunk Low Disrupt 2 Pale Ivory',
        stock: 15,
        price: 220,
        isFeatured: false,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.variable',
        description: 'The design of the Nike Dunk Low Disrupt 2 Pale Ivory shoes is simple, elegant and sophisticated, suitable for many different fashion styles. The midsole is designed with advanced technology, helping to maintain durability and elasticity during use.',
        brand: BrandModel(
            id: '6',
            name: 'Nike',
            image: TImages.adidasIcon,
            // productsCount: 265,
            // isFeatured: true
        ),
        images: [
          TImages.adidasRm1,
          TImages.adidasRm2,
          TImages.adidasRm3,
          TImages.adidasRm3
        ],
        salePrice: 30,
        sku: 'ABR4568',
        categoryId: '3',

    ),

    ///product8
    ProductModel(
        id: '008',
        title: 'Adidas Samba OG White Black Gum Shoes',
        stock: 15,
        price: 225,
        isFeatured: false,
        thumbnail: TImages.adidasRm1,
        productType: 'ProductType.variable',
        description: 'The Adidas Samba OG ‘White Black Gum’ B75806 is a classic sneaker designed for futsal football. It features an upper made from suede and patent leather with white, black and gum brown accents.',
        brand: BrandModel(
            id: '1',
            name: 'Adidas',
            image: TImages.adidasIcon,
            // productsCount: 265,
            // isFeatured: true
        ),
        // images: [
        //   TImages.adidasRm1,
        //   TImages.adidasRm2,
        //   TImages.adidasRm3,
        //   TImages.adidasRm3
        // ],
        salePrice: 80,
        sku: 'ABR4568',
        categoryId: '2',
      productAttributes: [
        ProductAttributeModel(
            name: 'Color', values: ['Green', 'Black', 'Red']),
        ProductAttributeModel(
            name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
      ],

    ),

  ];


}
