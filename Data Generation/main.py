import csv
from turtle import pd

from faker import Faker
from datetime import datetime, timedelta
import random

fake = Faker()

num_promo_codes = 1000
num_customers = 9000
num_payments = 50000
num_appointments = 75000

num_companies_per_type = 30
num_workers_per_company = 3


service_types = [
    'Haircut & Styling',
    'Massage Therapy',
    'Nail Services',
    'Aesthetic Treatments',
    'Personal Training',
    'Dental Services',
    'Counselling',
    'Tutoring',
    'Photography Sessions',
    'Home Cleaning'
]

company_types = [
    'Barber Shop',
    'Spa & Wellness Center',
    'Beauty Salon',
    'Aesthetic Clinic',
    'Gym',
    'Dental Clinic',
    'Counselling Center',
    'Educational Institute',
    'Photography Studio',
    'Cleaning Service'
]

job_titles = {
    'Barber Shop': 'Barber',
    'Spa & Wellness Center': 'Therapist',
    'Beauty Salon': 'Beautician',
    'Aesthetic Clinic': 'Aesthetician',
    'Gym': 'Personal Trainer',
    'Dental Clinic': 'Dentist',
    'Counselling Center': 'Counselor',
    'Educational Institute': 'Tutor',
    'Photography Studio': 'Photographer',
    'Cleaning Service': 'Cleaner'
}


