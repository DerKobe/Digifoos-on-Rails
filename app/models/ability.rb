class Ability
  # extends ....................................................................
  # includes ...................................................................

  include CanCan::Ability

  # constants ..................................................................
  # additional config ..........................................................
  # class methods ..............................................................
  # instance methods ...........................................................

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, :to => :crud

    can :read, Group
    can :crud, Group,  user: user

    can :manage_games, Group, user: user
    can :manage_games, Group, users: { id: user.id }

    can :read, Player
    can :crud, Player, user: user # through association
  end

  # protected instance methods .................................................
  # private instance methods ...................................................
end
