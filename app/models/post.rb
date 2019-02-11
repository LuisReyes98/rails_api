class Post < ApplicationRecord
  belongs_to :user

  validates :title , presence: true
  validates :content , presence: true
  #se hace así :published , inclusion: { in: [true,false] } por que
  #published es boolean y si fuera falso con el presence true , daria que es
  #no valido
  validates :published , inclusion: { in: [true,false] }
  validates :user_id , presence: true
end
