extends Node

class_name HandEvaluator

enum HandRank {
	HIGH_CARD = 0,
	PAIR = 1,
	TWO_PAIR = 2,
	THREE_OF_A_KIND = 3,
	STRAIGHT = 4,
	FLUSH = 5,
	FULL_HOUSE = 6,
	FOUR_OF_A_KIND = 7,
	STRAIGHT_FLUSH = 8,
	ROYAL_FLUSH = 9
}

# Convert card ranks to numeric values for comparison
var rank_values = {
	"2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10,
	"J": 11, "Q": 12, "K": 13, "A": 14
}

# Evaluate a hand of cards and return the best poker hand
func evaluate_hand(cards: Array) -> Dictionary:
	if cards.size() == 0:
		return {"rank": HandRank.HIGH_CARD, "name": "No Cards Selected", "cards": []}
		
	var ranks = []
	var suits = []
	for card in cards:
		ranks.append(card.rank)
		suits.append(card.suit)
	
	# Check for each hand type based on number of cards
	if cards.size() >= 5:
		var result = check_royal_flush(ranks, suits)
		if result: return result
		
		result = check_straight_flush(ranks, suits)
		if result: return result
	
	if cards.size() >= 4:
		var result = check_four_of_a_kind(ranks)
		if result: return result
	
	if cards.size() >= 5:
		var result = check_full_house(ranks)
		if result: return result
		
		result = check_flush(suits)
		if result: return result
		
		result = check_straight(ranks)
		if result: return result
	
	if cards.size() >= 3:
		var result = check_three_of_a_kind(ranks)
		if result: return result
	
	if cards.size() >= 4:
		var result = check_two_pair(ranks)
		if result: return result
	
	if cards.size() >= 2:
		var result = check_pair(ranks)
		if result: return result
	
	# If no other hand or just one card, return high card
	return {
		"rank": HandRank.HIGH_CARD,
		"name": "High Card",
		"high_card": get_highest_card(ranks)
	}

func check_royal_flush(ranks: Array, suits: Array) -> Dictionary:
	if !is_flush(suits): return {}
	var values = convert_to_values(ranks)
	values.sort()
	if values == [10, 11, 12, 13, 14]:
		return {
			"rank": HandRank.ROYAL_FLUSH,
			"name": "Royal Flush",
			"suit": suits[0]
		}
	return {}

func check_straight_flush(ranks: Array, suits: Array) -> Dictionary:
	if !is_flush(suits): return {}
	var straight = check_straight(ranks)
	if straight.is_empty(): return {}
	return {
		"rank": HandRank.STRAIGHT_FLUSH,
		"name": "Straight Flush",
		"high_card": straight.high_card,
		"suit": suits[0]
	}

func check_four_of_a_kind(ranks: Array) -> Dictionary:
	var count = count_ranks(ranks)
	for rank in count:
		if count[rank] == 4:
			return {
				"rank": HandRank.FOUR_OF_A_KIND,
				"name": "Four of a Kind",
				"value": rank
			}
	return {}

func check_full_house(ranks: Array) -> Dictionary:
	var count = count_ranks(ranks)
	var three_rank = ""
	var pair_rank = ""
	
	for rank in count:
		if count[rank] == 3:
			three_rank = rank
		elif count[rank] == 2:
			pair_rank = rank
			
	if three_rank and pair_rank:
		return {
			"rank": HandRank.FULL_HOUSE,
			"name": "Full House",
			"three_rank": three_rank,
			"pair_rank": pair_rank
		}
	return {}

func check_flush(suits: Array) -> Dictionary:
	if is_flush(suits):
		return {
			"rank": HandRank.FLUSH,
			"name": "Flush",
			"suit": suits[0]
		}
	return {}

func check_straight(ranks: Array) -> Dictionary:
	var values = convert_to_values(ranks)
	values.sort()
	
	# Check for Ace-low straight (A,2,3,4,5)
	if values == [2, 3, 4, 5, 14]:
		return {
			"rank": HandRank.STRAIGHT,
			"name": "Straight",
			"high_card": "5"
		}
	
	# Check for normal straight
	for i in range(values.size() - 1):
		if values[i + 1] - values[i] != 1:
			return {}
	
	return {
		"rank": HandRank.STRAIGHT,
		"name": "Straight",
		"high_card": ranks[values.find(values.max())]
	}

func check_three_of_a_kind(ranks: Array) -> Dictionary:
	var count = count_ranks(ranks)
	for rank in count:
		if count[rank] == 3:
			return {
				"rank": HandRank.THREE_OF_A_KIND,
				"name": "Three of a Kind",
				"value": rank
			}
	return {}

func check_two_pair(ranks: Array) -> Dictionary:
	var count = count_ranks(ranks)
	var pairs = []
	for rank in count:
		if count[rank] == 2:
			pairs.append(rank)
	
	if pairs.size() == 2:
		return {
			"rank": HandRank.TWO_PAIR,
			"name": "Two Pair",
			"high_pair": get_highest_card(pairs),
			"low_pair": get_lowest_card(pairs)
		}
	return {}

func check_pair(ranks: Array) -> Dictionary:
	var count = count_ranks(ranks)
	for rank in count:
		if count[rank] == 2:
			return {
				"rank": HandRank.PAIR,
				"name": "Pair",
				"value": rank
			}
	return {}

# Helper functions
func is_flush(suits: Array) -> bool:
	return suits.count(suits[0]) == suits.size()

func convert_to_values(ranks: Array) -> Array:
	var values = []
	for rank in ranks:
		values.append(rank_values[rank])
	return values

func count_ranks(ranks: Array) -> Dictionary:
	var count = {}
	for rank in ranks:
		if rank in count:
			count[rank] += 1
		else:
			count[rank] = 1
	return count

func get_highest_card(ranks: Array) -> String:
	var highest_value = -1
	var highest_rank = ""
	for rank in ranks:
		if rank_values[rank] > highest_value:
			highest_value = rank_values[rank]
			highest_rank = rank
	return highest_rank

func get_lowest_card(ranks: Array) -> String:
	var lowest_value = 999
	var lowest_rank = ""
	for rank in ranks:
		if rank_values[rank] < lowest_value:
			lowest_value = rank_values[rank]
			lowest_rank = rank
	return lowest_rank 