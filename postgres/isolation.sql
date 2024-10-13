DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    balance NUMERIC(15, 2) NOT NULL
);

INSERT INTO accounts (username, balance) VALUES
('john_doe', 1500.00),
('jane_smith', 2500.50),
('alex_brown', 500.75),
('emma_white', 3200.00);

------------------------------------------------------------------------------

[Read Uncommitted. Dirty Reads]

Tx1        					Tx2

begin;
set transaction isolation level read uncommitted;
show transaction isolation level;

                    begin;
                    set transaction isolation level read uncommitted;
                    show transaction isolation level;

select * from accounts where id = 1;

                    update accounts set balance = balance - 100 where id = 1 returning *;

select * from accounts where id = 1;

                    rollback;
rollback;

------------------------------------------------------------------------------

[Read Committed. Dirty Reads]

Tx1        					Tx2

begin;
set transaction isolation level read committed;
show transaction isolation level;

                    begin;
                    set transaction isolation level read committed;
                    show transaction isolation level;

select * from accounts where id = 1;

                    update accounts set balance = balance - 100 where id = 1 returning *;

select * from accounts where id = 1;

                    commit;

select * from accounts where id = 1;

commit;

------------------------------------------------------------------------------

[Read Committed. Phantom reads]


Tx1        					Tx2

begin;
set transaction isolation level read committed;
show transaction isolation level;

                    begin;
                    set transaction isolation level read committed;
                    show transaction isolation level;

select * from accounts where balance >= 500;

                    update accounts set balance = 0 where id = 1 returning *;
                    delete from accounts where balance = 500.75;
                    commit;

select * from accounts where balance >= 500;
commit;

------------------------------------------------------------------------------

[Repeatable Read. Phantom Reads]

Tx1        					Tx2

begin;
set transaction isolation level repeatable read;
show transaction isolation level;

                    begin;
                    set transaction isolation level repeatable read;
                    show transaction isolation level;

select * from accounts where balance >= 500;

                    update accounts set balance = 0 where id = 1 returning *;
                    delete from accounts where balance = 500.75;
                    commit;

select * from accounts where balance >= 500;
update accounts set balance = 5555 where id = 1;
commit;
rollback;

------------------------------------------------------------------------------

