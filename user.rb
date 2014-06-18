

class User
  attr_accessor :id, :fname, :lname
  
  def self.all
    results = QuestionsDatabase.instance.execute( 'SELECT * FROM users')
    results.map {|result| User.new(result) }
  end
  
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def create
    raise 'already saved!' unless self.id.nil?
    
    QuestionsDatabase.instance.execute(<<-SQL, ['fname' => 'charles', 'lname' => 'darwin'])
    INSERT INTO
      users
    VALUES
      (?)
    
    SQL
  end
  
  def self.find_by_id(user_id)
    user_hash = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
    *
    FROM 
    users
    WHERE id = (?)
    SQL
    User.new(user_hash.first)
  end
  
  def self.find_by_name(fname, lname)    
    name_hash = QuestionDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
    *
    FROM 
    users
    WHERE users.fname = (?) AND users.lname = (?)
    SQL
    User.new(name_hash.first)
  end
  
  def authored_questions
    questions_hash = QuestionDatabase.instance.execute(<<-SQL, @id)
    SELECT 
      *
    FROM
      questions
    WHERE 
      author_id = (?)
    SQL
    questions_hash.map {|question| Question.new(question)}
  end
  
  def authored_replies
    reply_hash = QuestionDatabase.instance.execute(<<-SQL, @id)
    SELECT 
      *
    FROM
      replies
    WHERE 
      user_id = (?)
    SQL
    reply_hash.map {|reply| Reply.new(reply)}
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
  
  def average_karma
    karma_count = QuestionsDatabase.instance.execute(<<-SQL, @id)
   SELECT AVG(count) 
   FROM 
   (SELECT 
     CASE WHEN 
       questions.id IS NULL 
     THEN 0 
     ELSE 
       COUNT(question_likes.question_id)
     END AS count 
     FROM 
     questions 
     LEFT JOIN question_likes ON questions.id = question_likes.question_id 
     WHERE questions.author_id = (?)
     GROUP BY questions.id)
    SQL
    p karma_count
    if karma_count.first.values.first.nil?
      return 0
    else
      karma_count.first.values.first
    end
  end
    
end