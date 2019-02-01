class Contributor < ApplicationRecord
  def name_with_email
    @name_with_email ||= "#{name} <#{email}>"
  end
end
