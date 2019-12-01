# start with a clean slate, delete existing database
#-------------------------------------------------------

DROP DATABASE IF EXISTS SpanishQuiz;

# create database
#-------------------------------------------------------

CREATE DATABASE SpanishQuiz;
USE SpanishQuiz;

# create tables
#-------------------------------------------------------

# note decided to use ids as primary keys for tables, this makes code for inserting into 
# the tables very difficult to read, but has the benifit of not having to deal with issues 
# when using strings as primary keys (casing ect.). In the real world, I'm assuming data entry
# would happen via a form or some automated method.

CREATE TABLE SpanishQuiz.`type` (
  type_id 		INT 								PRIMARY KEY		AUTO_INCREMENT,
  type_endings 	ENUM('ar', 'er', 'ir', 'irregular') NOT NULL 		UNIQUE
);

CREATE TABLE SpanishQuiz.verb (
  verb_id 			INT 		PRIMARY KEY		AUTO_INCREMENT,
  verb_infinitive 	VARCHAR(45) NOT NULL		UNIQUE,
  verb_beginning 	VARCHAR(45) DEFAULT NULL,
  type_id 			INT 		NOT NULL,
  
  CONSTRAINT fk_type_id FOREIGN KEY (type_id) REFERENCES SpanishQuiz.`type` (type_id)
);

CREATE TABLE SpanishQuiz.person (
	person_id	INT																PRIMARY KEY		AUTO_INCREMENT,
    person 		ENUM('yo', 'tú', 'él/ella/Ud.', 'nosotros', 'ellos/ellas/Uds.')	NOT NULL		UNIQUE
);

CREATE TABLE SpanishQuiz.tense (
	tense_id	INT		PRIMARY KEY		AUTO_INCREMENT,
	tense ENUM('present', 'preterite', 'future') NOT NULL	UNIQUE
);

CREATE TABLE SpanishQuiz.conjugation (
	conjugation_id	INT		PRIMARY KEY		AUTO_INCREMENT,
	person_id 		INT 	NOT NULL,
	tense_id		INT 	NOT NULL,

	CONSTRAINT UNIQUE (person_id, tense_id),
	CONSTRAINT fk_conjugation_person_id FOREIGN KEY (person_id) REFERENCES SpanishQuiz.person (person_id),
	CONSTRAINT fk_conjugation_tense_id FOREIGN KEY (tense_id) REFERENCES SpanishQuiz.tense (tense_id)
);

CREATE TABLE SpanishQuiz.verbConjugation (
	verbConjugation_id 		INT			PRIMARY KEY		AUTO_INCREMENT,
	verbConjugation_finite 	VARCHAR(45) NOT NULL,
	conjugation_id 			INT 		NOT NULL,
	verb_id 				INT 		NOT NULL,
    
	CONSTRAINT UNIQUE (verbConjugation_finite, conjugation_id, verb_id),
	CONSTRAINT fk_verbConjugation_verb FOREIGN KEY (verb_id) REFERENCES SpanishQuiz.verb (verb_id),
	CONSTRAINT fk_verbConjugation_conjugation FOREIGN KEY (conjugation_id) REFERENCES SpanishQuiz.conjugation (conjugation_id)
);

CREATE TABLE SpanishQuiz.sentence (
	sentence_id 		INT				PRIMARY KEY		AUTO_INCREMENT,
	sentence_text 		VARCHAR(1000)	NOT NULL		UNIQUE,
	verbConjugation_id 	INT 			NOT NULL,
	
	CONSTRAINT fk_sentence_verbConjugation FOREIGN KEY (verbConjugation_id) REFERENCES SpanishQuiz.verbConjugation (verbConjugation_id)
);

CREATE TABLE IF NOT EXISTS SpanishQuiz.typeConjugation (
	typeConjugation_id 		INT			PRIMARY KEY		AUTO_INCREMENT,
	typeConjugation_finite 	VARCHAR(45) NOT NULL,
	conjugation_id 			INT 		NOT NULL,
	type_id 					INT 		NOT NULL,

	CONSTRAINT UNIQUE (typeConjugation_finite, conjugation_id, type_id),	
	CONSTRAINT fk_typeConjugation_type FOREIGN KEY (type_id) REFERENCES SpanishQuiz.type (type_id),
	CONSTRAINT fk_typeConjugation_conjugation1 FOREIGN KEY (conjugation_id) REFERENCES SpanishQuiz.conjugation (conjugation_id)
	  
  );

# create indicies
#-------------------------------------------------------

# tense and person will be fequently used to display quesitons and hints to user, so benefical to keep index for them
CREATE INDEX tenseIndex
ON tense (tense);

CREATE INDEX personIndex
ON person (person);

# add sample data

#-------------------------------------------------------
INSERT INTO `type` (type_id, type_endings)
VALUES
	(DEFAULT, 'ar'),
    (DEFAULT, 'er'),
    (DEFAULT, 'ir'),
    (DEFAULT, 'irregular');
    
