// Create Users
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/georgexam/Neo4j-Askhsh1/main/Homework2/data/Users.csv' AS row
MERGE (users:Users {username: row.username})
  	ON CREATE SET users.firstName= row.firstName,
		users.lastName= row.lastName,
		users.sex= row.sex,
		users.city= row.city,
		users.nationality= row.nationality;
		
// Create Message
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/georgexam/Neo4j-Askhsh1/main/Homework2/data/Message.csv' AS row
MERGE (message:Message {messageID: row.messageID})
  	ON CREATE SET message.messageOwner = row.messageOwner, 
	  	message.messageContent = row.messageContent, 
	  	message.date= row.date;
		
// Create Comments
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/georgexam/Neo4j-Askhsh1/main/Homework2/data/Comments.csv' AS row
MERGE (comments:Comments {commentID: row.commentID})
	ON CREATE SET comments.commentOwner = row.commentOwner,
  		comments.messageID = row.messageID,
  		comments.messageOwner = row.messageOwner,
  		comments.commentContent = row.commentContent,
  		comments.date = row.date;

// 1. importing username as constraint
CREATE CONSTRAINT username ON (u:Users) ASSERT EXISTS (u.username);
// 3. messageID are unique constraint
CREATE CONSTRAINT messageID ON (m:Message) ASSERT m.messageID IS UNIQUE;
// commentID are unique constraint
CREATE CONSTRAINT commentID ON (c:Comments) ASSERT c.commentID IS UNIQUE;
CALL db.awaitIndexes(); 

// 2. create FRIENDSHIP of Manos and George date("2019-05-02") 
MATCH (user1:Users {firstName: "Manos"})
MATCH (user2:Users {firstName: "George"})
MERGE (user1)-[:FRIENDSHIP{date:date("2019-05-02")}]->(user2)-[:FRIENDSHIP{date:date("2019-05-02")}]->(user1);

// Create relationships between Users and Messages
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/georgexam/Neo4j-Askhsh1/main/Homework2/data/Message.csv' AS row
MATCH (message:Message {messageID: row.messageID})
MATCH (users:Users {username: row.messageOwner})
MERGE (users)-[op:MessageOwner]->(message);

// Create relationships between Messages and Comments and users
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/georgexam/Neo4j-Askhsh1/main/Homework2/data/Comments.csv' AS row
MATCH (comment:Comments {commentID: row.commentID})
MATCH (message:Message {messageOwner: row.messageOwner,
						messageID: row.messageID})
MATCH (user:Users {username: row.commentOwner})
MERGE (message)-[op:MessageCommented]->(comment)<-[t:CommentOwner]-(user);

// Create likes between Users and Messages
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/georgexam/Neo4j-Askhsh1/main/Homework2/data/Likes.csv' AS row
MATCH (message:Message {messageID: row.messageID,
						messageOwner: row.messageOwner})
MATCH (users:Users {username: row.user})
MERGE (users)-[op:LIKES]->(message);
