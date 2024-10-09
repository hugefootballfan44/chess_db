DROP SEQUENCE account_account_id_seq;
DROP SEQUENCE cheater_cheater_id_seq;
DROP SEQUENCE opening_eco_seq;

DROP TABLE cheater;
DROP TABLE onlinerating;
DROP TABLE onlinewld;
DROP TABLE titledtuesday;
DROP TABLE repertoire;
DROP TABLE opening;
DROP TABLE account;

SELECT COUNT(*)
FROM titledtuesday;

SELECT *
FROM account
WHERE account_id = 1259;

UPDATE account
SET username = 'Barbus89'
WHERE account_id = 1259;

UPDATE account
SET username = 'anon6121824'
WHERE account_id = 1904;

UPDATE account
SET username = 'IMAghasiyevKamal'
WHERE account_id = 2038;

UPDATE account
SET username = 'GM4L'
WHERE account_id = 2186;

UPDATE account
SET username = 'anon05132'
WHERE account_id = 2920;

UPDATE account
SET username = 'anon97531'
WHERE account_id = 2948;
