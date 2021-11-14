--Author: A. Panussis

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--Tables: Worker, Project, Assign, Dept
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--------
--DONE-- 2. Find the details of any project with the word “urn” anywhere in its name.
--------

select * 
from PROJECT
    where projName like '%urn%';

--------
--DONE-- 4. Display an alphabetical list of names of all workers assigned to project 1001, sorted by last name.
--------

select lastName, firstName, projNo
from worker join assign using (empID)
    	where assign.projNo = '1001'
	order by 1;

--------
--DONE-- 6. Display details of the project with the highest budget.
--------

select * 
from PROJECT
    order by budget desc
    limit 1;

--------
--DONE-- 7. Display the names and departments of all workers on project 1019.
--------

select WORKER.lastname, WORKER.firstname, WORKER.departmentID, ASSIGN.projNo
from WORKER join ASSIGN using(empID)
	where ASSIGN.projNo = '1019';

--------
--DONE-- 8. Display an alphabetical list of names and corresponding ratings of all workers on any project that is managed by Michael Burns. Use ‘Michael and ‘Burns’ as conditions.
--------

select WORKER.LASTNAME, WORKER.FIRSTNAME, ASSIGN.RATING
from WORKER   
inner join ASSIGN using(empID)
    where   lastname    = 'Burns'
    and     firstname   = 'Michael'
    order by 1;

--------
-------- 9. Create a view that has project number and name of each project, along with the IDs and names of all
-------- workers assigned to it.
--------

create or replace view V_PROJECT as
	select PROJECT.projNo, PROJECT.ProjName, WORKER.empID, WORKER.lastname, WORKER.firstname
	from PROJECT 
	join WORKER ON(projmgrID = empID)
	group by projNo

--------
--DONE-- 10. Using the view created in Exercise 9, find the project number and project name of all projects to which employee 1001 is assigned. (assuming this is a typo and the emplo9yee is 101)
--------

--Assuming we are looking for employee 101,  we do the following:

select *
from V_PROJECT
    where empID = '101'

--Assuming we are looking for employee 1001,  we do the following:

select *
from V_PROJECT
    where empID = '1001'

--------
--DONE-- 12. Change the hours, which employee 110 is assigned to project 1019, from 20 to 10.
--------

update ASSIGN
set hoursassigned = 20
	where empID = 110 AND projNo = 1019;

--------
--DONE-- 14. For each project, list the project number, how many workers are assigned to it and how many hours
--------they are assigned for.
--------

select DISTINCT (projNo), empID, hoursassigned
from ASSIGN

--------
--DONE-- 16. Display a list of project numbers and names and starting dates of all projects that have the same starting date.
--------

select projNo, projName, startDate
from PROJECT
    where startDate in(
        select startDate
        from PROJECT
        group by startDate having count(*) > 1
    )


--------
-------- 17. Add a field called status to the Project table (Sample values for this field are active, completed, planned, cancelled). 
-------- Update the Projects table and make some of them active, one completed and one cancelled. Display a list of all ‘active’ projects.
--------

--After editing the table columns through right-click menu, we execut the following.

update PROJECT
set status = 'Active'
    where projNo = '1001'

update PROJECT
set status = 'Active'
    where projNo = '1005'

update PROJECT
set status = 'Cancelled'
    where projNo = '1031'

update PROJECT
set status = 'Completed'
    where projNo = '1032'


update PROJECT
set status = 'Active'
    where projNo = '1033'

select *
from PROJECT
    where status = 'Active'

--------
--DONE-- 18. Display the employee ID and project number of all employees who have no ratings on that project.
--------

select empID, projNo
from ASSIGN join PROJECT using (projNo)
	where   ASSIGN.rating IS NULL
	and     PROJECT.status = 'Active'

--------
-------- 19. Add a field called numEmployeesAssigned to the Project table.
-------- Use the UPDATE command to insert values into the field to correspond to the current information in the Assign table.
--------

alter table PROJECT
    add numEmployeesAssigned NUMBER

--------
--DONE-- 20. Write a trigger that will update the numEmployeesAssigned field correctly whenever an assignment is made, dropped, or updated.
--------

CREATE OR REPLACE TRIGGER update_NUMEMPLOYEESASSIGNED 
BEFORE DELETE OR INSERT OR UPDATE ON ASSIGN 
BEGIN
  if inserting then
        update PROJECT set numEmployeesAssigned = numEmployeesAssigned +1
           where PROJECT.projNo = projNo;
    end if;
    
    if deleting then
        update PROJECT set numEmployeesAssigned = numEmployeesAssigned -1
           where PROJECT.projNo = projNo;
    end if;
    
    if updating then
        update PROJECT set numEmployeesAssigned = numEmployeesAssigned -1
           where PROJECT.projNo = projNo;
        update PROJECT set numEmployeesAssigned = numEmployeesAssigned +1
           where PROJECT.projNo = projNo;
    end if;
END;


