--Triggers should be run one by one after SampleDatas.sql

Create or alter trigger is_FFC_Check
on Transaction_record
After insert 
as
	declare @Mileage int,  @Customer_id int,  @Flight_number int,@Leg_number int, @Toplam_mil int,@Trans_airline int,@Card_no int,@G�ncel_point int;
	select @Customer_id=Customer_id,@Flight_number=Flight_number,@Mileage=Mileage  FROM inserted
	set @Trans_airline = ( Select Airline_id from Flight where @Flight_number=Flight_number);
	
	set @Card_no=FLOOR(RAND()*(1000000-20+1))+20;
	if exists (SELECT * FROM FFC WHERE Customer_id=@Customer_id and Airline_id=@Trans_airline)
	begin
	UPDATE FFC set Credit_point+=@Mileage where Customer_id=@Customer_id and Airline_id=@Trans_airline
	select @G�ncel_point = Credit_point from FFC where Customer_id=@Customer_id and Airline_id=@Trans_airline

	if(@G�ncel_point<1500)
	begin
	UPDATE FFC SET FFC_type=1 where Customer_id=@Customer_id and Airline_id=@Trans_airline	
	end
	else if (1499 < @G�ncel_point and @G�ncel_point<3000)
	begin
	UPDATE FFC SET FFC_type=2 where Customer_id=@Customer_id and Airline_id=@Trans_airline
	end
	else if (@G�ncel_point>2999)
	begin
	UPDATE FFC SET FFC_type=3 where Customer_id=@Customer_id and Airline_id=@Trans_airline
	end
	end
	else
	begin
	set @Toplam_mil	=(SELECT SUM (Mileage)
		FROM Transaction_record
		where Customer_id=@Customer_id and Flight_number=@Flight_number);
	if(@Toplam_mil>100)
	begin
	print'Toplam mil 100� ge�ti�i i�in M��teri FFC oldu!'
	INSERT INTO FFC(Customer_id,FFC_card_no,Credit_point,Airline_id)
	VALUES
	(@Customer_id,@Card_no,@Toplam_mil*2, (select Airline_id from Flight where @Flight_number=Flight_number));
	end
	else
	begin
	print 'Toplam mil 100den d���k kald��� i�in M��teri FFC olamad� !'
	end
	end



Create or alter trigger create_record
on Check_in
After insert 
as
	declare @Net_mileage int, @Customer_id int,  @Flight_number int,@Leg_number int,@Trans_airline int ,@Check_position bit,@Kalk��_aiport_code int,@�ni�_airport_code int,@Kalk��_cordinat int,@�ni�_cordinat int;

	select @Customer_id=Customer_id,@Flight_number=Flight_number,@Leg_number=Leg_number,@Check_position=Check_position,@Check_position=Check_position FROM inserted


	set @Kalk��_aiport_code = (Select Departure_airport_code from Flight_leg where Flight_number=@Flight_number and Leg_number=@Leg_number);
	set @�ni�_airport_code=(Select Arrival_airport_code from Flight_leg where Flight_number=@Flight_number and Leg_number=@Leg_number)
	
	set @Kalk��_cordinat= (select Airport_cordinats from Airport where Airport_code=@Kalk��_aiport_code);

	set @�ni�_cordinat =(select Airport_cordinats from Airport where Airport_code=@�ni�_airport_code);

	set @Net_mileage = @Kalk��_cordinat-@�ni�_cordinat;

	if(@Check_position=1)
	begin
	INSERT INTO Transaction_record(Flight_number,Leg_number,Customer_id,Mileage)
	VALUES
	(@Flight_number,@Leg_number,@Customer_id,@Net_mileage*@Net_mileage)
	end



CREATE or alter TRIGGER FFC_select_type
ON FFC
AFTER insert
AS
	declare @Credit_point int,  @Customer_id int,  @FFC_card_no int
	select @Credit_point = Credit_point, @Customer_id=Customer_id,@FFC_card_no=FFC_card_no FROM inserted
	
	IF (@Credit_point < 1500)
		begin
		PRINT 'Credi Pointi 1500 den k���k oldu�u i�in M��teri Bronz FFC oldu';
		UPDATE FFC set FFC_type=1 where Customer_id=@Customer_id and FFC_card_no=@FFC_card_no
		end
	ELSE IF (1499 < @Credit_point and @Credit_point<3000)
		begin
		PRINT 'Credi Pointi 1500-3000 aras� oldu�u i�in M��teri Silver FFC oldu';
		UPDATE FFC set FFC_type=2 where Customer_id=@Customer_id and FFC_card_no=@FFC_card_no
		end
	ELSE IF (@Credit_point>2999) 
		begin
		PRINT 'Credi Point 3000 den fazla oldu�u i�in M��teri Gold FFC oldu';
		UPDATE FFC set FFC_type=3 where Customer_id=@Customer_id and FFC_card_no=@FFC_card_no
		end



create or alter trigger Customer_delete
on Customer
instead of delete
AS
declare @Customer_id int
select @Customer_id =(select Customer_id from deleted)
begin
delete from FFC where Customer_id =@Customer_id
delete from Seat_reservation where Customer_id=@Customer_id
delete from Transaction_record where Customer_id=@Customer_id
delete from Check_in where Customer_id=@Customer_id
delete from Customer where Customer_id=@Customer_id
end;



create or alter trigger seatnumber_check
on Seat_reservation
instead of insert
as
declare  @Flight_number int,@Leg_number int,@Leg_date date,@Seat_number int,@sayac int,@Customer_id int

	select @Flight_number=Flight_number,@Leg_number=Leg_number, @Leg_date=Leg_date,@Seat_number=Seat_number,@Customer_id=Customer_id FROM inserted

	if exists(select Seat_number from Seat_reservation where Seat_number=@Seat_number and Flight_number=@Flight_number and Leg_number=@Leg_number and Leg_date=@Leg_date)
	begin
	print 'Koltuk dolu oldu�u M��teri reservazyon yapamad�' 
	end
	else
	begin
	INSERT INTO Seat_reservation(Flight_number,Leg_number,Customer_id,Seat_number,Leg_date)
	VALUES
		(@Flight_number,@Leg_number,@Customer_id,@Seat_number,@Leg_date)
	UPDATE Leg_Instance set Number_of_available-=1 where Flight_number=@Flight_number and Leg_number=@Leg_number and Leg_date=@Leg_date
	end