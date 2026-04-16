class ComparisonEngine {
  static String getWeightComparison(double kg) {
    if (kg < 0.1) return 'About the weight of a AAA battery';
    if (kg < 0.5) return 'About the weight of a basketball';
    if (kg < 1.0) return 'About the weight of a loaf of bread';
    if (kg < 3.0) return 'About the weight of a standard laptop';
    if (kg < 5.0) return 'About the weight of an average adult cat';
    if (kg < 15.0) return 'About the weight of a medium-sized dog';
    if (kg < 50.0) return 'About the weight of a checked airline bag';
    if (kg < 100.0) return 'About the weight of an average refrigerator';
    return 'About the weight of a giant panda';
  }

  static String getLengthComparison(double meters) {
    if (meters < 0.01) return 'About the thickness of a pencil';
    if (meters < 0.1) return 'About the length of a credit card';
    if (meters < 0.3) return 'About the size of a standard ruler';
    if (meters < 1.0) return 'About the height of a guitar';
    if (meters < 2.0) return 'About the height of a standard door';
    if (meters < 5.0) return 'About the length of a family sedan';
    if (meters < 20.0) return 'About the length of a bowling lane';
    return 'About the length of a blue whale';
  }
}
