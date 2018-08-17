class Post < ActiveRecord::Base
    belongs_to :visual
    belongs_to :user
end
