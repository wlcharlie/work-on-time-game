# Event Creation Guide

This guide explains how to create events for the Work On Time Game. Events are JSON files that define interactive story moments where players make decisions affecting their character's status.

## Quick Start

1. Copy `assets/data/event_template.json` as your starting point
2. Modify the `id`, `name`, and content according to your event
3. Test your event in the game
4. Place the final file in `assets/data/`

## Event Structure

### Root Level

```json
{
  "id": "unique_event_identifier",
  "name": "Display Name for Event",
  "preconditions": [],
  "flow": []
}
```

- **id**: Unique identifier used by the game code (snake_case recommended)
- **name**: Human-readable name for the event
- **preconditions**: Array of conditions that must be met for this event to trigger
- **flow**: Array of event nodes that make up the event narrative

### Preconditions

Preconditions determine when an event can trigger:

```json
"preconditions": [
  {
    "type": "status_min",
    "property": "mind",
    "value": 20
  },
  {
    "type": "inventory_has", 
    "item": "umbrella"
  }
]
```

**Available condition types:**
- `status_min`: Character status must be at least the specified value
- `status_max`: Character status must be at most the specified value  
- `inventory_has`: Player must have the specified item

**Character status properties:**
- `mind`: Mental/emotional state (0-100)
- `saving`: Money/financial resources (0-100)
- `energy`: Physical stamina (0-100)

### Flow Nodes

Each node represents a moment in the event where the player sees text and makes choices:

```json
{
  "id": "node_identifier",
  "text": "Text shown to the player",
  "choices": []
}
```

### Choices

Choices are the options available to the player at each node:

```json
{
  "id": "choice_identifier",
  "text": "Text displayed for this choice",
  "visibility": { "conditions": [] },
  "availability": { "conditions": [] },
  "delay": 2,
  "outcomes": []
}
```

- **visibility**: Controls whether the choice appears (empty conditions = always visible)
- **availability**: Controls whether the choice can be selected
- **disabled_text**: Optional text shown when choice is not available
- **delay**: Seconds before outcome is revealed (creates tension)
- **outcomes**: Array of possible results from this choice

### Outcomes

Outcomes define what happens when a choice is made:

```json
{
  "weight": 1.0,
  "goto": "next_node_id",
  "effects": [],
  "result": {
    "title": "What Happened",
    "description": "Detailed description of the outcome"
  }
}
```

- **weight**: Probability weight (0.0-1.0) for random outcomes
- **goto**: Optional - move to another node instead of ending the event
- **effects**: Array of changes to apply to the game state
- **result**: Final result shown to player (required if no goto)

### Effects

Effects modify the game state:

```json
{
  "type": "character_status",
  "property": "mind",
  "delta": -10
}
```

Currently supported:
- **character_status**: Modify mind, saving, or energy by delta amount

## Best Practices

### Event Design
- Keep events focused on a single scenario or decision point
- Provide meaningful choices that affect character status
- Balance risk vs reward in outcomes
- Consider the impact on game flow and pacing

### Writing Guidelines
- Write in present tense, second person ("You see...", "You decide...")
- Keep text concise but descriptive
- Make choice consequences clear to players
- Use consistent tone with the game's style

### Technical Tips
- Use descriptive IDs for nodes and choices (e.g., "help_grandma", "ignore_and_walk")
- Test all possible paths through your event
- Ensure weight values sum to 1.0 for random outcomes
- Use delays strategically to build tension

### Character Status Guidelines
- **Mind**: Affected by moral choices, stress, positive experiences
- **Saving**: Money spent or earned through choices
- **Energy**: Physical exertion, rest, caffeine, weather effects

Typical delta ranges:
- Small impact: ±5
- Medium impact: ±10-15  
- Large impact: ±20-30

### Common Patterns

**Simple Binary Choice:**
```json
"outcomes": [
  {
    "weight": 1,
    "effects": [{"type": "character_status", "property": "mind", "delta": 10}],
    "result": {"title": "Good Choice", "description": "You feel better."}
  }
]
```

**Random Outcome:**
```json
"outcomes": [
  {
    "weight": 0.7,
    "result": {"title": "Success", "description": "It worked!"}
  },
  {
    "weight": 0.3,  
    "result": {"title": "Failure", "description": "It didn't work."}
  }
]
```

**Conditional Choice:**
```json
"availability": {
  "conditions": [{"type": "status_min", "property": "energy", "value": 30}],
  "disabled_text": "You're too tired for this."
}
```

**Multi-Node Event:**
```json
"outcomes": [
  {
    "weight": 1,
    "goto": "next_scene"
  }
]
```

## Testing Your Event

1. Place your JSON file in `assets/data/`
2. Trigger the event in-game through normal gameplay
3. Test all choice paths and outcomes
4. Verify status changes work as expected
5. Check that preconditions work correctly

## Examples

See existing events in `assets/data/` for reference:
- `coffee_event.json`: Complex multi-node branching narrative
- `grandma_crossing_event.json`: Simple moral choice with clear consequences
- `money_on_ground_event.json`: Random outcomes and fake-out scenarios
- `traffic_light_event.json`: Risk/reward decision making
- `without_umbrella_rain_event.json`: Simple environmental challenge