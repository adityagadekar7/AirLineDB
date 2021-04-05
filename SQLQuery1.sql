create database AirLineDB
use AirLineDB

Create table User_Registration
(User_Id int primary key identity,
Title varchar(30) not null,
FirstName varchar(30) not null,
LastName varchar(30) not null,
EmailID varchar(30) not null,
Password varchar(30) not null,
DOB date,
PhoneNumber bigint not null)




Create table City_Information
(Airport_Code int primary key,
Airport_Name varchar(30) not null,
CityName varchar(30) not null,
State varchar(30) not null,
Zip_Code int not null)


Create table Flight_Schedules
(Flight_Number int primary key,
Airport_Code int Foreign key references City_Information(Airport_Code),
Flight_Departing_Time time not null,
Flight_Arrival_Time time not null,
Origin varchar(30) not null,
Destination varchar(30) not null,
Flight_Status varchar(30),
Cost_Eco int,
Cost_Business int,
Seats_Available_Eco int,
Seats_Available_Business int)

alter table Flight_Schedules add Flight_Date date
alter table Flight_Schedules add Flight_Name varchar(30)


Create table Flight_Reservation
(Pnr_no int primary key identity(100,10),
Flight_Number int Foreign key references Flight_Schedules(Flight_Number),
User_Id int Foreign key references User_Registration(User_ID),
Reservation_Date date not null,
Reservation_Time time not null,
num_of_Seats int not null,
Classtype varchar(30),
total_price int,
status varchar(30))




Create table Passenger_Details
(Passenger_id int primary key identity,
Pnr_no int Foreign key references Flight_Reservation(Pnr_no),
PassportNumber int not null,
FirstName varchar(30) not null,
LastName varchar(30) not null,
DOB date,
Gender varchar(30),
PhoneNumber bigint,
CovidCertificate varchar(30))



Create table Payment_Details
(User_Id int Foreign key references User_Registration(User_Id),
CardNo bigint primary key not null,
cardtype varchar(30) not null,
Expiry_Month int,
Expiry_year int,
Balance int)



Create table Cancellation
(Cancellation_Id int primary key identity,
Pnr_no int Foreign key references Flight_Reservation(Pnr_no),
User_id int Foreign key references User_Registration(User_Id),
Dateofcancellation date not null,
timeofcancellation time not null,
Refund_Amount int not null,
Status varchar(30))





/*Queries*/

Select * from Payment_Details where User_Id=1

select * from Cancellation where User_id=1


/*Display cancelled tickets based on user ID*/
select * from (
select c.Pnr_no,c.User_Id,r.Flight_Number, c.Dateofcancellation,c.timeofcancellation,c.Refund_Amount,c.Status,r.Reservation_Date,r.Reservation_Time,r.num_of_Seats,r.Classtype,r.total_price from Cancellation c,Flight_Reservation r where c.Pnr_no=r.Pnr_no) as CancelledTickets where User_Id=1


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
select * from Flight_Schedules where Origin='Goa' and destination='Mumbai'and Flight_date='05-04-21' and Flight_Status= 'Available' and Flight_Name='AirIndia'

