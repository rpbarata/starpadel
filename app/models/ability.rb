class Ability
  include CanCan::Ability
  def initialize(user)
    if user.super_admin?
      can(:manage, :all)
    end

    if user.coach_admin?
      can([:index, :read], Client)
    end

    if user.secretariat_admin?
      can(:manage, Client)
    end
  end
end