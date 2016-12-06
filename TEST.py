


def TEST_FUN(a=None, b=None):
    return {'A': a, 'B': b}



if __name__ == '__main__':
    dic = {'a': 5}
    print(TEST_FUN(**dic))