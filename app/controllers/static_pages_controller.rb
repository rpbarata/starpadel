# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def cookies_policy
    @breadcrumbs = [
      { text: "Home", href: root_path },
      { text: "Política de Cookies", href: cookies_policy_path },
    ]

    @our_cookies = [
      { source: ENV["HOST"], kind: "Sessão", goal: "Funcionais", use: "Estes cookies são utilizados para suporte a funcionalidades base que requerem autenticação por parte dos
        utilizadores. Estes cookies são automaticamente eliminados quando fechar o browser.", }
    ]
  end
end
