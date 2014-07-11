class Group < ActiveRecord::Base
  # extends ....................................................................
  # includes ...................................................................
  include FriendlyId

  # constants ..................................................................
  # associations ...............................................................
  belongs_to :user # author

  has_many :games, dependent: :destroy
  has_many :players, dependent: :destroy

  has_and_belongs_to_many :users # shared groups

  # scopes .....................................................................
  # validations ................................................................
  validates_presence_of :name, :user
  validates_uniqueness_of :name, scope: :user

  # callbacks ..................................................................
  # additional config ..........................................................
  friendly_id :name, use: [:slugged, :finders]

  # class methods ..............................................................
  # instance methods ...........................................................
  # protected instance methods .................................................
  # private instance methods ...................................................
end
