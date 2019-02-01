require 'rails_helper'

describe UpdatePackagesDescriptionWorker do
  describe "#perform" do
    before do
      package = Package.create(name: "A3", version: "0.9.9")
      package_version_old = PackageVersion.create(package: package, version: "0.9.9")
      package_version_new = PackageVersion.create(package: package, version: "1.0.0")

      package.update(latest_version: package_version_new)
    end

    subject { described_class.new.perform({ "A3" => "1.0.0" }) }

    it "updates package metadata" do
      allow_any_instance_of(RemotePackage).to receive(:get_tarball).and_yield(StringIO.new(IO.read(file_fixture('package_a3'))))

      package_version = PackageVersion.where(version: "1.0.0").first
      expect(package_version.title).to eq nil
      expect(package_version.description).to eq nil
      expect(package_version.authors).to eq []
      expect(package_version.maintainer).to eq nil
      expect(package_version.publication_date).to eq nil

      subject

      #package_version.reload
      package_version = PackageVersion.where(version: "1.0.0").first

      expect(package_version.title).to eq "Accurate, Adaptable, and Accessible Error Metrics for Predictive Models"
      expect(package_version.description).to eq "Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward."
      expect(package_version.authors.map(&:name)).to eq ["Scott Fortmann-Roe"]
      expect(package_version.maintainer.name).to eq "Scott Fortmann-Roe"
      expect(package_version.maintainer.email).to eq "scottfr@berkeley.edu"
      expect(package_version.publication_date).to eq Date.parse("Mon, 17 Aug 2015")
    end
  end
end
