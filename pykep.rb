class Pykep < Formula
  desc "Library providing basic tools for astrodynamics research"
  homepage "https://esa.github.io/pykep/"
  head "https://github.com/esa/pykep.git"
  revision 1

  stable do
    url "https://github.com/esa/pykep/archive/v1.3.9.tar.gz"
    sha256 "1bb0a71a1d19908e3703ca6e3cc87d75f2f8b91c65c3a778e1acd1962c1e87f1"

    # Remove for > 1.3.9
    # Upstream commit from 8 Feb 2017 "fix for #57 - linking to python libraries
    # only for windows now"
    # https://github.com/esa/pykep/commit/351b628bf404ed53b3ae3e06eb8bdc56dc1deb11
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d42dc14/pykep/nopythonlinking.diff"
      sha256 "6b2372c77b0e4062145d4bed6f372d3f04283c2ab58014f8994950832e56099e"
    end
  end

  bottle do
    cellar :any
    sha256 "cb2d8391863a88b706302e6df25b6c5e37a27e80815b5c5515b76100b0b14d09" => :sierra
    sha256 "e8e5333cd59c99fa90b7b4289d30384dc2b12dbbe03121382102fe5c38890b42" => :el_capitan
    sha256 "0afc43401b85d180f874ccb7fabcbd05217ca4625cc2cf6674b6cb84e30da640" => :yosemite
    sha256 "8fd2c13f7babf75f300c307aa0efab464e6bd7ba2a67392416a553a251430c92" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost@1.59"
  depends_on "boost-python@1.59"
  depends_on :python => :recommended

  def install
    args = std_cmake_args + [
      "-DBUILD_TESTS=ON",
      "-DBUILD_PYKEP=ON",
      "-DBUILD_SPICE=ON",
      "-DPYTHON_MODULES_DIR=#{lib}/python2.7/site-packages",
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import PyKEP"
    end
  end
end
