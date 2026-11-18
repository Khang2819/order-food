import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String address;
  final int cartCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onAddressTap;
  final VoidCallback? onCartTap;

  const HomeHeader({
    super.key,
    this.address = '123 Nguyễn Huệ, Q.1',
    this.cartCount = 3,
    this.onNotificationTap,
    this.onProfileTap,
    this.onAddressTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Dòng trên: Logo + Tên Brand + Nút Chuông + Avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_rounded,
                      size: 20,
                      color: AppColors.primaryRust,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'KhamPha',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textMain,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onNotificationTap,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.textMain,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryRust,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2. Dòng dưới: Địa chỉ giao hàng + Giỏ hàng (Kèm Badge số lượng)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Địa chỉ giao tới
            Expanded(
              child: GestureDetector(
                onTap: onAddressTap,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: AppColors.primaryRust,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Giao tới',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSub,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textMain,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: AppColors.textMain,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Nút Giỏ hàng có Badge
            GestureDetector(
              onTap: onCartTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 20,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRust,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
