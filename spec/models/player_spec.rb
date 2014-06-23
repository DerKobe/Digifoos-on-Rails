require 'spec_helper'

RSpec.describe Player, :type => :model do

  it 'expects to have a valid factory' do
    expect(FactoryGirl.build(:player)).to be_valid
  end

  describe 'expects presence of' do
    it 'name' do
      expect(FactoryGirl.build(:player, name: nil)).to_not be_valid
    end

    it 'group' do
      expect(FactoryGirl.build(:player, group: nil)).to_not be_valid
    end
  end

end
