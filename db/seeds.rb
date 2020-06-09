alex = Player.new(name: "Alex")
bob = Player.new(name: "Bob")
cat = Player.new(name: "Cat")
dan = Player.new(name: "Dan")

config1 = [
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜"
]
config1 = config1.join("\n")
b1 = Board.new(r_player: alex, l_player: bob, contents: config1)

config2 = [
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜🔵⬜",
    "⬜🔴⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜🔵⬜",
    "⬜🔴⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜🔵⬜",
    "⬜🔴⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜"
]
config2 = config2.join("\n")

b2 = Board.new(r_player: bob, l_player: cat, contents: config2)

config3  = [
    "⬜🔵⬜⬛⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜",
    "⬜⬛⬜⬛⬜🔴⬜⬛",
    "⬛⬜⬛⬜⬛⬜🔵⬜",
    "⬜⬛⬜⬛⬜⬛⬜⬛",
    "⬛⬜🔴⬜⬛⬜⬛⬜",
    "⬜⬛⬜🔵⬜⬛⬜⬛",
    "⬛⬜⬛⬜⬛⬜⬛⬜"
]
config3 = config3.join("\n")

b3 = Board.new(r_player: cat, l_player: alex, contents: config3)
