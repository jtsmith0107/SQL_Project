


class Question
  attr_accessor :title, :body, :author_id, :id
  
  def self.all
    results = QuestionsDatabase.instance.execute( 'SELECT * FROM questions')
    results.map {|result| Question.new(result) }
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def create
    raise 'already saved!' unless self.id.nil?
    
    QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
    INSERT INTO
    questions (title, body, author_id)
    VALUES
      (?, ?, ?)
    
    SQL
  end 
  
  def find_by_id(question_id)
    user_hash = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
    *
    FROM 
    questions
    WHERE id = (?)
    SQL
    Question.new(user_hash.first)
  end
  
  def find_by_author_id(author_id)
    questions_hash = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
    *
    FROM 
    questions
    WHERE author_id = (?)
    SQL
    questions_hash.map {|question| Question.new(question)}
    
  end
  
  def followers
    QuestionFollower.followers_for_question_id(@id)
  end
      
end