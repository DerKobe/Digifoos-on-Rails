require 'spec_helper'

RSpec.describe Session, :type => :model do

  it 'expects to have a valid factory' do
    expect(FactoryGirl.build(:session)).to be_valid
  end

  describe 'expects presence of' do
    it 'name' do
      expect(FactoryGirl.build(:session, name: nil)).to_not be_valid
    end

    it 'session' do
      expect(FactoryGirl.build(:session, user: nil)).to_not be_valid
    end
  end

end
