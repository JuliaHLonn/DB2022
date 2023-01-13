
Use iths;
Drop table if exists UNF;

Create table UNF(
	`Id` DECIMAL(38, 0) NOT NULL,
    `Name` VARCHAR(26) NOT NULL,
    `Grade` VARCHAR(11) NOT NULL,
    `Hobbies` VARCHAR(25),
    `City` VARCHAR(10) NOT NULL,
    `School` VARCHAR(30) NOT NULL,
    `HomePhone` VARCHAR(15),
    `JobPhone` VARCHAR(15),
    `MobilePhone1` VARCHAR(15),
    `MobilePhone2` VARCHAR(15)
)  ENGINE=INNODB;

Load data infile '/var/lib/mysql-files/denormalized-data.csv'
Into table UNF
Character set latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Drop table if exists Student;

create table Student(
	StudentId int not null auto_increment,
	FirstName varchar(100) not null,
	LastName varchar(200) not null,
	constraint Primary Key(StudentId)
) Engine=INNODB;

Insert into Student (StudentID, FirstName, LastName) 
Select distinct Id, SUBSTRING_INDEX(Name, ' ', 1), SUBSTRING_INDEX(Name, ' ', -1) 
from UNF;

Drop table if exists School;

create table School(
	SchoolId int not null auto_increment,
	Name varchar(250) not null,
	City varchar(250) not null,
	Primary Key(SchoolId)
) ENGINE=INNODB;

insert into School(Name, City) select distinct School, City from UNF;

Drop table if exists StudentSchool;

create table StudentSchool select distinct UNF.Id as StudentId, School.SchoolId 
from UNF inner join School on UNF.School = School.Name;

alter table StudentSchool modify column StudentId int;
alter table StudentSchool add primary key(StudentId, SchoolId);


Drop table if exists PhoneType;
Create table PhoneType (
    PhoneTypeId int not null AUTO_INCREMENT,
    Type varchar(32),
    Primary key(PhoneTypeId)
);
Insert into PhoneType(Type) Values("Home");
Insert into PhoneType(Type) Values("Job");
Insert into PhoneType(Type) Values("Mobile");

Drop table if exists Phone;
create table Phone(
	PhoneId int not null auto_increment,
	StudentId int not null,
	PhoneTypeId int not null,
	Number varchar(32) not null,
	primary key(PhoneId)
	) ENGINE=INNODB;

Insert into Phone(StudentId,PhoneTypeId,Number)
SELECT ID As StudentId, PhoneTypeId, HomePhone as Number FROM UNF join PhoneType on type = "Home"
WHERE HomePhone IS NOT NULL AND HomePhone != ''
UNION SELECT ID As StudentId, PhoneTypeId, JobPhone as Number FROM UNF join PhoneType on type = "Job"
WHERE JobPhone IS NOT NULL AND JobPhone != ''
UNION SELECT ID As StudentId, PhoneTypeId, MobilePhone1 as Number FROM UNF join PhoneType on type = "Mobile"
WHERE MobilePhone1 IS NOT NULL AND MobilePhone1 != ''
UNION SELECT ID As StudentId, PhoneTypeId, MobilePhone2 as Number FROM UNF join PhoneType on type = "Mobile"
WHERE MobilePhone2 IS NOT NULL AND MobilePhone2 != ''
;

Drop view if exists PhoneList;
create view PhoneList as select StudentId, group_concat(Number) as Number 
from Phone group by StudentId;

Drop table if exists Hobbies;
Create table Hobbies(
    HobbyId int not null auto_increment,
    Name Varchar(250) not null,
    Primary key (HobbyId)
)  ENGINE=INNODB;

Insert into Hobbies(Name)
Select distinct Hobby from (
  Select Id as StudentId, trim(SUBSTRING_INDEX(Hobbies, ",", 1)) as Hobby from UNF
  Where HOBBIES != ""
  Union select Id as StudentId, trim(substring_index(substring_index(Hobbies, ",", -2),"," ,1)) from UNF
  Where HOBBIES != ""
  Union select Id as StudentId, trim(substring_index(Hobbies, ",", -1)) from UNF
  Where HOBBIES != ""
) as Hobbies2;

Drop table if exists StudentHobbies;
Create table StudentHobbies (
	StudentId int not null,
	HobbyId int not null,
	Primary key(StudentId, HobbyId)
)ENGINE=INNODB;

Insert into StudentHobbies(StudentId, HobbyId)
Select distinct StudentId, HobbyId from (
  select Id as StudentId, trim(SUBSTRING_INDEX(Hobbies, ",", 1)) as Hobby from UNF
  Where HOBBIES != ""
  Union select Id as StudentId, trim(substring_index(substring_index(Hobbies, ",", -2),"," ,1)) from UNF Where HOBBIES != ""
  Union select Id as StudentId, trim(substring_index(Hobbies, ",", -1)) from UNF
  Where HOBBIES != ""
) as Hobbies2 inner join Hobbies on Hobbies2.Hobby = Hobbies.Name;

Drop view if exists HobbiesList;
Create view HobbiesList as select StudentId, group_concat(Name) as Hobbies from StudentHobbies join Hobbies Using (HobbyId) group by StudentId;

Drop table if exists Grade;
Create table Grade(
	GradeId int not null auto_increment,
	Name varchar(200) not null,
	Primary key(GradeId)
) ENGINE=INNODB;

Insert into Grade(Name) select distinct Grade from UNF;

Alter table Student Add Column GradeId int not null;
Update Student join UNF on(StudentId=Id) join Grade on Grade.Name = UNF.Grade set Student.GradeId = Grade.GradeId;

Drop view if exists Avslut;
Create view Avslut as select StudentId as ID, FirstName, LastName, Grade.Name as Grade, Hobbies, School.Name as School, City, Number
From StudentSchool left join Student using(StudentId)
left join Grade using(GradeId)
left join HobbiesList using(StudentId)
left join School using(SchoolId)
left join PhoneList using(StudentId);

