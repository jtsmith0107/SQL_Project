

class QuestionFollower
  attr_accessor :id, :question_id, :user_id
  
  def self.all
    results = QuestionsDatabase.instance.execute( 'SELECT * FROM question_followers')
    results.map {|result| QuestionFollower.new(result) }
  end
  
  def create
    raise 'already saved!' unless self.id.nil?
    
    QuestionsDatabase.instance.execute(<<-SQL, user_id, question_id)
    INSERT INTO
    question_followers (user_id, question_id)
    VALUES
      (?, ?)
    
    SQL
  end 
  
  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.followers_for_question_id(question_id)
    followers_hash = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      u.*
    FROM
      users u JOIN question_followers q ON q.user_id = u.id
    WHERE 
      q.question_id = (?)
    SQL
    followers_hash.map {|follower| User.new(follower)}    
  end
  
  def self.followed_questions_for_user_id(user_id)
    questions_hash = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      q.*
    FROM
      questions q JOIN question_followers qf ON qf.question_id = q.id
    WHERE 
      qf.user_id = (?)
    SQL
    questions_hash.map {|question| Question.new(question)} 
    
  end
  
  def self.most_followed_questions(n)
    questions_hash = QuestionsDatabase.instance.execute(<<-SQL)
   
    SELECT
      q.*, COUNT(qf.question_id)
    FROM
      questions q JOIN question_followers qf ON qf.question_id = q.id
    GROUP BY qf.question_id
    ORDER BY COUNT(qf.question_id) DESC
    
    SQL
     
    questions_hash.take(n).map {|question| Question.new(question)}   
  end
end