Player.destroy_all
Player.reset_pk_sequence
Board.destroy_all
Board.reset_pk_sequence

alex = Player.create(name: "WashSqPark_guy", win_count: 999)
bob = Player.create(name: "super computer", win_count: 998)
cat = Player.create(name: "garryK1991", win_count: 800)
dan = Player.create(name: "Handsome Dan", win_count: 0)
double = Player.create(name: "double")
jump = Player.create(name: "jump")
win = Player.create(name: "salovey")
test = Player.create(name: "test")

config1 = [
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜🔵⬜⬛⬜",
    "⬜⬛⬜⬛⬜🔴⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜",
    "⬜⬛⬜🔴⬜⬛⬜⬛",
    "⬛⬜🔵⬜⬛⬜⬛⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜"
]
config1 = config1.join("\n")
b1 = Board.create(r_player: jump, l_player: test, content: config1)

config2 = [
    "⬜⬛⬜⬛⬜⬛⬜🔴",
    "⬛⬜⬛⬜🔵⬜🔵⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜🔵⬜🔵⬜🔴⬜",
    "⬜🔴⬜⬛⬜⬛⬜⬛",
    "⬛⬜🔵⬜⬛⬜🔴⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜🔵⬜⬛⬜"
]
config2 = config2.join("\n")

b2 = Board.create(r_player: double, l_player: jump, content: config2)

config3  = [
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜🔴⬜⬛⬜",
    "⬜⬛⬜🔵⬜🔵⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜"
]
config3 = config3.join("\n")

b3 = Board.create(r_player: win, l_player: dan, content: config3)
