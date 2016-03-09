require 'ohm'
require 'ohm/contrib'

class BaseModel < Ohm::Model
  include Ohm::Validations

  def before_validate
    @before = true
  end

  def after_validate
    @after = true
  end

  def to_param
    id
  end
end
