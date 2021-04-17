DROP CONSTRAINT ON (u:Users) ASSERT EXISTS (u.username);

DROP CONSTRAINT ON (m:Message) ASSERT m.messageID IS UNIQUE;

DROP CONSTRAINT ON (c:Comments) ASSERT c.commentID IS UNIQUE;

match (p) detach delete p