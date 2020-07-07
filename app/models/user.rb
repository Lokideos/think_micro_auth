# frozen_string_literal: true

class User < Sequel::Model
  NAME_FORMAT = /\A\w+\z/.freeze

  one_to_many :sessions, class: 'UserSession'

  def validate
    super
    validates_presence :name, message: I18n.t(:blank, scope: 'model.errors.user.name')
    validates_presence :email, message: I18n.t(:blank, scope: 'model.errors.user.email')
    validates_format NAME_FORMAT, :name, message: I18n.t(:format, scope: 'model.errors.user.name')
  end
end
