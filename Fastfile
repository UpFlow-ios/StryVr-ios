# Fastlane Configuration for StryVr iOS App
# Automated deployment pipeline

default_platform(:ios)

platform :ios do
  desc "Build and test StryVr app"
  lane :test do
    scan(
      scheme: "StryVr",
      device: "iPhone 16 Pro",
      clean: true
    )
  end

  desc "Build StryVr for App Store"
  lane :build do
    gym(
      scheme: "StryVr",
      export_method: "app-store",
      clean: true,
      output_directory: "builds",
      output_name: "StryVr.ipa"
    )
  end

  desc "Deploy to TestFlight"
  lane :beta do
    build
    pilot(
      skip_waiting_for_build_processing: true
    )
  end

  desc "Deploy to App Store"
  lane :release do
    build
    deliver(
      submit_for_review: true,
      automatic_release: true,
      force: true
    )
  end

  desc "Code quality check"
  lane :quality do
    swiftlint(
      mode: :lint,
      config_file: ".swiftlint.yml"
    )
    swiftformat(
      path: ".",
      config_file: ".swiftformat"
    )
  end

  desc "Security audit"
  lane :security do
    sh("npm audit --audit-level=moderate")
    sh("cd backend && npm audit --audit-level=moderate")
  end
end 