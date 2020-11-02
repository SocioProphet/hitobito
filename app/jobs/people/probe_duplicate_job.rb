# encoding: utf-8

class People::ProbeDuplicateJob < RecurringJob
  run_every 1.day

  def perform
    People::DuplicateChecker.check
  end

end
