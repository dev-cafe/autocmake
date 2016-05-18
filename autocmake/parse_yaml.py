def parse_yaml(stream, override={}):
    import yaml
    import sys
    from autocmake.interpolate import interpolate

    try:
        config = yaml.load(stream, yaml.SafeLoader)
    except yaml.YAMLError as exc:
        print(exc)
        sys.exit(-1)

    for k in config:
        if k in override:
            config[k] = override[k]

    config = interpolate(config, config)
    return config


def test_parse_yaml():
    import tempfile
    import os

    text = """foo: bar
this: that
var: '%(foo)'"""

    # we save this text to a temporary file
    file_name = tempfile.mkstemp()[1]
    with open(file_name, 'w') as f:
        f.write(text)

    with open(file_name, 'r') as f:
        assert parse_yaml(f) == {'foo': 'bar', 'this': 'that', 'var': 'bar'}

    # we remove the temporary file
    os.unlink(file_name)
