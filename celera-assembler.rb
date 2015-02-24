class CeleraAssembler < Formula
  homepage "http://wgs-assembler.sourceforge.net/"
  # doi "myers2000whole" => "10.1126/science.287.5461.2196",
  #   "levy2007diploid" => "10.1371/journal.pbio.0050254",
  #   "miller2008aggressive" => "10.1093/bioinformatics/btn548"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-8.2/wgs-8.2.tar.bz2"
  sha1 "a3c299e145bcdd1492bab4a677a445a308509e57"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "3a85819d72beed36990f358167bcbd0f28faea6b" => :yosemite
    sha1 "dc1c3f744d0ce05e79fcadb6561f5b91d22bf56b" => :mavericks
    sha1 "97a5c61310b924a03bb1d587f256f5ac35cb425c" => :mountain_lion
  end

  # Fails with clang: https://sourceforge.net/p/wgs-assembler/bugs/262/
  needs :openmp

  def install
    ENV.deparallelize

    # Search Homebrew library paths before system paths.
    inreplace "src/c_make.as", " /usr/lib64 ", " "

    system "make", "-C", "kmer", "install", "CC=#{ENV.cc}"
    system "make", "-C", "src", "CC=#{ENV.cc}", "LDLIBS=-rdynamic"
    arch = Pathname.new(Dir["*/bin"][0]).dirname
    libexec.install arch
    bin.install_symlink libexec/arch/"bin/runCA"
  end

  test do
    system "#{bin}/runCA"
  end
end
