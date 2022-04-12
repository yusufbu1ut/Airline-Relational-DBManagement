-- Information of the person whose card number is determined in THY
Select *
From Customer,Airline
where Customer.Customer_id=(Select FFC.Customer_id from FFC where FFC.FFC_card_no= and Airline.Airline_id=FFC.Airline_id) 


-- Flight information with flight number 1 and fare code 7
SELECT *
from Flight
where Flight.Flight_number=(Select Fare.Flight_number from Fare where Fare.Fare_code=7)


--Information of the person sitting at number 21 on the flight from Amsterdam to Greenland
Select *
from Customer
where Customer.Customer_id=(Select Seat_reservation.Customer_id from Seat_reservation where Seat_reservation.Flight_number=1 and Seat_reservation.Leg_number=7 and Seat_number=21)


--THY company A380 aircraft information 
Select *
from Airplane
where Airplane.Company_id=(select Company.Company_id from Company where Company.Company_name='T�rk Hava Yollar� A.�.' and Airplane.Airplane_type_name='A380')