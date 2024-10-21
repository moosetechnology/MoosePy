# The next code is here to show the ambiguity between accesses and member references
class Toto:

    def __init__(self, name):
        self.name = name

    def tata(self):
        return 2

    def toto(self):
        self.tata = 3


t = Toto("test")
print(t.tata)
t.toto()
print(t.tata)