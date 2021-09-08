
--tables
--down script
if exists (select * from INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    where CONSTRAINT_NAME = 'fk_team_honors_team_id')
    alter table team_honors drop fk_team_honors_team_id
GO
if exists (select * from INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    where CONSTRAINT_NAME = 'fk_transfer_requests_request_type_id')
    alter table transfer_requests drop fk_transfer_requests_request_type_id
GO
if exists (select * from INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    where CONSTRAINT_NAME = 'fk_transfer_requests_request_for_player_id')
    alter table transfer_requests drop fk_transfer_requests_request_for_player_id
GO
if exists (select * from INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    where CONSTRAINT_NAME = 'fk_transfer_requests_request_by_team_id')
    alter table transfer_requests drop fk_transfer_requests_request_by_team_id
GO
if exists (select * from INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    where CONSTRAINT_NAME = 'fk_managers_manager_team_id')
    alter table managers drop fk_managers_manager_team_id
GO
if exists (select * from INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    where CONSTRAINT_NAME = 'fk_players_player_position_id')
    alter table players drop fk_players_player_position_id
GO
if exists (select * from INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    where CONSTRAINT_NAME = 'fk_players_player_team_id')
    alter table players drop fk_players_player_team_id
GO
drop table if exists team_honors
GO
drop table if exists player_positions
GO
drop table if exists bid_types
GO
drop table if exists teams
GO
drop table if exists transfer_requests
GO
drop table if exists managers
GO
drop table if exists players
GO

--up script
create table players (
    player_id int IDENTITY not NULL,
    player_firstname varchar(50) not NULL,
    player_lastname varchar(50) not NULL,
    player_age int not NULL,
    player_team_id int not NULL,
    player_position_id int not null,
    player_value money not NULL,
    player_nationality varchar(15) not NULL,
    constraint pk_players_player_id primary key(player_id)
)

GO



create table managers (
    manager_id int IDENTITY not NULL,
    manager_firstname varchar(50) not NULL,
    manager_lastname varchar(50) not NULL,
    manager_age int not NULL,
    manager_team_id int not NULL,
    manager_nationality varchar(15) not NULL 
    constraint pk_managers_manager_id primary key(manager_id)
)

GO


create table transfer_requests (
    request_id int IDENTITY not null,
    request_by_team_id int not NULL,
    request_for_player_id int not null,
    request_amount money not null,
    request_type_id int not null,
    request_status varchar(10) null,
    request_approved_date date null,
    request_approved_by_manager_id int null,
    constraint pk_transfer_requests_request_id primary key (request_id)
)

GO


create table teams (
    team_id int IDENTITY not null,
    team_name varchar(20) not null,
    team_abbr char(3) not NULL,
    team_transfer_budget_in_millions money not null,
    constraint pk_teams_team_id primary key (team_id)
)

create table bid_types (
    bid_type_id int IDENTITY not null,
    bid_type varchar(20) not null,
    bid_type_duration varchar(20) not null,
    constraint lookup_bid_types_bid_type_id primary key (bid_type_id)
)

create table player_positions (
    position_id int IDENTITY not null,
    position_name varchar(20) not null,
    position_abbr varchar(3) not null,
    constraint lookup_player_positions_position_id primary key (position_id)
)
create table team_honors(
    team_id int not null,
    team_name varchar(20) not null,
    La_liga int null,
    Copa_del_Rey int null,
    Supercopa_de_Espana int null,
    Premier_League int null,
    FA_Cup int null,
    Bundesliga int null,
    DFB_Pokal int NULL,
    UEFA_Champions_League int not null,
    UEFA_super_Cup int not null,
    FIFA_club_world_cup int NOT NULL
)




GO

--foreign keys


GO
alter table players
    add constraint fk_players_player_team_id foreign key (player_team_id)
            references teams(team_id)
GO
alter table players
    add constraint fk_players_player_position_id foreign key (player_position_id)
            references player_positions (position_id)
