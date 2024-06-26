class TPricingCalculator{
  static double calculateTotalPrice(double productPrice, String location){
    double taxRate = getTaxRateForLocation(location);
    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + taxRate + shippingCost;
    return totalPrice;
  }

///shipping cart
  static String calculateShippingCost(double productPrice, String location){
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(1);
  }

  ///calculate tax
  static String calculateTax(double productPrice, String location){
    double shippingCost = getTaxRateForLocation(location);
    return shippingCost.toStringAsFixed(1);
  }

  static double getTaxRateForLocation(String location){
    return 2.0;
  }

  static double getShippingCost(String location){
    return 5.0;
  }

}