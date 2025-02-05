# Card Game (Balatro-inspired)

A card game built with Godot 4.3, inspired by the roguelike deckbuilder Balatro.

## Current Implementation (Phase 1: Basic Card System)

### Components

#### Card Manager (`card_manager.gd`, `card_manager.tscn`)
- Manages the overall card system
- Handles drawing and displaying cards
- Uses HBoxContainer for horizontal card layout
- Draws initial hand of 5 cards

#### Card System (`card.tscn`, `control.gd`)
- Individual card representation
- Properties:
  - Rank (A, 2-10, J, Q, K)
  - Suit (♠, ♥, ♦, ♣)
- Visual features:
  - Proper suit coloring (red/black)
  - White background for visibility
  - Rounded corners for style
  - Dynamic text sizing

#### Deck System (`deck.gd`, `Deck.tscn`)
- Standard 52-card deck implementation
- Features:
  - Deck generation
  - Shuffling
  - Card drawing
  - Empty deck handling

## Planned Features

### Phase 2: Core Game Mechanics
- [ ] Card selection/highlighting
- [ ] Hand evaluation (poker hands)
- [ ] Scoring system
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
- [ ] Hand evaluation display
- [ ] Score multiplier display
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
```

### Deck Management
```gdscript
# Standard deck features:
- 52 cards (A-K in four suits)
- Automatic shuffling
- Draw system
- Empty deck detection
```

## Getting Started

1. Open the project in Godot 4.3
2. Run the main scene (`card_manager.tscn`)
3. The game will automatically deal 5 cards

## Development Notes

### Current Limitations
- Basic card display only
- No interaction system yet
- Static hand size
- No game logic implemented

### Next Steps
1. Implement card selection system
2. Add hand evaluation logic
3. Create basic scoring system
4. Implement round management

## Contributing

Feel free to contribute to any of the planned phases. Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

[Add your chosen license here] 