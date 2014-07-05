class Game < ActiveRecord::Base
  # extends ....................................................................
  # includes ...................................................................
  # constants ..................................................................
  STATUSES = %i[ created running finished ]

  # associations ...............................................................
  belongs_to :group

  has_many   :teams
  has_many   :players, through: :teams

  has_one    :user, through: :group

  enum status: STATUSES

  # scopes .....................................................................
  # validations ................................................................
  validates_presence_of :group
  validates_presence_of :status
  validate :only_one_open_game_per_group
  validate :number_of_teams
  validate :same_player_can_not_play_in_both_teams

  # callbacks ..................................................................
  # additional config ..........................................................

  # class methods ..............................................................
  # instance methods ...........................................................
  # protected instance methods .................................................
  protected

  def only_one_open_game_per_group
    open_game = GamesService.open_game_for(group)
    if !finished? && open_game.present? && open_game.id != id
      errors.add(:status, 'with value :created or :running can only exist once per group')
    end
  end

  def number_of_teams
    errors.add(:teams, 'too many') if teams.count > 2
  end

  def same_player_can_not_play_in_both_teams
    ids = teams.map(&:player_ids).flatten

    if ids.count != ids.uniq.count
      errors.add(:players, 'in teams are not unique')
    end
  end

  # private instance methods ...................................................
end
