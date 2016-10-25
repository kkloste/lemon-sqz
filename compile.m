function compile_debug
mypath = fileparts(mfilename('fullpath'));
curdir = pwd();
try
    cd(mypath);
    if ismac
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims sparse_degpower_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims ./util/sweepcut_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims ./baseline_codes/hkgrow_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims ./baseline_codes/hkvec_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims ./baseline_codes/pprgrow_mex.cc
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims ./baseline_codes/pprvec_mex.cc
    else
         mex -O CXXFLAGS="\$CXXFLAGS -std=c++0x" -I. -largeArrayDims sparse_degpower_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -std=c++0x" -I. -largeArrayDims ./util/sweepcut_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -std=c++0x" -I. -largeArrayDims ./baseline_codes/hkgrow_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -std=c++0x" -I. -largeArrayDims ./baseline_codes/hkvec_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -std=c++0x" -I. -largeArrayDims ./baseline_codes/pprgrow_mex.cc
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -std=c++0x" -I. -largeArrayDims ./baseline_codes/pprvec_mex.cc
    end
    cd(curdir);
catch me
    cd(curdir)
    rethrow(me)
end
