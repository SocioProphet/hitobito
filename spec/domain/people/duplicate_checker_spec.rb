require 'spec_helper'

describe People::DuplicateChecker do

  let(:checker) { described_class.new }
  subject { checker.check }

  context 'check' do
    it 'creates one duplicate when all attributes match once' do
      create_duplicate(:top_leader)
      expect { subject }.to change { PersonDuplicate.count }.by(1)
    end

    it 'creates two duplicate when all attributes match twice' do
      create_duplicate(:top_leader)
      create_duplicate(:top_leader)
      expect { subject }.to change { PersonDuplicate.count }.by(2)
    end

    it 'creates one duplicates when names, company name, birthday match and zip code is empty' do
      create_duplicate(:top_leader).update(zip_code: nil)
      expect { subject }.to change { PersonDuplicate.count }.by(1)
    end

    it 'creates one duplicates when names, company name, zip code match and birthday is empty' do
      create_duplicate(:top_leader).update(birthday: nil)
      expect { subject }.to change { PersonDuplicate.count }.by(1)
    end

    it 'creates one duplicates when names, company name match and birthday, zip code is empty' do
      create_duplicate(:top_leader).update(birthday: nil, zip_code: nil)
      expect { subject }.to change { PersonDuplicate.count }.by(1)
    end

    it 'creates no duplicate when duplicate already exists' do
      duplicate = create_duplicate(:top_leader)
      PersonDuplicate.create(person_1: duplicate, person_2: people(:top_leader))
      expect { subject }.to_not change { PersonDuplicate.count }
    end

    it 'creates no duplicate when no attributes match' do
      expect { subject }.to_not change { PersonDuplicate.count }
    end

    it 'creates no duplicate if first_name does not match' do
      create_duplicate(:top_leader).update(first_name: 'Bottom')
      expect { subject }.to_not change { PersonDuplicate.count }
    end

    it 'creates no duplicate if last_name does not match' do
      create_duplicate(:top_leader).update(first_name: 'Member')
      expect { subject }.to_not change { PersonDuplicate.count }
    end

    it 'creates no duplicate if company_name does not match' do
      create_duplicate(:top_leader).update(company_name: 'Company')
      expect { subject }.to_not change { PersonDuplicate.count }
    end
  end

  private

  def create_duplicate(name)
    duplicate = people(name).dup
    duplicate.email = nil
    duplicate.save!
    duplicate
  end
end