#Generate Promo Codes
with open('promo_codes.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter='|')
    writer.writerow(['ID', 'Promo code', 'DiscountAmount'])

    for i in range(num_promo_codes):
        promo_code = fake.bothify(text='PROMO-????-####', letters='ABCDEFGHIJKLMNOPQRSTUVWXYZ')
        discount_amount = random.choice([5, 10, 15, 20, 25, 30, 35, 40, 45, 50])

        writer.writerow([i + 1, promo_code, discount_amount])

# Generate Customers
with open('customers2.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter='|')
    writer.writerow(['CustomerID', 'Name', 'Surname', 'DateOfBirth', 'Gender', 'Phonenumber', 'PESEL', 'Email', 'RegistrationDate', 'CompanyID'])
    for i in range(num_customers + 1):
        name = fake.first_name()
        surname = fake.last_name()
        dob = fake.date_of_birth(minimum_age=18, maximum_age=60).isoformat()
        gender = random.choice(['M', 'F'])
        phone_number = str(random.randrange(100000000, 999999999))
        pesel = fake.bothify(text='###########', letters='0123456789')  # Polish national identification number
        email = fake.email()
        registration_date = fake.date_between(start_date='-12y', end_date='-4y').isoformat()
        # Randomly assign a company to a customer from the previously generated companies
        company_id = random.randint(1, 300)

        writer.writerow([i, name, surname, dob, gender, phone_number, pesel, email, registration_date, company_id])

# Generate Payment
with open('payments.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter='|')
    writer.writerow(['PaymentID', 'Amount', 'DatePaid', 'Status', 'PaymentMethod', 'CustomerID'])

    for payment_id in range(1, num_payments + 1):
        amount = round(random.uniform(0, 200), 2)  # Amount paid
        date_paid = fake.date_between(start_date='-4y', end_date='-3y').isoformat()
        status = random.choice(['Not paid', 'Pending', 'Paid'])  # Payment status
        payment_method = random.choice(['Cash', 'Card'])  # Method of Payment
        # Randomly assign a CustomerID from the previously generated customers
        customer_id = random.randint(1, 9000)  # Assuming you have 5000 customers

        writer.writerow([payment_id, amount, date_paid, status, payment_method, customer_id])



# Open the CSV file for companies to write company data
with open('companies.csv', 'w', newline='') as companies_file:
    companies_writer = csv.writer(companies_file, delimiter='|')
    companies_writer.writerow(['CompanyID', 'CompanyName', 'Address', 'PhoneNumber', 'Email', 'Type'])

    # Open the CSV file for workers to write worker data
    with open('workers.csv', 'w', newline='') as workers_file:
        workers_writer = csv.writer(workers_file, delimiter='|')
        workers_writer.writerow(
            ['WorkerID', 'Name', 'Surname', 'DateOfBirth', 'PhoneNumber', 'Email', 'Gender', 'PESEL', 'JobTitle',
             'CompanyID'])

        company_id = 1
        worker_id = 1
        for company_type in company_types:
            for _ in range(num_companies_per_type):
                # Generate company data
                company_name = fake.company()
                address = fake.address().replace('\n', ', ')
                phone_number = ''.join([str(random.randint(0, 9)) for _ in range(9)])
                email = fake.email()
                companies_writer.writerow([company_id, company_name, address, phone_number, email, company_type])

                # Generate workers for this company
                for _ in range(num_workers_per_company):
                    name = fake.first_name()
                    surname = fake.last_name()
                    dob = fake.date_of_birth(minimum_age=18, maximum_age=65).isoformat()
                    worker_phone_number = ''.join([str(random.randint(0, 9)) for _ in range(9)])
                    worker_email = fake.email()
                    gender = random.choice(['M', 'F'])
                    pesel = ''.join([str(random.randint(0, 9)) for _ in range(11)])
                    job_title = job_titles[company_type]
                    workers_writer.writerow(
                        [worker_id, name, surname, dob, worker_phone_number, worker_email, gender, pesel, job_title,
                         company_id])
                    worker_id += 1

                company_id += 1




# Generate Companies
with open('companies.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter='|')
    writer.writerow(['CompanyID', 'CompanyName', 'Address', 'PhoneNumber', 'Email', 'Type'])
    companies = []
    company_id = 1
    for i, company_type in enumerate(company_types):
        for _ in range(num_companies_per_type):
            company_name = fake.company()
            phone_number = str(random.randrange(100000000, 999999999))
            companies.append({'CompanyID': company_id, 'Type': company_type})
            writer.writerow([company_id, company_name, fake.address(), phone_number, fake.company_email(), company_type])
            company_id += 1



# Generate Services
with open('services.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ServiceID', 'ServiceName', 'Duration', 'Cost', 'Type', 'CompanyID'])
    service_id = 1
    for i, service_type in enumerate(service_types):
        for j in range(num_companies_per_type * 10):  # 10 services per company
            service_name = fake.catch_phrase()
            duration = fake.random_int(min=30, max=120)
            cost = round(random.uniform(0, 200), 2)
            # Find companies that match this service type
            company_ids = [c['CompanyID'] for c in companies if c['Type'] == company_types[i]]

            company_id = random.choice(company_ids)
            writer.writerow([service_id, service_name, duration, cost, service_type, company_id])
            service_id += 1


num_appointments_per_service = 7500
total_service_types = len(service_types)

with open('appointments.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter='|')
    writer.writerow([
        'AppointmentID', 'Date', 'Time', 'StartTime', 'EndTime', 'Status',
        'Cost', 'ServiceType', 'PromoCodeUsed', 'ServiceID', 'PromoID', 'CustomerID', 'WorkerID', 'PaymentID'
    ])

    # Loop through each appointment ID
    for i in range(1, num_appointments + 1):
        # Determine service type based on the appointment index
        if i <= 7500:  # 1 to 7500
            service_type = "Haircut & Styling"
            service_id = random.randint(1, 150)
            worker_id = random.randint(1, 75)
        elif i <= 15000:  # 7501 to 15000
            service_type = "Massage Therapy"
            service_id = random.randint(151, 300)
            worker_id = random.randint(76, 150)
        elif i <= 22500:  # 15001 to 22500
            service_type = "Nail Services"
            service_id = random.randint(301, 450)
            worker_id = random.randint(151, 300)
        elif i <= 30000:  # 22501 to 30000
            service_type = "Aesthetic Treatments"
            service_id = random.randint(451, 600)
            worker_id = random.randint(301, 375)
        elif i <= 37500:  # 30001 to 37500
            service_type = "Personal Training"
            service_id = random.randint(601, 750)
            worker_id = random.randint(376, 450)
        elif i <= 45000:  # 37501 to 45000
            service_type = "Dental Services"
            service_id = random.randint(751, 900)
            worker_id = random.randint(451, 525)
        elif i <= 52500:  # 45001 to 52500
            service_type = "Counselling"
            service_id = random.randint(901, 1050)
            worker_id = random.randint(526, 600)
        elif i <= 60000:  # 52501 to 60000
            service_type = "Tutoring"
            service_id = random.randint(1051, 1200)
            worker_id = random.randint(601, 675)
        elif i <= 67500:  # 60001 to 67500
            service_type = "Photography Sessions"
            service_id = random.randint(1201, 1350)
            worker_id = random.randint(676, 750)
        else:  # 67501 to 75000
            service_type = "Home Cleaning"
            service_id = random.randint(1351, 1500)
            worker_id = random.randint(91, 100)

        # Generate additional appointment details
        appointment_date = fake.date_between(start_date='-3y', end_date='-2y')
        appointment_time = fake.time_object(end_datetime=None)
        while appointment_time.hour < 8 or appointment_time.hour > 20:
            appointment_time = fake.time_object(end_datetime=None)

        start_time = datetime.combine(appointment_date, appointment_time)
        end_time = start_time + timedelta(minutes=random.randint(30, 120))
        status = random.choice(['Done', 'Waiting', 'Canceled', 'No Show'])
        cost = round(random.uniform(0, 200), 2)
        promo_code_used = random.choice([1, 0])
        customer_id = random.randint(1, 9000)
        promo_id = random.randint(1, num_promo_codes) if promo_code_used else None
        payment_id = random.randint(1, num_payments)

        # Write appointment details to CSV
        writer.writerow([
            i, appointment_date.isoformat(), appointment_time.isoformat(),
            start_time.time().isoformat(), end_time.time().isoformat(), status, cost, service_type,
            promo_code_used, service_id, promo_id, customer_id, worker_id, payment_id
        ])

#==========================================================================================================================================

# Number of entries you want to generate
num_reviews = 10000

### Generate Worker Reviews
worker_reviews = []
with open('worker_reviews2.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter='|')
    writer.writerow(
        ['ReviewID', 'WorkerID', 'ReviewDate', 'Friendliness', 'Professionalism', 'Punctuality', 'Quality of Work',
         'Rating'])

    for i in range(num_reviews):
        review_id = i + 1
        worker_id = random.randint(1, 920)  # Assuming 900 workers
        review_date = fake.date_between(start_date='-2y', end_date='-1y').isoformat()

        # Generating individual category ratings
        Friendliness = random.randint(0, 5)
        Professionalism = random.randint(0, 5)
        Punctuality = random.randint(0, 5)
        QualityofWork = random.randint(0, 5)

        # Calculating overall rating
        overall_rating = (Friendliness + Professionalism + Punctuality + QualityofWork) / 4

        # Writing each review to the file
        writer.writerow([
            review_id, worker_id, review_date,
            Friendliness, Professionalism, Punctuality, QualityofWork, overall_rating
        ])

# Assuming you have defined num_reviews and fake (Faker instance)
num_company_reviews = 3000  # Total number of company reviews you want to generate

with open('company_reviews2.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter='|')
    writer.writerow(['ReviewID', 'CompanyID', 'Rating', 'ReviewDate'])

    for i in range(num_company_reviews):
        review_id = i + 1
        company_id = random.randint(1,310)
        rating = random.randint(0, 5)  # Assuming rating is an integer, adjust if it should be float
        review_date = fake.date_between(start_date='-2y', end_date='-1y').isoformat()

        writer.writerow([
            review_id, company_id, rating, review_date
        ])

