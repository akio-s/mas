class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag => "v1.4.4",
      :revision => "3660365dd334cd852dd83d42ee016e267821a5de"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    root_url "https://dl.bintray.com/phatblat/mas-bottles"
    cellar :any
    sha256 "237fd7270cb8f0d68a33e7ce05671a2e5c269d05d736abb0f66b50215439084e" => :mojave
    sha256 "237fd7270cb8f0d68a33e7ce05671a2e5c269d05d736abb0f66b50215439084e" => :high_sierra
    sha256 "237fd7270cb8f0d68a33e7ce05671a2e5c269d05d736abb0f66b50215439084e" => :sierra
    sha256 "237fd7270cb8f0d68a33e7ce05671a2e5c269d05d736abb0f66b50215439084e" => :el_capitan
    sha256 "237fd7270cb8f0d68a33e7ce05671a2e5c269d05d736abb0f66b50215439084e" => :yosemite
    sha256 "237fd7270cb8f0d68a33e7ce05671a2e5c269d05d736abb0f66b50215439084e" => :mavericks
  end

  depends_on "carthage" => :build
  depends_on :xcode => ["10.1", :build]

  def install
    # Working around build issues in dependencies
    # - Prevent warnings from causing build failures
    # - Prevent linker errors by telling all lib builds to use max size install names
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      GCC_TREAT_WARNINGS_AS_ERRORS = NO
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig

    system "carthage", "bootstrap", "--platform", "macOS"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
  end
end
