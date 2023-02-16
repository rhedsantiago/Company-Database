drop schema if exists company;
create database company;
use company;

create table person(
	personal_id int(10),
    first_name varchar(255),
    last_name varchar(255),
    c_flag boolean,
    e_flag boolean,
    title varchar(255),
    e_rank varchar(255),
    super_id int(10),
    pe_flag boolean,
    age int check (age < 65 or age is null),
    gender varchar(255),
    address varchar(255),
    email varchar(255),
    primary key (personal_id),
    foreign key (super_id) references person(personal_id),
    -- check that if e_flag is false then employee attributes are null, if true then populated
    check ((e_flag is false and title is null and e_rank is null and super_id is null) 
		OR (e_flag is true and title is not null and e_rank is not null))
);
create table preferred_salesperson(
	personal_id int(10),
    salesperson_id int(10),
    foreign key (personal_id) references person(personal_id),
    foreign key (salesperson_id) references person(personal_id)
);
create table phone_no(
	personal_id int(10),
    phone_no int(10),
    foreign key (personal_id) references person(personal_id)
);
create table monthly_salary(
	employee_id int(10),
    transaction_amount double,
    transaction_no int,
    pay_date date,
    primary key (employee_id,transaction_no),
    foreign key (employee_id) references person(personal_id)
);
create table department(
	dept_id int,
    dept_name varchar(255),
    primary key (dept_id)
);
create table job_position(
	job_id int,
    dept_id int,
    job_description varchar(225),
    post_date date,
    primary key (job_id),
    foreign key (dept_id) references department(dept_id)
);
create table interviews(
	interviewer_id int(10),
    applicant_id int(10),
    job_id int,
    interview_time datetime,
    score double check (score between 0 and 100),
    foreign key (interviewer_id) references person(personal_id),
    foreign key (applicant_id) references person(personal_id),
    foreign key (job_id) references job_position(job_id)
);
create table works_for(
	employee_id int(10),
    dept_id int,
    shift_start time,
    shift_end time,
    foreign key (employee_id) references person(personal_id),
    foreign key (dept_id) references job_position(dept_id),
    check (shift_start < shift_end)
);
create table marketing_site(
	site_id int,
    site_name varchar(255),
    site_location varchar(255),
    primary key (site_id)
);
create table works_on(
	employee_id int(10),
    site_id int,
    foreign key (employee_id) references person(personal_id),
    foreign key (site_id) references marketing_site(site_id)
);
create table product(
	product_id int,
    product_type varchar(255),
    list_price double,
    size double,
    weight double,
    style varchar(255),
    primary key (product_id)
);
create table transaction(
	transaction_id int,
    product_id int,
    customer_id int(10),
    site_id int,
    salesperson_id int(10),
    trans_date datetime,
    foreign key (customer_id) references person(personal_id),
    foreign key (product_id) references product(product_id),
    foreign key (site_id) references marketing_site(site_id),
    foreign key (salesperson_id) references person(personal_id),
    primary key (transaction_id)
);
create table vendor(
	vendor_id int,
    vendor_name varchar(255),
    acc_no int unique,
    purchasing_url varchar(255),
    address varchar(255),
    primary key (vendor_id)
);
create table vendor_account(
	acc_no int,
    credit_rating double,
    foreign key (acc_no) references vendor(acc_no)
);
create table part(
	part_no int,
    part_type varchar(255),
    weight double,
    primary key (part_no)
);
create table supplies(
	vendor_id int,
    part_no int,
    price double,
    foreign key (vendor_id) references vendor(vendor_id),
    foreign key (part_no) references part(part_no)
);
create table uses(
	part_no int,
    product_id int,
    part_count int,
    foreign key (part_no) references part(part_no),
    foreign key (product_id) references product(product_id)
);
create view view1 as
	select employee_id, avg(transaction_amount) as avg_salary
    from monthly_salary
    group by employee_id;
create view view2 as
	select applicant_id, job_id, count(score > 60) as pass_count
    from interviews
    group by applicant_id, job_id;
create view view3 as
	select p.product_type, count(t.product_id)
    from transaction t
	join product p on p.product_id = t.product_id
    group by p.product_type;
create view view4 as
	select u.product_id, sum(u.part_count*s.price) as cost
    from uses u
    join supplies s on u.part_no = s.part_no;
    
	
		