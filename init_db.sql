-- Script for database initialization 

CREATE TABLE authors(
  id        SERIAL
, firstname VARCHAR(80)
, lastname  VARCHAR(80)
, CONSTRAINT pk_authors PRIMARY KEY (id)
);

CREATE TABLE posts(
  id        SERIAL
, title     VARCHAR(80)
, content   TEXT
, author_id INTEGER
, CONSTRAINT pk_posts PRIMARY KEY (id)
, CONSTRAINT fk_posts_author FOREIGN KEY (author_id) REFERENCES authors (id)
);

CREATE TABLE comments(
  id        SERIAL
, content   TEXT
, post_id   INTEGER
, author_id INTEGER
, CONSTRAINT pk_comments PRIMARY KEY (id)
, CONSTRAINT fk_comments_post   FOREIGN KEY (post_id)   REFERENCES posts (id)
, CONSTRAINT fk_comments_author FOREIGN KEY (author_id) REFERENCES authors (id)
);

DO LANGUAGE plpgsql $$
DECLARE
  nr_authors  INTEGER := 1000;
  nr_posts    INTEGER := 10000;
  nr_comments INTEGER := 100000;
  author_ids  INTEGER[];
  post_ids    INTEGER[];
BEGIN
  -- Create random Authors
  WITH create_authors
  AS ( INSERT INTO authors(firstname, lastname)
       SELECT md5(random()::TEXT) AS firstname
       ,      md5(random()::TEXT) AS lastname
       FROM   generate_series(1, nr_authors)
       RETURNING id
     )
  SELECT array_agg(id) INTO author_ids
  FROM   create_authors;

  -- Create random Posts
  WITH create_posts
  AS ( INSERT INTO posts(title, content, author_id)
       SELECT md5(random()::TEXT) AS title
       ,      md5(random()::TEXT) AS content
       ,      author_ids[TRUNC(random() * (array_length(author_ids, 1) - 1) + 1)] AS author_id
       FROM   generate_series(1, nr_posts)
       RETURNING id
     )
  SELECT array_agg(id) INTO post_ids
  FROM   create_posts
  ;

  -- Create random Comments
  INSERT INTO comments(content, post_id, author_id)
  SELECT md5(random()::TEXT) AS content
  ,      post_ids[TRUNC(random() * (array_length(post_ids, 1) - 1) + 1)] AS post_id
  ,      author_ids[TRUNC(random() * (array_length(author_ids, 1) - 1) + 1)] AS author_id
  FROM   generate_series(1, nr_comments);
END;
$$;


CREATE INDEX fk_idx_posts_author ON posts(author_id);
CREATE INDEX fk_idx_comments_post ON comments(post_id);
CREATE INDEX fk_idx_comments_author ON comments(author_id);

VACUUM FULL ANALYZE authors;
VACUUM FULL ANALYZE posts;
VACUUM FULL ANALYZE comments;
