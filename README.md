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
  - Selection and hover animations

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
  - Position-based selection system
  - Visual feedback on hover and selection
  - Multiple card selection support
- [x] Hand evaluation (poker hands)
  - All poker hand combinations
  - Detailed hand descriptions
  - Color-coded results
- [x] Scoring system
  - Base scores for each hand type
  - Rank-based bonuses
  - Score accumulation across rounds
- [x] Basic game loop
  - Round-based progression
  - Target score system
  - Resource management (hands/redraws)
- [x] Round management
  - Victory celebration overlay
  - Round completion feedback
  - Progressive difficulty
- [x] Basic animations for card draws/moves
  - Hover effects
  - Selection animations
  - Score display animations
  - Victory celebration effects

### Phase 3: Balatro-Specific Features
- [ ] Joker system implementation
- [ ] Special card effects
- [ ] Multipliers
- [ ] Stake system
- [ ] Hand enhancement mechanics

### Phase 4: UI/UX Improvements
- [ ] Better card visuals
- [x] Hand evaluation display
  - Color-coded hand types
  - Detailed hand descriptions
  - Dynamic score updates
- [x] Score display
  - Total score tracking
  - Round score display
  - Target score indication
- [x] Animation polish (card hover/selection)
  - Smooth hover transitions
  - Selection highlighting
  - Position-based animations
- [x] Responsive layout
  - Screen size adaptation
  - Centered game elements
  - Proper spacing and margins
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
- Selection and hover effects with animations
- Position-based card replacement system
```

### Game Loop Implementation
```gdscript
# Core gameplay features:
- 4 hands per round
- 4 redraws available
- Score target system
- Selective card replacement
- Round progression
- Game over conditions
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
4. Submit hands to score points
5. Manage your hands and redraws wisely
6. Try to reach the target score to advance rounds

## Development Notes

### Current Features ✓
- ✓ Basic card display and interaction
- ✓ Hand evaluation and scoring
- ✓ Visual feedback for card selection
- ✓ Score display with hand details
- ✓ Round management system
- ✓ Selective card replacement
- ✓ Game over conditions
- ✓ New game functionality

### Next Steps Priority
1. Implement Joker system
2. Add sound effects
3. Add visual polish

## Contributing

Feel free to contribute to any of the planned phases. Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

[Add your chosen license here] 