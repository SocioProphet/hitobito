# encoding: utf-8

class People::DuplicateChecker
  def check
    Person.find_each do |person|
      doublette = person_doublette_finder.find({ first_name: person.first_name,
                                               last_name: person.last_name,
                                               company_name: person.company_name,
                                               zip_code: person.zip_code,
                                               birthday: person.birthday })
      
      next if person == doublette || doublette_already_exists?(person, doublette)

      PersonDuplicate.create!(person_1: person, person_2: doublette)
    end
  end

  private

  def person_doublette_finder
    @person_doublette_finder ||= Import::PersonDuplicateFinder.new
  end

  def doublette_already_exists?(person_1, person_2)
    PersonDuplicate.where(person_1: person_1, person_2: person_2)
      .or(PersonDuplicate.where(person_2: person_1, person_1: person_2)).any?
  end
end
