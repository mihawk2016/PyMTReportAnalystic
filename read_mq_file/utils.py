

def file_name(file_path):
    """
    Build: 2016-11-18
    :param file_path: file path
    :return: file name without path
    """
    return file_path.split('\\')[-1]


def file_extension(file_name):
    """
    Build: 2016-11-18
    :param file_name: file name without path
    :return: extension of file name
    """
    return file_name.split('.')[-1].lower()
