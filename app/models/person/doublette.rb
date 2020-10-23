# == Schema Information
#
# Table name: person_doublets
#
#  id                   :integer          not null, primary key
#  person_1_id          :integer          not null
#  person_2_id          :integer          not null
#  ignore               :boolean          default(FALSE), not null
#

class Person::Doublette < ActiveRecord::Base

  belongs_to :person_1, class_name: 'Person'
  belongs_to :person_2, class_name: 'Person'

end
