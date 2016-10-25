function compile_debug
mypath = fileparts(mfilename('fullpath'));
curdir = pwd();
try
    cd(mypath);
    if ismac
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims sparse_degpower_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -I. -std=c++11" -largeArrayDims ./util/sweepcut_mex.cpp
    else
         mex -O CXXFLAGS="\$CXXFLAGS -std=c++0x" -I. -largeArrayDims sparse_degpower_mex.cpp
         mex -O CXXFLAGS="\$CXXFLAGS -Wall -std=c++0x" -I. -largeArrayDims ./util/sweepcut_mex.cpp
    end
    cd(curdir);
catch me
    cd(curdir)
    rethrow(me)
end
