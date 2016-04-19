def fetch_url(src, dst):
    """
    Fetch file from URL src and save it to dst.
    """
    # we do not use the nicer sys.version_info.major
    # for compatibility with Python < 2.7
    if sys.version_info[0] > 2:
        import urllib.request

        class URLopener(urllib.request.FancyURLopener):
            def http_error_default(self, url, fp, errcode, errmsg, headers):
                sys.stderr.write("ERROR: could not fetch {0}\n".format(url))
                sys.exit(-1)
    else:
        import urllib

        class URLopener(urllib.FancyURLopener):
            def http_error_default(self, url, fp, errcode, errmsg, headers):
                sys.stderr.write("ERROR: could not fetch {0}\n".format(url))
                sys.exit(-1)

    dirname = os.path.dirname(dst)
    if dirname != '':
        if not os.path.isdir(dirname):
            os.makedirs(dirname)

    opener = URLopener()
    opener.retrieve(src, dst)
