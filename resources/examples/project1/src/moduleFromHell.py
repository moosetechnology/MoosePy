globalVar = 4


def return3():
    global globalVar
    globalVar = 5
    return 2


print(return3())
print(globalVar)


def return3():
    return 3


print(return3())
print(globalVar)

from moduleAtRoot8 import functionReturningSomething as return3

print(return3())


def return3():
    return 3


print(return3())


class Counter:

    def __init__(self):
        self.countb = 0


    def increment(self):
        self.countb = self.countb + 2

    def get_countb(self):
        return self.countb

c = Counter()
c.increment()
print(c.get_countb())
print(c.__dict__.keys())

class Counter:

    def __init__(self):
        self.count = 0

    def increment(self):
        self.otherIVar = 2
        self.count = self.count + 1

    def increment(self):
        self.count = self.count + 2
        return 1
        self.againAnother = 2

    def get_count(self):
        return self.count


c = Counter()
c.increment()
print(c.get_count())
print(c.__dict__.keys())
