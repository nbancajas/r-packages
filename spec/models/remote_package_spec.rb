require 'rails_helper'

describe RemotePackage do
  let(:name)  { "some_package" }
  let(:version) { "1.0.0" }

  subject { described_class.new(name, version) }

  describe "#url" do
    let(:cran_host) { 'https://some.cran.host/source/packages' }

    it "returns expected format" do
      allow(ENV).to receive(:[]).with("CRAN_HOST").and_return(cran_host)

      expect(subject.url).to eq "#{cran_host}/#{name}_#{version}.tar.gz"
    end
  end

  describe "#description_contents" do
    let(:description_contents) do
      {"Package"=>"A3",
       "Type"=>"Package",
       "Title"=>"Accurate, Adaptable, and Accessible Error Metrics for Predictive Models",
       "Version"=>"1.0.0",
       "Date"=> Date.parse('Sat, 15 Aug 2015'),
       "Author"=>"Scott Fortmann-Roe",
       "Maintainer"=>"Scott Fortmann-Roe <scottfr@berkeley.edu>",
       "Description"=>
      "Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.",
        "License"=>"GPL (>= 2)",
        "Depends"=>"R (>= 2.15.0), xtable, pbapply",
        "Suggests"=>"randomForest, e1071",
        "NeedsCompilation"=>false,
        "Packaged"=>"2015-08-16 14:17:33 UTC; scott",
        "Repository"=>"CRAN",
        "Date/Publication"=>DateTime.parse('2015-08-17 01:05:52 +0200')}
    end

    it "returns parsed description file" do
      allow_any_instance_of(RemotePackage).to receive(:get_tarball).and_yield(StringIO.new(IO.read(file_fixture('package_a3'))))

      expect(subject.description_contents).to eq description_contents
    end
  end
end
