create database AirLineDatabase
use AirLineDatabase

Create table User_Registration
(User_Id int primary key identity ,
Title varchar(30) not null,
FirstName varchar(30) not null,
LastName varchar(30) not null,
EmailID varchar(30) not null,
Password varchar(30) not null,
DOB date not null,
PhoneNumber bigint not null)




Create table City_Information
(Airport_Code int primary key,
Airport_Name varchar(30) not null,
CityName varchar(30) not null,
State varchar(30) not null,
Zip_Code int not null)
alter table City_Information
alter column Airport_Name varchar(100)


Create table Flight_Schedules
(Flight_Number int primary key,
Flight_Name varchar(30) not null,
Flight_Date date not null,
Airport_Code int Foreign key references City_Information(Airport_Code) not null,
Flight_Departing_Time time not null,
Flight_Arrival_Time time not null,
Origin varchar(30) not null,
Destination varchar(30) not null,
Flight_Status varchar(30) not null,
Cost_Eco int not null,
Cost_Business int not null,
Seats_Available_Eco int not null,
Seats_Available_Business int not null)



Create table Flight_Reservation
(Pnr_no int primary key identity(100,10),
Flight_Number int Foreign key references Flight_Schedules(Flight_Number) not null,
User_Id int Foreign key references User_Registration(User_ID) not null,
Reservation_Date date not null,
Reservation_Time time not null,
num_of_Seats int not null,
Classtype varchar(30) not null,
total_price int not null,
status varchar(30) not null)




Create table Passenger_Details
(Passenger_id int primary key identity,
Pnr_no int Foreign key references Flight_Reservation(Pnr_no) not null,
PassportNumber int not null,
FirstName varchar(30) not null,
LastName varchar(30) not null,
DOB date not null,
Gender varchar(30) not null,
PhoneNumber bigint not null,
CovidCertificate varchar(30) not null)



Create table Payment_Details
(User_Id int Foreign key references User_Registration(User_Id) not null,
CardNo bigint primary key,
cardtype varchar(30) not null,
Expiry_Month int not null,
Expiry_year int not null,
Balance int not null)



Create table Cancellation
(Cancellation_Id int primary key identity,
Pnr_no int Foreign key references Flight_Reservation(Pnr_no) not null,
User_id int Foreign key references User_Registration(User_Id) not null,
Dateofcancellation date not null,
timeofcancellation time not null,
Refund_Amount int not null,
Status varchar(30) not null)



Select * from User_Registration
Select * from City_Information
Select * from Flight_Reservation
Select * from Flight_Schedules
Select * from Passenger_Details
Select * from Payment_Details
Select * from Cancellation

/*
drop table User_Registration
drop table City_Information
drop table Flight_Schedules
drop table Flight_Reservation
drop table Passenger_Details
drop table Payment_Details
drop table Cancellation
*/



Insert into User_Registration values('Mr','Aditya','G','asdsd@gmail.com','aS@2','07/10/98',1234567890)
Insert into User_Registration values('Mr','Falguni','T','ddas@gmail.com','aA2@','08/06/99',8794567890)
Insert into User_Registration values('Mr','Meghashree','G','dassh@gmail.com','sS2@','09/11/97',6547567890)
Insert into User_Registration values('Mr','Santhosh','N','asdasd@gmail.com','aS2@','06/12/96',4562567890)


Insert into City_Information values(101,'Chhatrapati Shivaji Maharaj International Airport','Mumbai','Maharashtra',400001)
Insert into City_Information values(121,'Rajiv Gandhi International Airport','Hyderabad','Telangana',400056)
Insert into City_Information values(135,'Dabolim Airport','Dabolim','Goa',407601)
Insert into City_Information values(105,'Surat Airport','Surat','Gujrat',605601)

Insert into Flight_Schedules values(1,'IndiGo','04/04/21',101,'10:30','12:30','Mumbai','Goa','Available',2000,4000,20,30)
Insert into Flight_Schedules values(2,'AirIndia','05/04/21',121,'10:30','13:30','Hyderabad','Delhi','Available',2500,4500,30,30)
Insert into Flight_Schedules values(3,'AirIndia','06/04/21',135,'11:30','01:30','Goa','Kerala','Available',2500,4000,20,40)
Insert into Flight_Schedules values(4,'IndiGo','07/04/21',105,'08:30','10:30','Gujrat','Chandigarh','Available',3000,5000,30,10)
Insert into Flight_Schedules values(5,'AirIndia','04/04/21',101,'11:30','13:30','Mumbai','Goa','Available',3000,5000,30,10)
Insert into Flight_Schedules values(6,'AirIndia','05/04/21',101,'15:30','17:30','Mumbai','Goa','Available',3000,5000,30,10)
Insert into Flight_Schedules values(7,'AirIndia','06/04/21',135,'10:30','12:30','Goa','Mumbai','Available',3000,5000,30,10)


