require 'rails_helper'

describe PersistPackagesWorker do
  describe "#perform" do
    let(:package_1) { { "Package" => "AAA", "Version" => "1.0.1" } }
    let(:package_2) { { "Package" => "AAA", "Version" => "1.0.2" } }

    let(:package_3) { { "Package" => "BBB", "Version" => "2.1.1" } }
    let(:package_4) { { "Package" => "BBB", "Version" => "3.0" } }

    let(:packages) { [package_1, package_3] }
    subject { described_class.new.perform(packages) }

    context "unindexed packages" do

      it "creates packages/package_versions " do
        subject

        first_package = Package.first
        last_package  = Package.last

        expect(Package.count).to eq 2
        expect(PackageVersion.count).to eq 2

        expect(first_package.name).to eq "AAA"
        expect(first_package.version).to eq "1.0.1"

        expect(last_package.name).to eq "BBB"
        expect(last_package.version).to eq "2.1.1"

        expect(first_package.latest_version).to eq PackageVersion.where(package_id: first_package.id).first
        expect(last_package.latest_version).to eq PackageVersion.where(package_id: last_package.id).first
      end
    end

    context "previously-indexed packages" do
      it "updates packages/package_versions " do
        subject

        first_package = Package.first
        last_package  = Package.last

        expect(first_package.latest_version).to eq PackageVersion.where(package_id: first_package, version: "1.0.1").first
        expect(last_package.latest_version).to  eq PackageVersion.where(package_id: last_package, version: "2.1.1").first

        # rerun with updated packages for both
        packages = [package_2, package_4]
        described_class.new.perform(packages)

        expect(Package.count).to eq 2
        expect(PackageVersion.count).to eq 4

        first_package.reload; last_package.reload

        expect(first_package.name).to eq "AAA"
        expect(first_package.version).to eq "1.0.2"
        expect(first_package.versions.map(&:version)).to eq ["1.0.1", "1.0.2"]

        expect(last_package.name).to eq "BBB"
        expect(last_package.version).to eq "3.0"
        expect(last_package.versions.map(&:version)).to eq ["2.1.1", "3.0"]

        expect(first_package.latest_version).to eq PackageVersion.where(package_id: first_package, version: "1.0.2").first
        expect(last_package.latest_version).to  eq PackageVersion.where(package_id: last_package, version: "3.0").first
      end
    end
  end
end
