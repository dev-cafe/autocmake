import glob

license_text = '''# (c) https://github.com/dev-cafe/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/dev-cafe/autocmake/blob/master/LICENSE

'''

for filename in glob.iglob('**/*.cmake', recursive=True):
    with open(filename, 'r') as old:
        text = old.read()
    with open(filename, 'w') as new:
        new.write(license_text)
        new.write(text)
