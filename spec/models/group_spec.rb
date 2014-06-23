require 'spec_helper'

RSpec.describe Group, :type => :model do

  it 'expects to have a valid factory' do
    expect(FactoryGirl.build(:group)).to be_valid
  end

  describe 'expects presence of' do
    it 'name' do
      expect(FactoryGirl.build(:group, name: nil)).to_not be_valid
    end

    it 'user' do
      expect(FactoryGirl.build(:group, user: nil)).to_not be_valid
    end
  end

end
