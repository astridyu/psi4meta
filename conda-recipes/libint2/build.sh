
#if [ "$(uname)" == "Darwin" ]; then
#
#    # link against conda Clang
#    # * -fno-exceptions squashes `___gxx_personality_v0` symbol and thus libc++ dependence
#    ALLOPTS="-clang-name=${CLANG} ${OPTS} -fno-exceptions"
#    ALLOPTSCXX="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -fno-exceptions -mmacosx-version-min=10.9"
#
#    # configure
#    ${BUILD_PREFIX}/bin/cmake \
#        -H${SRC_DIR} \
#        -Bbuild \
#        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
#        -DCMAKE_BUILD_TYPE=Release \
#        -DCMAKE_C_COMPILER=icc \
#        -DCMAKE_CXX_COMPILER=icpc \
#        -DCMAKE_C_FLAGS="${ALLOPTS}" \
#        -DCMAKE_CXX_FLAGS="${ALLOPTSCXX}" \
#        -DCMAKE_INSTALL_LIBDIR=lib \
#        -DMAX_AM_ERI=${MAX_AM_ERI} \
#        -DBUILD_SHARED_LIBS=ON \
#        -DMERGE_LIBDERIV_INCLUDEDIR=ON \
#        -DENABLE_XHOST=OFF
#fi


if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2019/bin/compilervars.sh intel64
    set -x

    # allow more arguments to avoid the dreaded `x86_64-conda_cos6-linux-gnu-ld: Argument list too long` upon linking
    echo `getconf ARG_MAX`
    ulimit -s 65535
    echo `getconf ARG_MAX`

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -GNinja \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED=ON \
        -DBUILD_STATIC=OFF \
        -DLIBINT2_SHGAUSS_ORDERING=gaussian \
        -DLIBINT2_CARTGAUSS_ORDERING=standard \
        -DLIBINT2_SHELL_SET=standard \
        -DERI3_PURE_SH=OFF \
        -DERI2_PURE_SH=OFF \
        -DMPFR_ROOT=${PREFIX} \
        -DBOOST_ROOT=${PREFIX} \
        -DEigen3_ROOT=${PREFIX} \
        -DLIBINT_GENERATE_FMA=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_CXX11API=ON \
        -DENABLE_FORTRAN=OFF \
        -DBUILD_TESTING=ON

        # _6
        # -DENABLE_ERI=2 \
        # -DENABLE_ERI3=2 \
        # -DENABLE_ERI2=2 \
        # -DWITH_ERI_MAX_AM="7;7;5" \
        # -DWITH_ERI3_MAX_AM="7;7;6" \
        # -DWITH_ERI2_MAX_AM="7;7;6" \

        #-DEigen3_DIR=${PREFIX}/share/eigen3/cmake/
        #-DCMAKE_VERBOSE_MAKEFILE=ON \

# build & install & test
cd build
cmake --build . --target install -j${CPU_COUNT}

fi

# This works for making a conda package out of a pre-built install
#
if [ "$(uname)" == "SpecialLinux" ]; then

PREBUILT=/psi/gits/libint2/install40

cp -pR ${PREBUILT}/* ${PREFIX}
cp ${PREFIX}/lib/pkgconfig/libint2.pc tmp0
sed "s|$PREBUILT|/opt/anaconda1anaconda2anaconda3|g" tmp0 > tmp1
cp tmp1 ${PREFIX}/lib/pkgconfig/libint2.pc

fi