GO
alter table managers
    add constraint fk_managers_manager_team_id foreign key (manager_team_id)
            references teams(team_id)
GO
alter table transfer_requests
    add constraint fk_transfer_requests_request_by_team_id foreign key (request_by_team_id)
            references teams(team_id),
        constraint fk_transfer_requests_request_for_player_id foreign key (request_for_player_id)
            references players(player_id),
        constraint fk_transfer_requests_request_type_id foreign key (request_type_id)
            references bid_types(bid_type_id)
GO
alter table team_honors
    add constraint fk_team_honors_team_id foreign key (team_id)
            references teams(team_id)
GO


-- inserting data

begin transaction 
insert into teams (team_name, team_abbr, team_transfer_budget_in_millions)
    values ('FC Barcelona', 'BAR', 500), 
    ('Real Madrid', 'RMA', 500), 
    ('Bayern Munich', 'FCB', 500), 
    ('Manchester city', 'MNC', 500), 
    ('Manchester United', 'MNU', 500)
commit
GO

begin TRANSACTION
insert into bid_types (bid_type, bid_type_duration)
    values ('buy', 'permanent'),
    ('short-loan','1 season' ),
    ('long-loan', '2 seasons')
commit
GO
begin transaction
insert into player_positions (position_name, position_abbr)
    values('Goalkeeper', 'GK'),
    ('Centre-Back', 'CB'),
    ('Left-Back', 'LB'),
    ('Right-Back', 'RB'),
    ('Denfensive Midfield', 'DM'),
    ('Central Midfield', 'CM'),
    ('Right Midfield', 'RM'),
    ('Left Midfield', 'LM'),
    ('Atacking Midfield', 'AM'),
    ('Left Winger', 'LW'),
    ('Right Winger', 'RW'),
    ('Second Striker', 'SS'),
    ('Centre-Forward', 'CF')
