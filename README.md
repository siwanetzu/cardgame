# Card Game (Balatro-inspired)

A card game built with Godot 4.3, inspired by the roguelike deckbuilder Balatro.

## Current Implementation (Phase 1: Basic Card System) ✓

### Components

#### Card Manager (`card_manager.gd`, `card_manager.tscn`) ✓
- Manages the overall card system
- Handles drawing and displaying cards
- Uses HBoxContainer for horizontal card layout
- Draws initial hand of 5 cards

#### Card System (`card.tscn`, `control.gd`) ✓
- Individual card representation
- Properties:
  - Rank (A, 2-10, J, Q, K)
  - Suit (♠, ♥, ♦, ♣)
- Visual features:
  - Proper suit coloring (red/black)
  - White background for visibility
  - Rounded corners for style
  - Dynamic text sizing

#### Deck System (`deck.gd`, `Deck.tscn`) ✓
- Standard 52-card deck implementation
- Features:
  - Deck generation
  - Shuffling
  - Card drawing
  - Empty deck handling

## Planned Features

### Phase 2: Core Game Mechanics
- [x] Card selection/highlighting
- [x] Hand evaluation (poker hands)
- [x] Scoring system
- [ ] Basic game loop
- [ ] Round management
- [ ] Basic animations for card draws/moves

### Phase 3: Balatro-Specific Features
- [ ] Joker system implementation
- [ ] Special card effects
- [ ] Multipliers
- [ ] Stake system
- [ ] Hand enhancement mechanics

### Phase 4: UI/UX Improvements
- [ ] Better card visuals
- [x] Hand evaluation display
- [x] Score display
- [ ] Animation polish
- [ ] Sound effects
- [ ] Background music

### Phase 5: Advanced Features
- [ ] Save/Load system
- [ ] Statistics tracking
- [ ] Achievements
- [ ] Different game modes
- [ ] Difficulty levels
- [ ] Custom rule sets

### Phase 6: Polish & Optimization
- [ ] Performance optimization
- [ ] Memory management
- [ ] Mobile support
- [ ] Screen size adaptation
- [ ] Settings menu
- [ ] Control customization

## Technical Details

### Card Implementation
```gdscript
# Each card has:
- Custom minimum size (200x300)
- Dynamic rank and suit display
- Color-coded suits (♥♦ in red, ♠♣ in black)
- White background with rounded corners for visibility
- Selection and hover effects
```

### Hand Evaluation System
```gdscript
# Implemented features:
- All poker hand rankings
- Proper scoring system
- Rank-based bonuses
- Visual feedback for different hands
```

### Scoring System
```gdscript
# Base scores:
- Royal Flush: 2000 + bonuses
- Straight Flush: 1200 + bonuses
- Four of a Kind: 800 + bonuses
- Full House: 500 + bonuses
- Flush: 400 + bonuses
- Straight: 300 + bonuses
- Three of a Kind: 200 + bonuses
- Two Pair: 100 + bonuses
- Pair: 50 + bonuses
- High Card: 10 + bonuses
```

## Getting Started

1. Open the project in Godot 4.3
2. Run the main scene (`card_manager.tscn`)
3. Click cards to select/deselect them
4. Press spacebar to draw a new hand

## Development Notes

### Current Features
- ✓ Basic card display and interaction
- ✓ Hand evaluation and scoring
- ✓ Visual feedback for card selection
- ✓ Score display with hand details

### Next Steps Priority
1. Implement basic game loop
2. Add round management
3. Add card draw/play animations

## Contributing

Feel free to contribute to any of the planned phases. Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

[Add your chosen license here] 