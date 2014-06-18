

class Reply
  attr_accessor :id, :question_id, :parent_reply, :user_id, :body
  
  def self.all
    results = QuestionsDatabase.instance.execute( 'SELECT * FROM replies')
    results.map {|result| Reply.new(result) }
  end
  
  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply = options['parent_reply']
    @user_id = options['user_id']
    @body = options['body']
  end
end




