from robot.api.deco import library, keyword
from faker import Faker
import random

fake = Faker()

@library
class GenCar():
    ''' Library for gen car
    '''

    @keyword
    def generate_car(self, make=None, plate=None):
        if make == None or make == "None":
            make = fake.first_name()
            
        model = fake.last_name()
        mileage = random.randint(100, 20000)
        year = fake.year()
        if plate == None or plate == "None":
            new_plate = ""
            for _ in range(3):
                new_plate += fake.random_letter().upper()
            plate = new_plate + "-" + str(fake.random_number(3, True))
        
        return make, model, mileage, year, plate
    
# g = GenCar()
# print(g.generate_car())
# print(g.generate_car("ABC-123"))

