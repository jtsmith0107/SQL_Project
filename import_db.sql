CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

-- Notice that tables are always named lowercase and plural. This is a
-- convention.
CREATE TABLE questions (
  -- SQLite3 will automatically populate an integer primary key
  -- (unless it is specifically provided). The conventional primary
  -- key name is 'id'.
  id INTEGER PRIMARY KEY,
  -- NOT NULL specifies that the column must be provided. This is a
  -- useful check of the integrity of the data.
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  -- Not strictly necessary, but informs the DB not to
  --  (1) create a professor with an invalid department_id,
  --  (2) delete a department (or change its id) if professors
  --      reference it.
  -- Either event would leave the database in an invalid state, with a
  -- foreign key that doesn't point to a valid record. Older versions
  -- of SQLite3 may not enforce this, and will just ignore the foreign
  -- key constraint.
  -- FOREIGN KEY (users.id) REFERENCES questions(id)
  FOREIGN KEY (author_id) REFERENCES questions(id)
);


CREATE TABLE question_followers (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    
    FOREIGN KEY (question_id) REFERENCES question(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
      id INTEGER PRIMARY KEY,
      question_id INTEGER NOT NULL,
      parent_reply INTEGER,
      user_id INTEGER NOT NULL,
      body VARCHAR(255) NOT NULL,
      
      FOREIGN KEY (question_id) REFERENCES question(id),
      FOREIGN KEY (user_id) REFERENCES users(id),
      FOREIGN KEY (parent_reply) REFERENCES replies(id)
);
    
CREATE TABLE question_likes (
 id INTEGER PRIMARY KEY,
 user_id INTEGER NOT NULL,
 question_id   INTEGER NOT NULL, 
 FOREIGN KEY (question_id) REFERENCES question(id),
 FOREIGN KEY (user_id) REFERENCES users(id)
); 

-- In addition to creating tables, we can seed our database with some
-- starting data.
INSERT INTO
  users (fname, lname)
VALUES
  ('andre', 'tran'),
  ('taylor', 'smith');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Chicken vs Egg', 'Which came first the chicken or the egg?',
      (SELECT
       id 
      FROM 
       users 
      WHERE 
          fname = 'andre'));
          
INSERT INTO
    question_followers(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'taylor'),
    (SELECT id FROM questions WHERE title = 'Chicken vs Egg'));
    

INSERT INTO
    replies(question_id, parent_reply, user_id, body)
VALUES
    (1, NULL, 2, 'The chicken!');
    
INSERT INTO
    question_likes(user_id, question_id)
VALUES
    (2, 1); 
    

