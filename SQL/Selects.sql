

select Customer_name,Airline_name,Credit_point
from Airline,FFC,Customer
where Airline.Airline_id=FFC.Airline_id and Customer.Customer_id=FFC.Customer_id

select Airline_name,Customer_name,FFC_card_no
from Airline,Customer,FFC
where Airline.Airline_id=FFC.Airline_id and Customer.Customer_id=FFC.Customer_id and Airline.Airline_name='THY'

select Company_name,Total_number_of_seats,Number_of_available,(Airplane.Total_number_of_seats-Leg_Instance.Number_of_available)AS Sat�lan_koltuklar
FROM Company,Airplane,Leg_Instance
where Company.Company_id=Airplane.Company_id and Airplane.Airplane_id=Leg_Instance.Airplane_id
Order by (Sat�lan_koltuklar) desc

select Customer_name,Mileage,Transaction_record.Flight_number,Transaction_record.Leg_number
from Check_in,Customer,Transaction_record
where Customer.Customer_id=Transaction_record.Customer_id and Check_in.Check_position=1 and Check_in.Customer_id=Customer.Customer_id and Check_in.Flight_number=Transaction_record.Flight_number and Check_in.Leg_number=Transaction_record.Leg_number
order by (Mileage)desc

Select Customer.Customer_name,Transaction_record.Flight_number,Transaction_record.Leg_number,Transaction_record.Mileage
from Transaction_record,Customer
where Transaction_record.Customer_id=3 and Customer.Customer_id=3


Select Customer_name ,Customer_phone,Credit_point
from FFC,Customer
where Customer.Customer_id = FFC.Customer_id and FFC.FFC_type=3;


select Company_name,Airplane_type_name
from Company,Airplane
where Company.AirplaneCompanyFlag='True' and Airplane.Company_id=Company.Company_id


Select Airline_name,Flight_leg.Flight_number,Flight_leg.Leg_number,Scheduled_departure_time , Scheduled_arrival_time,Departure_time,Arrival_time
from Flight_leg,Leg_Instance,Airline,Flight
where Flight_leg.Leg_number=Leg_Instance.Leg_number and Flight_leg.Flight_number=Leg_Instance.Flight_number and  Flight_leg.Flight_number=Flight.Flight_number and Airline.Airline_id=Flight.Airline_id


select Airline_id,Airplane_type_name,Departure_airport_code,Arrival_airport_code
from Can_land,Flight_leg,Airport,Flight
where Airport.Airport_code=Can_land.Airport_code and Airport.Airport_code=Flight_leg.Departure_airport_code and Flight.Flight_number=Flight_leg.Flight_number

select Leg_Instance.Flight_number,Leg_Instance.Leg_number,Leg_date,Amount,Restrictions
from Leg_Instance,Fare,Flight_leg,Flight
where Flight.Flight_number=Fare.Flight_number and Leg_Instance.Flight_number=Flight.Flight_number and Leg_Instance.Leg_number=Flight_leg.Leg_number
order by (Amount) desc