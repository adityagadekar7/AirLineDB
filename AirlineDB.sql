create database AirlineDB
use AirlineDB

Create table User_Registration
(User_Id int primary key identity ,
Title varchar(30) not null,
FirstName varchar(30) not null,
LastName varchar(30) not null,
EmailID varchar(30) Unique not null,
Password varchar(100) not null,
DOB date not null,
PhoneNumber bigint Unique not null)

alter table User_Registration add OTP nvarchar(40) Null,ActivationCode uniqueidentifier null

Create table City_Information
(Airport_Code int primary key,
Airport_Name varchar(200) not null,
Location varchar(30) not null,
Zip_Code int not null)

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

select * from Flight_Schedules

Create table Flight_Reservation
(Pnr_no int primary key identity(100,10),
Flight_Number int Foreign key references Flight_Schedules(Flight_Number) not null,
User_Id int Foreign key references User_Registration(User_ID) not null,
Reservation_Date date not null,
Reservation_Time time not null,
num_of_Seats int not null,
Classtype varchar(30) not null,
total_price int not null,
status varchar(30) not null,
seats varchar(8000))



select * from Flight_Reservation

Create table Passenger_Details
(Passenger_id int primary key identity,
Pnr_no int Foreign key references Flight_Reservation(Pnr_no) not null,
PassportNumber varchar(100) not null,
FirstName varchar(30) not null,
LastName varchar(30) not null,
DOB date not null,
Gender varchar(30) not null,
PhoneNumber bigint not null,
CovidCertificate varchar(30) not null)
select * from Passenger_Details
Insert Into Passenger_Details values(490,'Ancbdjbcdb202','Abc','Def','11/28/2002','Female',1234567897,'Yes')
Insert into Passenger_Details values(100,20202,'psg_111','A','11/28/2002','Female',1234567897,'Yes')

Create table Payment_Details
(User_Id int Foreign key references User_Registration(User_Id),
CardNo bigint primary key,
cardtype varchar(30) not null,
Expiry_Month int not null,
Expiry_year int not null,
Balance bigint )


Create table Cancellation
(Cancellation_Id int primary key identity,
Pnr_no int Foreign key references Flight_Reservation(Pnr_no) not null,
User_id int Foreign key references User_Registration(User_Id) not null,
Dateofcancellation date not null,
timeofcancellation time not null,
Refund_Amount int not null,
Status varchar(30) not null)

alter table Flight_Reservation add Seats varchar(8000) 
alter table Flight_Schedules add Seats varchar(8000) 
alter table Flight_Schedules alter column Seats_Available_Business int 
--alter table Flight_Reservation 
ALTER TABLE Flight_Reservation ALTER COLUMN  total_price int;

Select * from User_Registration
Select * from City_Information
Select * from Flight_Schedules
Select * from Flight_Reservation
Select * from Passenger_Details
Select * from Payment_Details
Select * from Cancellation

truncate table Flight_Reservation
delete from User_Registration where USER_ID>1



Insert into City_Information values(101,'Chhatrapati Shivaji Maharaj International Airport','Mumbai',400001)
Insert into City_Information values(121,'Rajiv Gandhi International Airport','Hyderabad',400056)
Insert into City_Information values(135,'Dabolim Airport','Goa',407601)
Insert into City_Information values(105,'Surat Airport','Gujrat',605601)


Insert into Payment_Details values(1,111111111111,'Debit',04,25,350000)
Insert into Payment_Details values(2,222222222222,'Debit',04,25,180000)
Insert into Payment_Details values(6,333333333333,'Credit',09,21,1000000)
--Insert into Payment_Details values(4,123458888,'Debit',07,25,95000)
--Insert into Payment_Details values(1,121111111,'Credit',04,25,75000)
select * from Payment_Details
select * from Flight_Reservation




create proc sp_InsertCardDetails(@UserId int,@CardNo bigint, @cardtype varchar(30), @Expiry_Month int, @Expiry_year int, @Balance bigint)
	as
	begin 
	Insert into Payment_Details values(@UserId,@CardNo,@cardtype,@Expiry_Month,@Expiry_year,@Balance)
	end

	exec sp_InsertCardDetails 1,121212121212,'credit',04,25,100000









--Store Procedures
create proc sp_UpdatePassword(@otp varchar(20),@Password varchar(50))
	as
	begin 
	update User_Registration set Password=@Password where OTP=@otp
	update User_Registration set OTP=NUll where OTP=@otp
	end


/*sp for Cancelled tickets*/
create or alter proc sp_CancelledTickets(@uid int)
as
begin
select * from (
select c.Pnr_no,c.User_Id,r.Flight_Number, s.Flight_Name,s.Flight_Date,ct.Airport_Name,s.Origin,s.Destination,c.Dateofcancellation,c.timeofcancellation,c.Refund_Amount,c.Status,r.Reservation_Date,r.Reservation_Time,r.num_of_Seats,r.Classtype,r.total_price from Cancellation c,Flight_Reservation r,City_Information ct,Flight_Schedules s where c.Pnr_no=r.Pnr_no and r.Flight_Number=s.Flight_Number and s.Airport_Code=ct.Airport_Code ) as CancelledTickets where User_Id=@uid
end

exec sp_CancelledTickets 1

