#!/bin/sh

LIBTOOLIZE_FLAGS=" --automake --copy --force"
AUTOMAKE_FLAGS="--add-missing --copy --force"
ACLOCAL_FLAGS=""

die() { echo "$@"; exit 1; }

ARGV0=$0
ARGS="$@"

run() {
  echo "$ARGV0: running \`$@' $ARGS"
  $@ $ARGS
}

# Try to locate a program by using which, and verify that the file is an
# executable
locate_binary() {
  for f in $@
  do
    file=`which $f 2>/dev/null | grep -v '^no '`
    if test -n "$file" -a -x "$file"; then
      echo $file
      return 0
    fi
  done

  echo ""
  return 1
}

# Try to detect the supported binaries if the user didn't
# override that by pushing the environment variable
if test x$LIBTOOLIZE = x; then
  LIBTOOLIZE=`locate_binary glibtoolize libtoolize-1.5 libtoolize`
  if test x$LIBTOOLIZE = x; then
    die "Did not find a supported libtoolize"
  fi
fi

if test x$ACLOCAL = x; then
  ACLOCAL=`locate_binary aclocal-1.11 aclocal-1.10 aclocal-1.9 aclocal19 aclocal`
  if test x$ACLOCAL = x; then
    die "Did not find a supported aclocal"
  fi
fi

if test x$AUTOMAKE = x; then
  AUTOMAKE=`locate_binary automake-1.11 automake-1.10 automake-1.9 automake19 automake`
  if test x$AUTOMAKE = x; then
    die "Did not find a supported automake"
  fi
fi

if test x$AUTOCONF = x; then
  AUTOCONF=`locate_binary autoconf-2.59 autoconf259 autoconf`
  if test x$AUTOCONF = x; then
    die "Did not find a supported autoconf"
  fi
fi

if test x$AUTOHEADER = x; then
  AUTOHEADER=`locate_binary autoheader-2.59 autoheader259 autoheader`
  if test x$AUTOHEADER = x; then
    die "Did not find a supported autoheader"
  fi
fi

run $LIBTOOLIZE $LIBTOOLIZE_FLAGS || die "Can't execute libtoolize"
run $ACLOCAL $ACLOCAL_FLAGS || die "Can't execute aclocal"
run $AUTOHEADER || die "Can't execute autoheader"
run $AUTOMAKE $AUTOMAKE_FLAGS  || die "Can't execute automake"
run $AUTOCONF || die "Can't execute autoconf"
