# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)
    if user.super_admin?
      can(:manage, :all)
    end

    if user.coach_admin?
      can([:index, :read], Client)
      can([:index, :show], LessonsType)
    end

    if user.secretariat_admin?
      can(:manage, Client)
      can([:index, :show], LessonsType)
    end
  end
end
