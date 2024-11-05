import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselItem<T> {
  final T data;
  final Widget Function(T data, bool isSelected) builder;

  CarouselItem({
    required this.data,
    required this.builder,
  });
}

class SelectionCarousel<T> extends StatefulWidget {
  final List<CarouselItem<T>> items;
  final String title;
  final Function(T selectedItem)? onSelect;
  final double? aspectRatio;
  final double? viewportFraction;
  final double? enlargeFactor;
  final double? itemHeight;
  final double? itemWidth;
  final int initialIndex;

  SelectionCarousel({
    super.key,
    required this.items,
    required this.title,
    this.onSelect,
    this.aspectRatio = 0.8,
    this.viewportFraction = 0.7,
    this.enlargeFactor = 0.2,
    this.itemHeight,
    this.itemWidth,
    required this.initialIndex,
  });

  @override
  State<SelectionCarousel<T>> createState() => _SelectionCarouselState<T>();
}

class _SelectionCarouselState<T> extends State<SelectionCarousel<T>>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward(); // Start with animation forward since we always have selection

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleItemSelection(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
        if (widget.onSelect != null) {
          widget.onSelect!(widget.items[_selectedIndex].data);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h1 = MediaQuery.of(context).size.height;
    final w1 = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: CarouselSlider.builder(
              itemCount: widget.items.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                bool isSelected = itemIndex == _selectedIndex;
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: () => _handleItemSelection(itemIndex),
                      child: Container(
                        height: widget.itemHeight ?? h1 * 0.5,
                        width: widget.itemWidth ?? w1 * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.transparent,
                            width: isSelected ? 3 : 0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: widget.items[itemIndex].builder(
                            widget.items[itemIndex].data,
                            isSelected,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              options: CarouselOptions(
                initialPage: widget.initialIndex,
                autoPlay: false,
                animateToClosest: true,
                enlargeFactor: widget.enlargeFactor!,
                aspectRatio: widget.aspectRatio!,
                viewportFraction: widget.viewportFraction!,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  _handleItemSelection(index);
                },
                scrollPhysics: const BouncingScrollPhysics(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  if (widget.onSelect != null) {
                    widget.onSelect!(widget.items[_selectedIndex].data);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: const Text(
                    "Select",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
