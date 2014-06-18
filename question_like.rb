

class QuestionLike
  attr_accessor :id, :question_id, :user_id  
  
  def self.likers_for_question_id(question_id)
    users_hash = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      u.*
    FROM
      users u JOIN question_likes q ON q.user_id = u.id
    WHERE 
      q.question_id = (?)
    GROUP BY q.question_id
    SQL
    users_hash.map {|user| User.new(user)}   
  end
  
  def self.num_likes_for_question_id(question_id)
    count_hash = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(q.user_id)
    FROM
      users u JOIN question_likes q ON q.user_id = u.id
    WHERE 
      q.question_id = (?)
    GROUP BY q.question_id
    SQL
    if count_hash.empty?
      return 0
    else
      count_hash.first.values.first
    end
  end
  
  def self.most_liked_questions(n)
    questions_hash = QuestionsDatabase.instance.execute(<<-SQL)
   SELECT
    *
   FROM 
      question_likes 
    LEFT JOIN  questions ON questions.id = question_likes.question_id 
    GROUP BY questions.id
    ORDER BY COUNT(question_likes.question_id) DESC
    SQL
    
    questions_hash.take(n).map {|question| Question.new(question)}
  end
  
  def initialize(options ={})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def create
    raise 'already saved!' unless self.id.nil?
    
    QuestionsDatabase.instance.execute(<<-SQL, user_id, question_id)
    INSERT INTO
    question_likes (user_id, question_id)
    VALUES
      (?, ?)    
    SQL
  end   
  
end