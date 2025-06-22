import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/models/card_model.dart' as model;
import 'package:work_on_time_game/providers/card_provider.dart';

class CardSelectionDialog extends ConsumerStatefulWidget {
  const CardSelectionDialog({super.key});

  @override
  ConsumerState<CardSelectionDialog> createState() =>
      _CardSelectionDialogState();
}

class _CardSelectionDialogState extends ConsumerState<CardSelectionDialog> {
  model.Card? _selectedCard;
  final images = Images();

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          height: screenHeight * 0.7,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF6F5F5E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF4A3F3F), width: 2),
          ),
          child: Column(
            children: [
              Text(
                '使用卡片前進',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '尚可使用${cards.length}次',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    mainAxisExtent: 110,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    final isSelected = _selectedCard?.id == card.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCard = card;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9C6B1),
                          borderRadius: BorderRadius.circular(15),
                          border: isSelected
                              ? Border.all(color: Colors.lightGreen, width: 3)
                              : null,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                images.getFullPath(card.iconPath),
                                width: 50,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.brown[800]),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    card.description,
                                    style: TextStyle(
                                      color: Colors.brown[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9C6B1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        '關閉',
                        style:
                            TextStyle(fontSize: 18, color: Colors.brown[800]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedCard == null
                          ? null
                          : () {
                              if (_selectedCard != null) {
                                ref
                                    .read(cardProvider.notifier)
                                    .removeCard(_selectedCard!.id);
                                Navigator.of(context).pop(_selectedCard);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '使用',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
