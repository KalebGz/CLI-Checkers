alex = Player.create(name: "Alex")
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
b1 = Board.create(r_player: alex, l_player: bob, content: config1)

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

b2 = Board.create(r_player: bob, l_player: cat, content: config2)

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

b3 = Board.create(r_player: cat, l_player: alex, content: config3)

b4 = Board.create(r_player: alex, l_player: cat)

binding.pry
0