commit
GO
begin transaction
insert into players (player_lastname, player_firstname, player_age, player_value, player_team_id, player_nationality, player_position_id)
    values ('Ter Stegen', 'Marc Andre', 29, 82.5, 1, 'Germany', 1),
    ('Araujo', 'Ronald', 22, 27.5, 1, 'Urugay', 2),
    ('Lenglet', 'Clement', 25, 27.5, 1, 'France', 2),
    ('Pique', 'Gerard', 34, 13.2, 1, 'Spain', 2),
    ('Mingueza', 'Oscar', 21, 11, 1, 'Spain', 4),
    ('Alba', 'Jordi', 32, 27.5, 1, 'Spain', 3),
    ('Roberto', 'Sergi', 29, 27.5, 1, 'Spain', 3), 
    ('Busquets', 'Sergio', 32, 11, 1, 'Spain', 5),
    ('De Jong', 'Frenkie', 23, 88, 1, 'Netherlands', 6),
    ('Philippe', 'Coutinho', 28, 44, 1, 'Brazil', 9),
    ('Fati', 'Ansu', 18, 88, 1, 'Spain', 10),
    ('Messi', 'Lionel', 33, 150, 1, 'Argentina', 11),
    ('Griezmann', 'Antoine', 30, 66, 1, 'France', 12),
    ('Gonzalez Lopez', 'Pedri', 18, 77, 1, 'Spain', 9),
    ('Dembele', 'Ousmane', 24, 55, 1, 'France', 11),
    ('Ramos', 'Sergio', 35, 15.4, 2, 'Spain', 2),
    ('Courtois', 'Thibaut', 28, 82.5, 2,'Belgium', 1),
    ('Varane', 'Raphael', 28, 77, 2, 'France', 2),
    ('Vieira da Silva Junior', 'Marcelo', 32, 11, 2, 'Brazil', 3),
    ('Carvajal', 'Daniel', 29, 44, 2, 'Spain', 4),
    ('Casemiro', 'Carlos Henrique',29 ,77 ,2 , 'Brazil', 5),
    ('Kroos', 'Toni ',31 ,55 ,2 , 'Germany', 6),
    ('Valverde', 'Federico ',22 ,77 , 2, 'Uruguay ', 6),
    ('Modric', 'Luka ',35 ,11 , 2, 'Croatia ', 6),
    ('Hazard', ' Eden', 30, 44, 2, ' Belgium', 10),
    ('Asensio', ' Marco', 25,38.5 , 2, 'Spain', 11),
    ('Benzema', 'Karim ',33 ,27.5 , 2, 'France ', 13),
    ('Junior', ' Vinicius', 20, 44, 2, 'Brazil ', 10),
    ('Vazquez', ' Lucas', 29, 16.5, 2, 'Spain', 11),
    ('Santana de Moraes', 'Ederson ',27 , 61.6, 4, 'Brazil', 1),
    ('Dias ', 'Ruben ', 23, 77, 4, ' Portugal', 2),
    ('Laporte', 'Aymeric ', 26, 55, 4, 'France ', 2),
    ('Stones ', 'John ', 26, 33, 4, 'England ', 2),
    ('Zinchenko', 'Oleksandr ', 24, 22, 4, ' Ukraine', 3),
    ('Kyle', 'Walker', 30, 38.5, 4, 'England', 4),
    ('Luiz Roza', 'Fernandinho ', 36, 2.75, 4, 'Brazil', 5),
    ('Foden', 'Phil', 36, 77, 4, 'England', 10),
    ('Gundogan', 'Ilkay', 30, 44, 4, ' Germany', 6),
    ('De Bruyne', 'Kevin ', 29, 110, 4, 'Belgium', 9),
    ('Silva ', 'Bernardo ', 26, 77, 4, 'Portugal', 9),
    ('Sterling', 'Raheem', 26, 110, 4, 'England', 10),
    ('Torres', 'Ferran', 21, 55, 4, 'Spain', 11),
    ('Mahrez', 'Riyad', 30, 46.2, 4, 'Algeria', 11),
    ('Jesus', 'Gabriel', 24, 66, 4, 'Brazil', 13),
    ('Aguero', 'Sergio', 32, 27.5, 4, 'Argentina', 13),
    ('de Gea', 'David', 30, 24.2, 5, 'Spain', 1),
    ('Maguire', 'Harry', 28, 44, 5, 'England', 2),
    ('Lindelof', 'Victor', 28, 26.4, 5, 'Sweden', 2),
    ('Telles', 'Alex', 28, 30.8, 5, 'Brazil', 3),
    ('Shaw', 'Luke', 25, 27.5, 5, 'England', 3),
    ('Matic', 'Nemanja', 32, 11, 5, 'Serbia', 5),
    ('Pogba', 'Paul', 28, 66, 5, 'France', 6),
    ('Van de Beek', 'Donny', 24, 38.5, 5, 'Netherlands', 6),
    ('Fernandes', 'Bruno', 26, 99, 5, 'Portugal', 9),
    ('Rashford', 'Marcus', 23, 93.5, 5, 'England', 10),
    ('Martial', 'Anthony', 25, 55, 5, ' France', 13),
    ('Greenwood', 'Mason', 19, 55, 5, 'England', 11),
    ('Neuer', 'Manuel', 35, 19.8, 3, 'Germany', 1),
    ('Alaba', 'David', 28, 60.5, 3, 'Austria', 2),
    ('Sule', 'Niklas', 25, 40.7, 3, 'Germany', 2),
    ('Boateng', 'Jerome', 32, 11, 3, 'Germany', 2),
    ('Davies', 'Alphonso', 20, 82.5, 3, 'Canada', 3),
    ('Hernandez', 'Lucas', 25, 49.5, 3, 'France', 3),
    ('Pavard', 'Benjamin', 25, 38.5, 3, 'France', 4),
    ('Kimmich', 'Joshua', 26, 99, 3, 'Germany', 5),
    ('Coman', 'Kingsley', 24, 71.5, 3, 'France', 10),
    ('Gnabry', 'Serge', 25, 77, 3, 'Germany', 11),
    ('Sane', 'Leroy', 25, 77, 3, 'Germany', 11),
    ('Muller', 'Thomas', 31, 38.5, 3, 'Germany', 12),
    ('Lewandowski', 'Robert', 32, 66, 3, 'Poland', 13),
    ('Goretzka', 'Leon', 26, 77, 3, 'Germany', 6)
