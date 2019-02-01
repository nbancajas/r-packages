require 'rails_helper'

describe ContributorPackageVersion do
  it { should validate_inclusion_of(:role).in_array(%w(author maintainer)) }
end
