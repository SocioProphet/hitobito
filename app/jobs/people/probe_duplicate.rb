# encoding: utf-8

class People::ProbeDuplicate < RecurringJob
  run_every 1.day

  def perform
    People::DuplicateChecker.check
  end

end
