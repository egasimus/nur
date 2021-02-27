(({ pkgs, python27Packages }: python27Packages.buildPythonApplication rec {
  name =
    "butterflow";
  src = pkgs.fetchFromGitHub {
    owner  = "dthpham";
    repo   = "butterflow";
    rev    = "c0b15c2";
    sha256 = "1d5r4pnmp55cp5zrq89kjbjznsqf4i039cxwy2vg1034j9fa1r2y"; };
  LDFLAGS =
    "-L${pkgs.intel-ocl.outPath}/lib";
  CFLAGS =
    "-I${python27Packages.numpy.outPath}/lib/python2.7/site-packages/numpy/core/include";
  buildInputs = with pkgs; [
    ffmpeg
    opencv
    opencl-headers
    opencl-clhpp
    ocl-icd
    khronos-ocl-icd-loader
  ];
  propagatedBuildInputs = (with python27Packages; [
    numpy
    opencv
  ]) ++ (with pkgs; [
    ocl-icd
    intel-ocl
    khronos-ocl-icd-loader
  ]);
  postUnpack = ''
    export prefix=$out
    echo "" > source/butterflow/__init__.py
  '';
  setuptoolsCheckPhase =
    ":";
}))
