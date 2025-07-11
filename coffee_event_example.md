# Coffee Event Example

This document demonstrates the coffee morning event with complex choice visibility, availability, and timing mechanics.

## Event Flow Overview

```
coffee_shop
├── buy_expensive (visible if mind ≥ 10, disabled if saving < 20)
│   └── expensive_coffee_success
│       ├── chat_boss (disabled if mind < 20)
│       ├── avoid_boss
│       └── observe_boss (delay: 1.5s)
│
├── buy_regular (always visible, disabled if saving < 10)
│   └── regular_coffee
│       ├── invite_colleague
│       └── sit_alone
│
├── wait_for_discount (visible if has phone, delay: 3s)
│   ├── discount_appears (60% chance)
│   │   ├── buy_discounted_expensive (disabled if saving < 16)
│   │   └── buy_discounted_regular (disabled if saving < 8)
│   └── no_discount (40% chance)
│       ├── disappointed_buy (disabled if saving < 10)
│       └── give_up_disappointed
│
├── ask_friend_money (visible if has phone AND saving ≤ 19, delay: 2s)
│   ├── borrowed_money (if mind ≥ 15)
│   │   ├── buy_with_borrowed_money
│   │   └── save_borrowed_money
│   └── direct result (if mind < 15)
│
└── leave (always visible and available)
```

## Choice Mechanics Demonstrated

### 1. Visibility Conditions
- **buy_expensive**: Only appears if player's mind ≥ 10
- **wait_for_discount**: Only appears if player has phone
- **ask_friend_money**: Only appears if player has phone AND saving ≤ 19

### 2. Availability (Disabled States)
- **buy_expensive**: Shows as "買高級咖啡 (錢不夠)" if saving < 20
- **buy_regular**: Shows as "買普通咖啡 (錢不夠)" if saving < 10
- **chat_boss**: Shows as "主動打招呼 (心情不夠好)" if mind < 20

### 3. Delayed Choices
- **wait_for_discount**: Appears 3 seconds after question shows
- **ask_friend_money**: Appears 2 seconds after question shows
- **observe_boss**: Appears 1.5 seconds after reaching expensive_coffee_success

### 4. Random Outcomes
- **wait_for_discount**: 60% chance leads to discount_appears, 40% to no_discount

### 5. Multiple Outcomes per Choice
- **ask_friend_money**: Success if mind ≥ 15, failure otherwise

## Test Scenarios

### Scenario 1: Rich Player (saving ≥ 20, mind ≥ 10)
- Sees: buy_expensive, buy_regular, leave
- Can click: All visible choices
- Expected path: buy_expensive → expensive_coffee_success → multiple options

### Scenario 2: Poor Player with Phone (saving < 10, has phone)
- Sees: buy_regular (disabled), wait_for_discount (delayed), ask_friend_money (delayed), leave
- Can click: Only delayed choices and leave
- Expected path: Either wait for discount or ask friend for money

### Scenario 3: Player without Phone (no phone)
- Sees: buy_expensive (if mind ≥ 10), buy_regular, leave
- Hidden: wait_for_discount, ask_friend_money
- Expected path: Limited to direct purchase or leave

### Scenario 4: Medium Wealth Player (saving 10-19)
- Sees: Most choices depending on other conditions
- Can explore: Regular coffee path or wait for discount
- Expected path: Multiple viable options

## Integration Notes

This event demonstrates all the advanced choice mechanics:
- **Dynamic visibility** based on multiple conditions
- **Conditional availability** with custom disabled text
- **Timed appearance** for certain choices
- **Random chance** outcomes
- **Cascading effects** from previous choices
- **Multiple conditional outcomes** per choice

The event can be used to test the complete event system implementation and validate that all choice mechanics work correctly.