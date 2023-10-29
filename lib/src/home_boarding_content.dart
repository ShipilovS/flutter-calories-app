class OnboardingContents {
  final String title;
  final String image;

  OnboardingContents({
    required this.title,
    required this.image,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Считай калории",
    image: "assets/images/fruits.jpg",
  ),
  OnboardingContents(
    title: "Следи за калориями",
    image: "assets/images/fruits.jpg",
  ),
  OnboardingContents(
    title: "Улучши свое питание",
    image: "assets/images/fruits.jpg",
  ),
];