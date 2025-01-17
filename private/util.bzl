load("@bazel_version//:version.bzl", "version")

def _safe_int(s, v):
    if not s.isdigit():
        fail("invalid Bazel version '{}': non-numeric segment '{}'".format(v, s))
    return int(s)

def _partition(s):
    for i in range(len(s)):
        c = s[i]
        if c == "-":
            return s[:i], s[i + 1:]
        if not c.isdigit() and c != ".":
            return s[:i], s[i:]
    return s, ""

def parse_version(v):
    """Parses the given Bazel version string into a comparable value."""
    if not v:
        # An empty string is treated as a "dev version", which is greater than anything.
        v = "999999.999999.999999"
    release, prerelease = _partition(v.partition(" ")[0])
    segments = release.split(".")
    if len(segments) != 3:
        fail("invalid Bazel version '{}': got {} dot-separated segments, want 3".format(v, len(segments)))
    return [_safe_int(s, v) for s in segments], not prerelease, prerelease

BAZEL_VERSION = parse_version(version)

def le(v):
    return BAZEL_VERSION <= parse_version(v)

def lt(v):
    return BAZEL_VERSION < parse_version(v)

def ne(v):
    return BAZEL_VERSION != parse_version(v)

def ge(v):
    return BAZEL_VERSION >= parse_version(v)

def gt(v):
    return BAZEL_VERSION > parse_version(v)
