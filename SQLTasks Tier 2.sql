/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT name
FROM country_club.Facilities
WHERE membercost > 0;


/* Q2: How many facilities do not charge a fee to members? */
SELECT
COUNT(name)
FROM country_club.Facilities
WHERE membercost = 0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM country_club.Facilities
WHERE membercost > 0 AND membercost < .2*monthlymaintenance;

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM country_club.Facilities
WHERE facid 
IN (1,5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance < 100 THEN 'cheap'
  ELSE 'expensive' END
FROM country_club.Facilities;



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname, joindate
FROM country_club.Members
INNER JOIN (
  SELECT MAX(joindate) AS most_recent_join
  FROM country_club.Members
) AS max_date
  ON max_date.most_recent_join = Members.joindate;

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT Facilities.name, concat_ws(' ', Members.firstname, Members.surname) AS fullname
FROM country_club.Bookings
LEFT JOIN country_club.Members
  ON Members.memid = Bookings.memid
LEFT JOIN country_club.Facilities
  ON Facilities.facid = Bookings.facid
WHERE Bookings.facid IN (0, 1)
ORDER BY fullname;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT Facilities.name, concat_ws(' ', Members.firstname, Members.surname) AS fullname,
CASE WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost 
  ELSE Bookings.slots * Facilities.membercost END AS cost
FROM country_club.Bookings
LEFT JOIN country_club.Facilities
  ON Bookings.facid = Facilities.facid
LEFT JOIN country_club.Members
  ON Members.memid = Bookings.memid
WHERE starttime BETWEEN '2012-09-14' AND '2012-09-15'
HAVING cost < 30
ORDER BY Facilities.membercost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT * from 
(
    SELECT Facilities.name, concat_ws(' ', Members.firstname, Members.surname) AS fullname,
CASE WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost 
  ELSE Bookings.slots * Facilities.membercost END AS cost
FROM country_club.Bookings
LEFT JOIN country_club.Facilities
  ON Bookings.facid = Facilities.facid
LEFT JOIN country_club.Members
  ON Members.memid = Bookings.memid
WHERE starttime BETWEEN '2012-09-14' AND '2012-09-15'
)as jubbles
WHERE cost < 30
ORDER BY cost DESC;




/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


sum
name
270.0
Pool Table
240.0
Snooker Table
180.0
Table Tennis


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

firstname	surname	recommendedby	RECNAME	RECSURNAME	
Florence	Bader	9	Ponder	Stibbons
Anne	Baker	9	Ponder	Stibbons
Timothy	Baker	13	Jemima	Farrell
Tim	Boothe	3	Tim	Rownam
Gerald	Butters	1	Darren	Smith
Joan	Coplin	16	Timothy	Baker
Erica	Crumpet	2	Tracy	Smith
Nancy	Dare	4	Janice	Joplette
David	Farrell		GUEST	GUEST
Jemima	Farrell		GUEST	GUEST
Matthew	Genting	5	Gerald	Butters
GUEST	GUEST		GUEST	GUEST
John	Hunt	30	Millicent	Purview
David	Jones	4	Janice	Joplette
Douglas	Jones	11	David	Jones
Janice	Joplette	1	Darren	Smith
Anna	Mackenzie	1	Darren	Smith
Charles	Owen	1	Darren	Smith
David	Pinker	13	Jemima	Farrell
Millicent	Purview	2	Tracy	Smith
Tim	Rownam		GUEST	GUEST
Henrietta	Rumney	20	Matthew	Genting
Ramnaresh	Sarwin	15	Florence	Bader
Darren	Smith		GUEST	GUEST
Darren	Smith		GUEST	GUEST
Jack	Smith	1	Darren	Smith
Tracy	Smith		GUEST	GUEST
Ponder	Stibbons	6	Burton	Tracy
Burton	Tracy		GUEST	GUEST
Hyacinth	Tupperware		GUEST	GUEST
Henry	Worthington-Smyth	2	Tracy	Smith



/* Q12: Find the facilities with their usage by member, but not guests */
name	total_slots	
Badminton Court	1086
Massage Room 1	884
Massage Room 2	54
Pool Table	856
Snooker Table	860
Squash Court	418
Table Tennis	794
Tennis Court 1	957
Tennis Court 2	882



/* Q13: Find the facilities usage by month, but not guests */


month	name	total_slots	
7	Badminton Court	165
7	Massage Room 1	166
7	Massage Room 2	8
7	Pool Table	110
7	Snooker Table	140
7	Squash Court	50
7	Table Tennis	98
7	Tennis Court 1	201
7	Tennis Court 2	123
8	Badminton Court	414
8	Massage Room 1	316
8	Massage Room 2	18
8	Pool Table	303
8	Snooker Table	316
8	Squash Court	184
8	Table Tennis	296
8	Tennis Court 1	339
8	Tennis Court 2	345
9	Badminton Court	507
9	Massage Room 1	402
9	Massage Room 2	28
9	Pool Table	443
9	Snooker Table	404
9	Squash Court	184
9	Table Tennis	400
9	Tennis Court 1	417
9	Tennis Court 2	414




THE CODE

SELECT SUM(cost) as sum, name

FROM (SELECT Facilities.name, Bookings.bookid,
CASE WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost 
  ELSE Bookings.slots * Facilities.membercost END AS cost
FROM country_club.Bookings
LEFT JOIN country_club.Facilities
  ON Bookings.facid = Facilities.facid
LEFT JOIN country_club.Members
  ON Members.memid = Bookings.memid) AS booking_cost
GROUP BY name
HAVING sum < 1000;

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT Members.firstname, Members.surname, Members.recommendedby, actual_members.firstname as RECNAME, actual_members.surname as RECSURNAME
FROM country_club.Members
LEFT JOIN country_club.Members as actual_members
  ON Members.recommendedby = actual_members.memid
ORDER BY surname , firstname;

/* Q12: Find the facilities with their usage by members, but not guests */

SELECT member_bookings.name, SUM(member_bookings.slots) as total_slots
FROM (SELECT Bookings.bookid, Bookings.slots, Bookings.memid, Facilities.name
FROM country_club.Bookings
LEFT JOIN country_club.Facilities
  ON Bookings.facid = Facilities.facid
WHERE memid != 0) AS member_bookings
GROUP BY member_bookings.name;


/* Q13: Find the facilities usage by month, but not guests */


SELECT month(member_bookings.starttime) as month, member_bookings.name, SUM(member_bookings.slots) as total_slots
FROM (SELECT Bookings.bookid, Bookings.slots, Bookings.memid, Facilities.name, Bookings.starttime
FROM country_club.Bookings
LEFT JOIN country_club.Facilities
  ON Bookings.facid = Facilities.facid
WHERE memid != 0) AS member_bookings
GROUP BY month(member_bookings.starttime), member_bookings.name;



