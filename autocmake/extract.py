def extract_list(config, section):
    from collections import Iterable
    l = []
    if 'modules' in config:
        for module in config['modules']:
            for k, v in module.items():
                for x in v:
                    if section in x:
                        if isinstance(x[section], Iterable) and not isinstance(x[section], str):
                            for y in x[section]:
                                l.append(y)
                        else:
                            l.append(x[section])
    return l