commit



GO
begin transaction
insert into managers(manager_firstname, manager_lastname, manager_team_id, manager_age, manager_nationality)
    values ('Ronald', 'Koeman', 1, 58, 'Netherlands'),
    ('Zinedine', 'Zidan', 2, 48, 'France'),
    ('Julian', 'Nagelsmann', 3, 33, 'Germany'),
    ('Pep', 'Guardiola', 4, 50, 'Spain'),
    ('Ole', 'Gunnar', 5, 48, 'Norway')
commit

GO
begin transaction
insert into team_honors(team_id, team_name, La_liga, Copa_del_Rey, Supercopa_de_Espana, Premier_League, FA_Cup, Bundesliga, DFB_Pokal, UEFA_Champions_League, UEFA_super_Cup, FIFA_club_world_cup)
    values(1, 'Barcelona', 26, 31, 13, null, null, null, null, 5, 5, 3 ),
    (2, 'Real Madrid', 34, 19, 11, null, null, null, null, 13, 5, 4),
    (3, 'Bayern Munich', null, null, null, null, null, 31, 20, 6, 2, 2),
    (4, 'Manchester City', null, null, null, 7, 6, null, null, 0, 0, 0),
    (5, 'Manchester United', null, null, null, 20, 12, null, null, 3, 1, 1)
commit
GO

/*          La liga     copa del rey        supercopa       champions league        super cup       club world cup 
Barcelona       26          31                  13              5                       5               3
Real Madrid     34          19                  11              13                      4               4
            Premier     FA cup                  
Man city        7           6                                   0                       0                0
Man u           20          12                                  3                       1                1

            Bundesliga     DFB Pokal                            6                       2                2      
Bayern Muhich   31          20                                  6                       2                2    
*/
--Views
--down script 
drop view if exists latest_transfers
drop view if exists Bayern_Munich
drop view if exists Manchester_United
drop view if exists Real_Madrid
drop view if exists Manchester_City
drop view if exists FC_Barcelona

--up script
GO
create VIEW FC_Barcelona as 
    select p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, p.player_age, pp.position_name as player_position, p.player_value, p.player_nationality
        from players p 
            join teams t on t.team_id = p.player_team_id
            join player_positions pp on pp.position_id = p.player_position_id  
        where t.team_name = 'FC Barcelona'

GO
create VIEW Manchester_City as 
    select p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, p.player_age, pp.position_name as player_position, p.player_value, p.player_nationality
        from players p 
            join teams t on t.team_id = p.player_team_id  
            join player_positions pp on pp.position_id = p.player_position_id
        where t.team_name = 'Manchester City'

GO
create VIEW Real_Madrid as 
    select p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, p.player_age, pp.position_name as player_position, p.player_value, p.player_nationality
        from players p 
            join teams t on t.team_id = p.player_team_id
            join player_positions pp on pp.position_id = p.player_position_id
  
        where t.team_name = 'Real Madrid'

GO
create VIEW Manchester_United as 
    select p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, p.player_age, pp.position_name as player_position, p.player_value, p.player_nationality
        from players p 
            join teams t on t.team_id = p.player_team_id
            join player_positions pp on pp.position_id = p.player_position_id  
        where t.team_name = 'Manchester United'

GO

