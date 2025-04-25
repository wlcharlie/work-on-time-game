import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/components/item/item_dialog.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/items.dart';
import 'package:work_on_time_game/models/item.dart';
import 'package:work_on_time_game/providers/inventory.dart';
import 'package:work_on_time_game/wot_game.dart';

class Inventory extends ConsumerStatefulWidget {
  final WOTGame game;
  const Inventory({super.key, required this.game});

  @override
  ConsumerState<Inventory> createState() => _InventoryState();
}

class _InventoryState extends ConsumerState<Inventory> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> onItemTap(String itemName) async {
    final item = getItem(itemName);

    final inventoryNotifier = ref.read(inventoryNotifierProvider.notifier);

    widget.game.overlays.remove('inventory');
    final result = await widget.game.router.pushAndWait(ItemDialog(
      imagePath: item!.imagePathLg!,
      dialogTitle: item.title!,
      dialogDescription: item.description,
      noAnimation: true,
      withBackdrop: true,
      revertAction: true,
    ));

    widget.game.overlays.add('inventory');

    if (result) {
      inventoryNotifier.removeItem(itemName);
    }
  }

  void onClose() {
    widget.game.overlays.remove('inventory');
  }

  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(inventoryNotifierProvider);

    return Container(
      // color: Colors.white.withValues(alpha: 0.80),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: 349,
              height: 502,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withValues(alpha: 0.95),
                border: Border.all(
                  color: Color(0xFF887768),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  _buildInventoryHeader(),
                  const SizedBox(height: 24),
                  _buildInventorySlots(inventory.items, inventory.capacity),
                  const SizedBox(height: 41),
                  _buildInventoryCloseButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryHeader() {
    return Center(
      child: Container(
        width: 185,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF6A4D3A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            '物品',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'TaiwanPearl',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInventorySlots(List<String> inventoryItems, int capacity) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 10,
        children: List.generate(
          9, // Always generate 9 slots total for the grid
          (index) {
            // If the index is within capacity, show active slot
            if (index < capacity) {
              return InventorySlot(
                itemName: index < inventoryItems.length
                    ? inventoryItems[index]
                    : null,
                onItemTap: onItemTap,
              );
            } else {
              // Show inactive slot if index is beyond capacity
              return InventorySlot(active: false, onItemTap: onItemTap);
            }
          },
        ),
      ),
    );
  }

  Widget _buildInventoryCloseButton() {
    return Center(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          width: 120,
          height: 36,
          decoration: BoxDecoration(
            color: Color(0xFFFFDEC1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xFF887768),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '關閉',
              style: TextStyle(
                color: Color(0xFF887768),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'TaiwanPearl',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InventorySlot extends StatelessWidget {
  final bool active;
  final String? itemName;
  final Function(String) onItemTap;
  late final Item? item;

  late final Color borderColor;
  late final Color backgroundColor;

  InventorySlot({
    super.key,
    this.active = true,
    this.itemName,
    required this.onItemTap,
  }) {
    borderColor = active ? Color(0xFF887768) : Color(0xFFC4BBB4);
    backgroundColor =
        active ? Color(0xFFF9F2EC) : Color(0xFFFFFFFF).withValues(alpha: 0.8);

    item = getItem(itemName);
  }

  void onTap() {
    onItemTap(itemName!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 3),
        ),
        child: Stack(
          children: [
            active
                ? (item != null && item!.imagePathLg != null
                    ? Center(
                        child: Image.asset(
                        images.getFullPath(item!.imagePathLg!),
                        width: 82,
                        height: 82,
                      ))
                    : SizedBox.shrink())
                : ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomPaint(
                        painter: InventoryDiagonalLine(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class InventoryDiagonalLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(size.width, 0);
    final p2 = Offset(0, size.height);
    final paint = Paint()
      ..color = Color(0xFFC4BBB4)
      ..strokeWidth = 2;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