/*sp for Booked tickets*/
create or alter proc sp_BookedTickets(@uid int)
as
begin
Select * from (Select r.User_Id,r.pnr_no,c.Airport_Name,c.Location,c.Zip_Code,s.Flight_date,r.Flight_Number,s.origin,s.Destination,s.Flight_Departing_Time,s.Flight_Arrival_Time ,r.Reservation_Date,r.Reservation_Time,r.num_of_Seats,r.Classtype,r.total_price,r.status,r.Seats
from Flight_Reservation r ,Flight_Schedules s,City_Information c
where s.Flight_Number=r.Flight_Number and s.Airport_Code=c.Airport_Code) as BookedTickets 
where status='success' and User_Id=@uid
end

exec sp_BookedTickets 1



--Get seats by Flight_Number
create or alter proc sp_GetSeatsByFlightNo(@Flight_Number int)
as
begin
select Seats from Flight_Schedules where Flight_Number=@Flight_Number
end

exec sp_GetSeatsByFlightNo 1
select * from Flight_Schedules

--Update Seats with Flight_Number
create or alter proc sp_UpdateSeats(@Flight_Number int, @Seats varchar(8000))
as
begin
declare @OldSeats varchar(8000), @UpdatedSeats varchar(8000)
set @OldSeats = (Select Seats from Flight_Schedules where Flight_Number=@Flight_Number)
set @UpdatedSeats=CONCAT(@OldSeats,',',@Seats)
update Flight_Schedules set Seats=@UpdatedSeats where Flight_Number=@Flight_Number
end

exec sp_UpdateSeats 1,'G1,G2'
select * from Flight_Schedules
select * from Flight_Reservation

datediff(dd,'2010-12-31 15:13:48.593','2010-12-31 00:00:00.000')=0;

DATEDIFF(day, 2010-12-31, 2010-12-31) >= 0

IF CAST('2010-12-31' AS DATE) = CAST('2010-12-31' AS DATE) return ;

create or alter proc sp_DateCompare(@Flight_Number int)
as
begin
--select getdate()
declare @FlightDate date, @FlightTime time, @FlightDateTime datetime, @CurrentDateTimeadded datetime;
set @FlightDate=(Select Flight_Date from Flight_Schedules where Flight_Number=@Flight_Number)
set @FlightTime=(Select Flight_Departing_Time from Flight_Schedules where Flight_Number=@Flight_Number)
set @FlightDateTime=CAST(CAST(@FlightDate as DATE) AS DATETIME) + CAST(CAST(@FlightTime as TIME) as DATETIME)
set @CurrentDateTimeadded=(SELECT DATEADD(HOUR,+3,getDate()))
if @CurrentDateTimeadded<@FlightDateTime
	select 1	--Can be cancelled
else
	select 0     --cannot BE cancelled
end

exec sp_DateCompare 32


   

   create or alter proc sp_GetAllFlightDetails
   as
   begin
   select * from Flight_Schedules
   end
   exec sp_GetAllFlightDetails

   create or alter proc sp_BookingDetailsByID(@uid int)
   as
   begin
   --select * from Flight_Reservation where User_Id=@uid and status='Success'
   Select * from (Select r.User_Id,r.pnr_no,c.Airport_Name,c.Location,c.Zip_Code,s.Flight_date,r.Flight_Number,s.origin,s.Destination,s.Flight_Departing_Time,s.Flight_Arrival_Time ,r.Reservation_Date,r.Reservation_Time,r.num_of_Seats,r.Classtype,r.total_price,r.status
from Flight_Reservation r ,Flight_Schedules s,City_Information c
where s.Flight_Number=r.Flight_Number and s.Airport_Code=c.Airport_Code) as BookedTickets 
where status='success' and User_Id=@uid
   end
   exec sp_BookingDetailsByID 1

   create or alter proc sp_GetPsgDetailsByPnr(@pnr int)
   as
   begin
   select * from Passenger_Details where Pnr_no=@pnr
   end
   exec sp_GetPsgDetailsByPnr 10510

   create or alter proc sp_GetIdByEmail(@email varchar(40))
   as
   begin
   select * from User_Registration where EmailID=@email
   end
   exec sp_GetIdByEmail 'a@b.c'
   select * from User_Registration
   delete from User_Registration where User_Id=3

   create or alter proc sp_GetFlights(@Flight_Name varchar(40), @Flight_Date varchar(40), @Origin varchar(40), @Destination varchar(40))
   as
   begin 
   select * from Flight_Schedules where Flight_Name=@Flight_Name and Flight_Date=@Flight_Date and Origin= @Origin and Destination=@Destination
   end
   exec sp_GetFlights 'AirIndia', '2021-04-30', 'Mumbai', 'Goa'
   select * from Flight_Schedules
   delete from Flight_Schedules where Flight_Number>0

   select * from Flight_Reservation  
   delete from Flight_Reservation where Pnr_no=100
   
   select * from Flight_Schedules
    select * from Passenger_Details
   delete from Passenger_Details where Pnr_no>320

   select * from Cancellation
   delete from Cancellation where Pnr_no>320
   Insert Into Flight_Reservation values (44,1,'2021-04-20','15:05:38.0000000',1,'Eco',7632.22,'Success',',J7')
   Insert Into Flight_Schedules values(45,'AirIndia','2021-04-30',101,'20:01:00.0000000','00:04:00.0000000','Mumbai','Gujrat','Available',2390,4160,60,30,'J6')
   

   truncate table passenger_details
  