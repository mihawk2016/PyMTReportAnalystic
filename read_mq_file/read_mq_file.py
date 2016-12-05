from read_mq_file.utils import file_name, file_extension


def read_file(file_path):
    mq_file_name = file_name(file_path)
    mq_file_extension = file_extension(file_path)
    if mq_file_extension in ['htm', 'html']:
        print('it is a html file')
        # Todo: handle html file
    elif mq_file_extension in ['xlsx', 'xls']:
        print('it is a excel file')
        # Todo: handle excel file
    elif mq_file_extension in ['csv']:
        print('it is a csv file')
        # Todo: handle csv file
    else:
        print('not supported file type')
    # Todo: return file content