INSERT INTO verb (verb_id, verb_infinitive, verb_beginning, type_id)
VALUES
	(DEFAULT, 'hablar', 'habl', 1),
    (DEFAULT, 'comer', 'com', 2),
    (DEFAULT, 'vivir', 'viv', 3),
    (DEFAULT, 'dormir', DEFAULT, 4);
    
INSERT INTO person (person_id, person)
VALUES 
	(DEFAULT, 'yo'),
    (DEFAULT, 'tu'),
    (DEFAULT, 'él/ella/Ud.'),
    (DEFAULT, 'nosotros'),
    (DEFAULT, 'ellos/ellas/Uds.');	

INSERT INTO tense (tense_id, tense)
VALUES
	(DEFAULT, 'present'),
    (DEFAULT, 'preterite'),
    (DEFAULT, 'future');

INSERT INTO conjugation (conjugation_id, person_id, tense_id)
VALUES
	(DEFAULT, 1, 1),
    (DEFAULT, 2, 1),
    (DEFAULT, 3, 1),
    (DEFAULT, 4, 1),
    (DEFAULT, 5, 1),
	(DEFAULT, 1, 2),
    (DEFAULT, 2, 2),
    (DEFAULT, 3, 2),
    (DEFAULT, 4, 2),
    (DEFAULT, 5, 2),
	(DEFAULT, 1, 3),
    (DEFAULT, 2, 3),
    (DEFAULT, 3, 3),
    (DEFAULT, 4, 3),
    (DEFAULT, 5, 3);

INSERT INTO verbConjugation (verbConjugation_id, verbConjugation_finite, conjugation_id, verb_id)
VALUES
	(DEFAULT, 'hablo', 1, 1),
    (DEFAULT, 'hablas', 2, 1),
	(DEFAULT, 'habla', 3, 1),
    (DEFAULT, 'hablamos', 4, 1),
	(DEFAULT, 'hablan', 5, 1),
    
    (DEFAULT, 'hablé', 6, 1),
	(DEFAULT, 'hablaste', 7, 1),
    (DEFAULT, 'habló', 8, 1),
    (DEFAULT, 'hablamos', 9, 1),
    (DEFAULT, 'hablaron', 10, 1),
    
	(DEFAULT, 'hablaré', 11, 1),
	(DEFAULT, 'hablarás', 12, 1),
    (DEFAULT, 'hablará', 13, 1),
    (DEFAULT, 'hablaremos', 14, 1),
    (DEFAULT, 'hablarán', 15, 1),
    
	(DEFAULT, 'como', 1, 2),
    (DEFAULT, 'comes', 2, 2),
	(DEFAULT, 'come', 3, 2),
    (DEFAULT, 'comemos', 4, 2),
	(DEFAULT, 'comen', 5, 2),
    
    (DEFAULT, 'comí', 6, 2),
	(DEFAULT, 'comiste', 7, 2),
    (DEFAULT, 'comió', 8, 2),
    (DEFAULT, 'comimos', 9, 2),
    (DEFAULT, 'comieron', 10, 2),
    
	(DEFAULT, 'comeré', 11, 2),
	(DEFAULT, 'comerás', 12, 2),
    (DEFAULT, 'comerá', 13, 2),
    (DEFAULT, 'comeremos', 14, 2),
    (DEFAULT, 'comerán', 15, 2),
    
	(DEFAULT, 'vivo', 1, 3),
    (DEFAULT, 'vives', 2, 3),
	(DEFAULT, 'vove', 3, 3),
    (DEFAULT, 'vivimos', 4, 3),
	(DEFAULT, 'viven', 5, 3),
    
    (DEFAULT, 'viví', 6, 3),
	(DEFAULT, 'viviste', 7, 3),
    (DEFAULT, 'vivió', 8, 3),
    (DEFAULT, 'vivimos', 9, 3),
    (DEFAULT, 'vivieron', 10, 3),
    
	(DEFAULT, 'viviré', 11, 3),
	(DEFAULT, 'vivirás', 12, 3),
    (DEFAULT, 'vivirá', 13, 3),
    (DEFAULT, 'viviremos', 14, 3),
    (DEFAULT, 'vivirán', 15, 3),
    
	(DEFAULT, 'duermo', 1, 4),
    (DEFAULT, 'duermes', 2, 4),
	(DEFAULT, 'duerme', 3, 4),
    (DEFAULT, 'dormimos', 4, 4),
	(DEFAULT, 'duermen', 5, 4),
    
    (DEFAULT, 'dormí', 6, 4),
	(DEFAULT, 'dormiste', 7, 4),
    (DEFAULT, 'durmió', 8, 4),
    (DEFAULT, 'dormimos', 9, 4),
    (DEFAULT, 'durmieron', 10, 4),
    
	(DEFAULT, 'dormiré', 11, 4),
	(DEFAULT, 'dormirás', 12, 4),
    (DEFAULT, 'dormirá', 13, 4),
    (DEFAULT, 'dormiremos', 14, 4),
    (DEFAULT, 'dormirán', 15, 4);