create view Bayern_Munich as 
    select p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, p.player_age, pp.position_name as player_position, p.player_value, p.player_nationality
        from players p 
            join teams t on t.team_id = p.player_team_id
            join player_positions pp on pp.position_id = p.player_position_id  
        where t.team_name = 'Bayern Munich'
GO           

create view latest_transfers as 
    select p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, bf.team_name as from_team, bb.team_name, tb.request_amount, bt.bid_type
        from transfer_requests tb 
            join players p on p.player_id =  tb.request_for_player_id
            join teams bb on bb.team_id = tb.request_by_team_id
            join teams bf on bf.team_id = p.player_team_id
            join bid_types bt on bt.bid_type_id = tb.request_type_id


GO
select* from teams
select * from players
select* from FC_Barcelona
select m.manager_firstname + ' ' + m.manager_lastname as manager_name, t.team_name from managers m
join teams t on t.team_id = m.manager_team_id
select * from player_positions

select * from team_honors

/*  Transfer News -> Latest transfers,
                    Transfer Request -> New Request
                                        Pending Requests
    
*/

GO
DROP TRIGGER if exists t_transfer_requests_bid_status
GO
--up
create trigger t_transfer_requests_bid_status
    on transfer_requests
    after insert, update
    as BEGIN
        declare @playerid int;
        declare @teamid int;
        declare @reqid int;
        select @playerid = i.request_for_player_id from inserted i
        select @teamid = i.request_by_team_id  from inserted i 
begin transaction
        if update(request_approved_date) BEGIN

        
        update transfer_requests
        SET request_status  = CASE
        when  request_approved_date is not null then 'Approved'
        when  request_approved_date is null then 'Pending' 
            END
        
        End 
        commit  
    END

GO

drop trigger if exists t_transfer_requests_request_status
GO

create trigger t_transfer_requests_request_status
    on transfer_requests
    after UPDATE
    as BEGIN
        
        declare @playerid int;
        declare @teamid int;
        
        select @playerid = i.request_for_player_id from inserted i
        select @teamid = i.request_by_team_id  from inserted i 
        Begin transaction
        if update(request_status) begin
      
            update players 
            set player_team_id = @teamid
            where player_id = @playerid
     
      
             
        END
        COMMIT
    End 



DROP TRIGGER if exists t_team_transfer_requests_request_status
GO
--up
create trigger t_team_transfer_requests_request_status
    on transfer_requests
    after update
    as BEGIN
        
        declare @playerid int;
        declare @teamid int;
        declare @reqid int;
        select @playerid = i.request_for_player_id from inserted i
                select @teamid = i.request_by_team_id  from inserted i 

           -- if update(request_status) begin

        --        update players 
        --        set player_team_id = @teamid
        --        where player_id = @playerid
        if update(request_status) BEGIN
                
          update players
            SET player_team_id  = case
                when i.request_approved_date is not null then @teamid
                end
            from players p
            join transfer_requests tr on p.player_id = tr.request_for_player_id
            join inserted i on i.request_for_player_id = p.player_id
             
            end
            End 
       
drop trigger if exists t_t
GO
create trigger t_t
    on transfer_requests
    after update
    as BEGIN
        
        declare @playerid int;
        declare @teamid int;
        declare @reqid int;
        select @playerid = i.request_for_player_id from inserted i
                select @teamid = i.request_by_team_id  from inserted i 

           -- if update(request_status) begin

        --        update players 
        --        set player_team_id = @teamid
        --        where player_id = @playerid
        if (select count(*) from inserted where request_status = 'Approved' ) BEGIN
                
          update players
            SET player_team_id  = case
                when i.request_approved_date is not null then @teamid
                end
            from players p
            join transfer_requests tr on p.player_id = tr.request_for_player_id
            join inserted i on i.request_for_player_id = p.player_id
             
            end
            End 
       
        update p
        set player_team_id = @teamid
        from players p
        join inserted i on p.player_id = i.request_for_player_id
        where i.request_approved_date is not null




select * from transfer_requests