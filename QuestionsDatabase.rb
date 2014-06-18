require 'sqlite3'
require 'singleton'
load './reply.rb'
load './user.rb'
load './question.rb'
load './question_followers.rb'
load './question_like.rb'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
  
  def self.save(object)
    raise 'already saved!' unless object.id.nil?
    
    a = object.instance_variables
    variable_hash = Hash.new()
    a.each_with_index do |variable,idx|
      variable_hash[idx] = variable
    end
    p variable_hash
    QuestionsDatabase.instance.execute(<<-SQL, variable_hash)
    INSERT INTO
    
  
    
    SQL
  end
end




