
if [ "$(uname)" == "Darwin" ]; then

    make FC='gfortran' LINKER='gfortran'
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64

    make FC='ifort' LINKER='ifort -static'
fi

# pseudo "make install"
mkdir -p ${PREFIX}/bin
cp gcp ${PREFIX}/bin