Insert into Flight_Reservation values(1,1,'02/04/2021','15:27',2,'Business',8000,'Success')
Insert into Flight_Reservation values(3,1,'02/04/2021','15:27',1,'Eco',5000,'Success')
Insert into Flight_Reservation values(1,2,'01/04/2021','11:17',2,'Eco',5000,'Success')
Insert into Flight_Reservation values(4,3,'01/04/2021','10:05',1,'Business',5000,'Failed')
Insert into Flight_Reservation values(4,1,'05/04/2021','10:05',1,'Business',5000,'Success')

delete from Passenger_Details where Pnr_no=130

Insert into Passenger_Details values(100,20202,'psg_111','A','11/28/2002','Female',1234567897,'Yes') /*By uid1 for flight1*/
Insert into Passenger_Details values(100,20202,'psg_112','B','12/18/2001','Male',2354567897,'Yes')  /*By uid1 for flight1*/
Insert into Passenger_Details values(120,20202,'psg_131','C','12/23/2000','Female',5234546897,'Yes') /*By uid1 for flight3*/
Insert into Passenger_Details values(150,20202,'psg_141toCan','D','01/05/1998','Male',9194567897,'No')   /*Cancelled*/
Insert into Passenger_Details values(130,20202,'psg_211','E','06/30/2003','Female',6231237897,'Yes') /*By uid2 for flight1*/
Insert into Passenger_Details values(130,20202,'psg_212','F','11/28/1997','Male',7894567897,'No')   /*By uid2 for flight1*/
Insert into Passenger_Details values(140,20202,'psg_341','G','10/02/1999','Female',9874567897,'Yes')   /*By uid3 for flight4*/
Insert into Passenger_Details values(140,20202,'psg_342','H','01/05/1998','Male',9194567897,'No')   /*By uid3 for flight4*/


Insert into Payment_Details values(1,123456789,'Debit',04,25,35000)
Insert into Payment_Details values(2,123456666,'Debit',04,26,18000)
Insert into Payment_Details values(3,123457777,'Credit',09,21,65000)
Insert into Payment_Details values(4,123458888,'Debit',07,25,95000)
Insert into Payment_Details values(1,121111111,'Credit',04,25,75000)

Insert into Cancellation values(130,2,'04/04/21','16:13',2500,'Success')

/*Queries*/

Select * from Payment_Details where User_Id=1

select * from Cancellation where User_id=2


/*Display cancelled tickets based on user ID*/
select * from (
select c.Pnr_no,c.User_Id,r.Flight_Number, c.Dateofcancellation,c.timeofcancellation,c.Refund_Amount,c.Status,r.Reservation_Date,r.Reservation_Time,r.num_of_Seats,r.Classtype,r.total_price from Cancellation c,Flight_Reservation r where c.Pnr_no=r.Pnr_no) as CancelledTickets where User_Id=2


select * from Flight_Reservation where User_Id=1


/*Display Booked Tickets based on user id*/

Select * from (Select r.User_Id,r.pnr_no,c.Airport_Name,c.State,c.Zip_Code,s.Flight_date,r.Flight_Number,s.origin,s.Destination,s.Flight_Departing_Time,s.Flight_Arrival_Time ,r.Reservation_Date,r.Reservation_Time,r.num_of_Seats,r.Classtype,r.total_price,p.Passenger_id,p.FirstName,p.LastName,p.PassportNumber,p.DOB,p.Gender,p.PhoneNumber,p.CovidCertificate,r.status
from Flight_Reservation r,Passenger_Details p ,Flight_Schedules s,City_Information c
where r.Pnr_no=p.Pnr_no and s.Flight_Number=r.Flight_Number and s.Airport_Code=c.Airport_Code) as BookedTickets 
where User_Id=1



/*Flight search*/
/*OneWay*/
select * from Flight_Schedules where Origin='Mumbai' and destination='Goa' and Flight_date='04-04-21' and Flight_Status='Available' and Flight_Name in('IndiGo' ,'AirIndia')
/*Twoway for both*/
select * from Flight_Schedules where Origin='Goa' and destination='Mumbai'and Flight_date='06-04-21' and Flight_Status= 'Available' and Flight_Name='AirIndia'