[Write-Skew #0. Repeatable Read]

Tx1        					Tx2

begin;
set transaction isolation level repeatable read;
show transaction isolation level;

                    begin;
                    set transaction isolation level repeatable read;
                    show transaction isolation level;

select * from accounts;

                  select * from accounts;

select sum(balance) from accounts;
insert into accounts (username, balance)
values ('joe_light', 7701.25) returning *;
select * from accounts;

                  select * from accounts;
                  select sum(balance) from accounts;
                  insert into accounts (username, balance) values ('joe_dark', 7701.25) returning *;
                  select * from accounts;
                  commit;

commit;

select * from accounts;

                  select * from accounts;

------------------------------------------------------------------------------

[Write-Skew #0. Serialisable]

Tx1        					Tx2

begin;
set transaction isolation level serializable;
show transaction isolation level;

                    begin;
                    set transaction isolation level serializable;
                    show transaction isolation level;

select * from accounts;

                    select * from accounts;

select sum(balance) from accounts;
insert into accounts (username, balance)
values ('joe_light', 7701.25) returning *;
select * from accounts;

                    select * from accounts;
                    select sum(balance) from accounts;
                    insert into accounts (username, balance) values ('joe_dark', 7701.25) returning *;
                    select * from accounts;
                    commit;
commit;
rollback;

select * from accounts;

                    select * from accounts;
                                                
------------------------------------------------------------------------------
                                                
[Lost Update. Read Committed]

Tx1        					Tx2

begin;
set transaction isolation level read committed;
show transaction isolation level;

                    begin;
                    set transaction isolation level read committed;
                    show transaction isolation level;

select * from accounts where id = 1;

                    select * from accounts where id = 1;

update accounts set balance = 1500 + 7 where id = 1 returning *;

                    update accounts set balance = 1500 + 7 where id = 1 returning *;
                    commit;

commit;

------------------------------------------------------------------------------

[Lost Update. Repeatable Read]

Tx1        					Tx2

begin;
set transaction isolation level repeatable read;
show transaction isolation level;

                    begin;
                    set transaction isolation level repeatable read;
                    show transaction isolation level;

select * from accounts where id = 1;

                    select * from accounts where id = 1;

update accounts set balance = 1500 + 7 where id = 1 returning *;

                    update accounts set balance = 1500 + 7 where id = 1 returning *;
                    commit;
commit;

------------------------------------------------------------------------------

[Write-Skew #1. Repeatable Read]

DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    on_call NUMERIC NOT NULL
);
INSERT INTO doctors (username, on_call) VALUES ('alice', 1), ('bob', 1);

Tx1        					Tx2

begin;
set transaction isolation level repeatable read;
show transaction isolation level;

                    begin;
                    set transaction isolation level repeatable read;
                    show transaction isolation level;

– x :=
select * from doctors where on_call = 1;

                    select * from doctors where on_call = 1;

– if x >= 0 then
update doctors set on_call = 0 where username = 'alice' returning *;

                    – if x >= 0 then
                      update doctors set on_call = 0 
                      where username = 'bob' returning *;
                      commit;

commit;
select * from doctors;

------------------------------------------------------------------------------

[Write-Skew #1. Serializable]

DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    on_call NUMERIC NOT NULL
);
INSERT INTO doctors (username, on_call) VALUES ('alice', 1), ('bob', 1);

Tx1        					Tx2

begin;
set transaction isolation level serializable;
show transaction isolation level;

                    begin;
                    set transaction isolation level serializable;
                    show transaction isolation level;

– x :=
select * from doctors where on_call = 1;

                    select * from doctors where on_call = 1;

– if x >= 0 then
update doctors set on_call = 0 
where username = 'alice' returning *;

                    – if x >= 0 then
                      update doctors set on_call = 0 
                      where username = 'bob' returning *;
                      commit;

commit; – error

select * from doctors;

------------------------------------------------------------------------------

[Write-Skew #2. Repeatable Read]

DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    on_call NUMERIC NOT NULL
);
INSERT INTO doctors (username, on_call) VALUES ('alice', 1), ('bob', 1);

Tx1        					Tx2

begin;
set transaction isolation level repeatable read;
show transaction isolation level;

                    begin;
                    set transaction isolation level repeatable read;
                    show transaction isolation level;

select * from doctors where username = 'alice';

                    select * from doctors where username = 'bob';

update doctors set on_call = 0 where username = 'bob' returning *;

                    update doctors set on_call = 0 where username = 'alice' returning *;
                    commit;

commit;

select * from doctors;

------------------------------------------------------------------------------

[Write-Skew #2. Serializable]

DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    on_call NUMERIC NOT NULL
);
INSERT INTO doctors (username, on_call) VALUES ('alice', 1), ('bob', 1);

Tx1        					Tx2

begin;
set transaction isolation level serializable;
show transaction isolation level;

                    begin;
                    set transaction isolation level serializable;
                    show transaction isolation level;

select * from doctors where username = 'alice';

                    select * from doctors where username = 'bob';

update doctors set on_call = 0 where username = 'bob' returning *;

                    update doctors set on_call = 0 where username = 'alice' returning *;
                    commit;

commit; – error

select * from doctors;

------------------------------------------------------------------------------

[Write-Skew #2. Serializable failed]

DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    on_call NUMERIC NOT NULL
);
INSERT INTO doctors (username, on_call) VALUES ('alice', 1), ('bob', 1);

Tx1        					Tx2

begin;
set transaction isolation level serializable;
show transaction isolation level;

                    begin;
                    set transaction isolation level serializable;
                    show transaction isolation level;

select * from doctors where username = 'alice';
update doctors set on_call = 0 where username = 'bob' returning *;
commit; – ok

                    select * from doctors where username = 'bob';
                    update doctors set on_call = 0 where username = 'alice' returning *;
                    commit; – ok

select * from doctors;

SSI thinks that two transactions run in parallel in a sequential manner, like one after another. From the database perspective that’s totally okay. But that behaviour can be an issue from the business logic perspective.

------------------------------------------------------------------------------

[Read-Skew. Repeatable Read]

DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS batches;
CREATE TABLE receipts (
    id SERIAL PRIMARY KEY,
    batch_num NUMERIC NOT NULL,
    amount NUMERIC NOT NULL
);
CREATE TABLE batches (
    id SERIAL PRIMARY KEY,
    batch_num NUMERIC NOT NULL
);
INSERT INTO receipts (batch_num, amount) VALUES (1, 100), (2, 100), (3, 100);
INSERT INTO batches (batch_num) VALUES (4);

Tx1        			Tx2						Tx3

begin;
set transaction isolation
level repeatable read;
show transaction isolation level;

                begin;
                set transaction isolation 
                level repeatable read;
                show transaction isolation level;

                              begin;
                              set transaction isolation 
                              level repeatable read;
                              show transaction isolation level;

– x := 4
select batch_num from batches
order by batch_num desc
limit 1;

                insert into batches (batch_num) values (5);
                commit;
                              – x := 5
                              select batch_num from batches
                              order by batch_num desc
                              limit 1;
                              select sum(amount) from receipts where batch_num <= 5 - 1; – 300
                              commit;

insert into receipts (batch_num, amount) values (4, 7);
commit;
                              select sum(amount) from receipts where batch_num <= 5 - 1; – 307

------------------------------------------------------------------------------

[Read-Skew. Serializable]

DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS batches;
CREATE TABLE receipts (
    id SERIAL PRIMARY KEY,
    batch_num NUMERIC NOT NULL,
    amount NUMERIC NOT NULL
);
CREATE TABLE batches (
    id SERIAL PRIMARY KEY,
    batch_num NUMERIC NOT NULL
);
INSERT INTO receipts (batch_num, amount) VALUES (1, 100), (2, 100), (3, 100);
INSERT INTO batches (batch_num) VALUES (4);

Tx1        			Tx2						Tx3

begin;
set transaction isolation
level serializable;
show transaction isolation 
level;

                begin;
                set transaction isolation 
                level serializable;
                show transaction isolation level;

                                begin;
                                set transaction isolation 
                                level serializable;
                                show transaction isolation level;
– x := 4
select batch_num from batches
order by batch_num desc
limit 1;

                insert into batches (batch_num) values (5);
                commit;

                                – x := 5
                                select batch_num from batches
                                order by batch_num desc limit 1;
                                select sum(amount) from receipts where batch_num <= 5 - 1; – 300
                                commit;

insert into receipts (batch_num, amount) values (4, 7);
commit; – error

                                select sum(amount) from receipts where batch_num <= 5 - 1; – 307
