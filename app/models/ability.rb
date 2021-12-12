# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)
    if user.super_admin?
      can(:manage, :all)
    end

    if user.coach_admin?
      can([:index, :read], Client)
      can([:index, :read], LessonsType)
      can(:manage, ClientLesson)
      can(:manage, CreditedLesson)
    end

    if user.secretariat_admin?
      can(:manage, Client)
      can([:index, :show], LessonsType)
      can(:manage, ClientLesson)
      can(:manage, CreditedLesson)
      can(:manage, Voucher)
    end
  end
end
