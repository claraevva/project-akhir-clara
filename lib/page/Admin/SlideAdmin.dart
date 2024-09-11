import 'package:flutter/material.dart';

class SlideAdmin extends StatelessWidget {
  final Function(int) onChange;
  final int currentSlide;
  const SlideAdmin({
    super.key,
    required this.onChange,
    required this.currentSlide,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PageView.builder(
              onPageChanged: onChange,
              itemCount: 2,
              itemBuilder: (context, index) {
                // Menambahkan kondisi untuk memilih gambar berdasarkan indeks slide
                String? imagePath;
                if (index == 0) {
                  imagePath = "assets/images/admin.png";
                } else if (index == 1) {
                  imagePath = "assets/images/admin2.png";
                }
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(imagePath!),
                    ),
                  ),
                );
              }),
        ),
        Positioned.fill(
          bottom: 10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentSlide == index ? 15 : 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: currentSlide == index
                        ? Colors.black
                        : Colors.transparent,
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
