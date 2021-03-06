\set VERBOSITY terse
SET client_encoding = utf8;

--
-- test type modifier related rules
--

-- ERROR (typmod >= 1)
CREATE TABLE bar (a NVARCHAR2(0));

-- ERROR (number of typmods = 1)
CREATE TABLE bar (a NVARCHAR2(10, 1));

-- OK
CREATE TABLE bar (a VARCHAR(5000));

CREATE INDEX ON bar(a);

-- cleanup
DROP TABLE bar;

-- OK
CREATE TABLE bar (a NVARCHAR2(5));

--
-- test that no value longer than maxlen is allowed
--

-- ERROR (length > 5)
INSERT INTO bar VALUES ('abcdef');

-- ERROR (length > 5);
-- NVARCHAR2 does not truncate blank spaces on implicit coercion
INSERT INTO bar VALUES ('abcde  ');

-- OK
INSERT INTO bar VALUES ('abcde');

-- OK
INSERT INTO bar VALUES ('abcdef'::NVARCHAR2(5));

-- OK
INSERT INTO bar VALUES ('abcde  '::NVARCHAR2(5));

--OK
INSERT INTO bar VALUES ('abc'::NVARCHAR2(5));

--
-- test whitespace semantics on comparison
--

-- equal
SELECT 'abcde   '::NVARCHAR2(10) = 'abcde   '::NVARCHAR2(10);

-- not equal
SELECT 'abcde  '::NVARCHAR2(10) = 'abcde   '::NVARCHAR2(10);


