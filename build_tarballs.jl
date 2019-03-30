
using BinaryBuilder

name = "LibSSLBuilder"
version = v"1.1.1"

# Collection of sources required to build LibSSLBuilder
sources = [
    "https://www.openssl.org/source/openssl-1.1.1b.tar.gz" =>
    "5c557b023230413dfb0756f3137a13e6d726838ccd1430888ad15bfb2b43ea4b",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd openssl-1.1.1b/
./config --prefix=$prefix
make -j${nproc}
make install_sw
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "afalg", :afalg),
    LibraryProduct(prefix, "libcrypto", :libcrypto),
    LibraryProduct(prefix, "libssl", :libssl),
    LibraryProduct(prefix, "capi", :capi),
    LibraryProduct(prefix, "padlock", :padlock),
    ExecutableProduct(prefix, "openssl", :openssl)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