INSERT INTO typeConjugation (typeConjugation_id, typeConjugation_finite, conjugation_id, type_id)
VALUES
	(DEFAULT, 'o', 1, 1),
    (DEFAULT, 'as', 2, 1),
	(DEFAULT, 'a', 3, 1),
    (DEFAULT, 'amos', 4, 1),
	(DEFAULT, 'an', 5, 1),
    
    (DEFAULT, 'é', 6, 1),
	(DEFAULT, 'aste', 7, 1),
    (DEFAULT, 'ó', 8, 1),
    (DEFAULT, 'amos', 9, 1),
    (DEFAULT, 'aron', 10, 1),
    
	(DEFAULT, 'é', 11, 1),
	(DEFAULT, 'ás', 12, 1),
    (DEFAULT, 'á', 13, 1),
    (DEFAULT, 'emos', 14, 1),
    (DEFAULT, 'án', 15, 1),
    
	(DEFAULT, 'o', 1, 2),
    (DEFAULT, 'es', 2, 2),
	(DEFAULT, 'e', 3, 2),
    (DEFAULT, 'emos', 4, 2),
	(DEFAULT, 'en', 5, 2),
    
    (DEFAULT, 'í', 6, 2),
	(DEFAULT, 'iste', 7, 2),
    (DEFAULT, 'ió', 8, 2),
    (DEFAULT, 'imos', 9, 2),
    (DEFAULT, 'eron', 10, 2),
    
	(DEFAULT, 'é', 11, 2),
	(DEFAULT, 'ás', 12, 2),
    (DEFAULT, 'á', 13, 2),
    (DEFAULT, 'emos', 14, 2),
    (DEFAULT, 'án', 15, 2),
    
	(DEFAULT, 'o', 1, 3),
    (DEFAULT, 'es', 2, 3),
	(DEFAULT, 'e', 3, 3),
    (DEFAULT, 'imos', 4, 3),
	(DEFAULT, 'en', 5, 3),
    
    (DEFAULT, 'í', 6, 3),
	(DEFAULT, 'iste', 7, 3),
    (DEFAULT, 'ió', 8, 3),
    (DEFAULT, 'imos', 9, 3),
    (DEFAULT, 'ieron', 10, 3),
    
	(DEFAULT, 'é', 11, 3),
	(DEFAULT, 'ás', 12, 3),
    (DEFAULT, 'á', 13, 3),
    (DEFAULT, 'emos', 14, 3),
    (DEFAULT, 'án', 15, 3);

INSERT INTO sentence (sentence_id, sentence_text, verbConjugation_id)
VALUES
	(DEFAULT, 'Yo __________ con ella.', 1),
    (DEFAULT, 'Ayer, María __________ una torta para almuerzo.', 23),
    (DEFAULT, 'Estan moviendo, y en una semana, ellos __________ en Seattle, WA.', 45),
	(DEFAULT, 'Cuando estábamos cansados durante las vacaciones __________ en el hotel.', 40);

# create views
#-------------------------------------------------------

# make quizQuestion view to show quiz questions to user
# use case is to make showing quiz quesitons a simple matter of querying one view
CREATE VIEW quizQuestion
AS
	SELECT sentence_id, sentence_text, verb_infinitive, tense, person
    FROM sentence 
		JOIN verbConjugation ON sentence.verbConjugation_id = verbConjugation.verbConjugation_id
		JOIN verb ON verbConjugation.verb_id = verb.verb_id
        JOIN conjugation ON verbConjugation.conjugation_id = conjugation.conjugation_id
        JOIN tense ON conjugation.tense_id = tense.tense_id
        JOIN person ON conjugation.person_id = person.person_id
	ORDER BY sentence_text, verb_infinitive, tense, person;

# make hint view to show standard conjugation endings for regular Spanish verb
# use case is providing hints to users during quiz
CREATE VIEW hint
AS
	SELECT conjugation.conjugation_id, type_endings, tense, person, typeConjugation_finite
    FROM conjugation
		JOIN typeConjugation ON typeConjugation.conjugation_id = conjugation.conjugation_id
		JOIN `type` ON `type`.type_id = typeConjugation.type_id
        JOIN tense ON conjugation.tense_id = tense.tense_id
        JOIN person ON person.person_id = conjugation.person_id
	ORDER BY type_endings, tense, person, typeConjugation_finite;

# test queries
#-------------------------------------------------------

# show quiz question
SELECT*
FROM quizQuestion
WHERE sentence_id = 1; 


# show tense hint to user (i.e. typical conjugations for the regular verb for all persons in the relevant tense)
SELECT*
FROM hint
WHERE type_endings = 'ar' AND tense = 'present';
  
# show quiz solution
SELECT verbConjugation_finite
FROM sentence
	JOIN verbConjugation ON sentence.verbConjugation_id = verbConjugation.verbConjugation_id
WHERE sentence_id = 1;

# show conjugation info to user (i.e. all conjugations a given verb for each each tense and person combo)
# show quiz solution
SELECT 	tense,
		person,
        verbConjugation_finite
FROM verbConjugation
	JOIN conjugation ON conjugation.conjugation_id = verbConjugation.conjugation_id
	JOIN tense ON tense.tense_id = conjugation.tense_id 
    JOIN person ON person.person_id = conjugation.person_id
WHERE verb_id = 1;
*/