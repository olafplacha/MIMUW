import heapq
import cx_Oracle
import sys
import datetime

db_user = 'op429584'
db_pass = ''
cursor = cx_Oracle.connect('op429584', '', "//labora.mimuw.edu.pl/LABS").cursor()

cityStart = sys.argv[1]
cityEnd = sys.argv[2]
dateStart = datetime.datetime.strptime(sys.argv[3], '%Y-%m-%d').strftime('%d-%b-%y').upper()
currentDate = None

try:
	#retrieve start and end cities' ids
	cursor.execute(f"SELECT id FROM CITIES WHERE NAME = '{cityStart}'")
	idStart = cursor.fetchall()[0][0]
	cursor.execute(f"SELECT id FROM CITIES WHERE NAME = '{cityEnd}'")
	idEnd = cursor.fetchall()[0][0]
except:
	print("No such city found!")
	sys.exit()

#how much more we care about time (per hour) than about price (how much dolars is our 1 hour worth)
weightTime = sys.argv[4]

distances = {}
#in the dictionary we keep smallest cost to get to a city, and flight number that got us there
distances[idStart] = (0, None)

pq = [(0, idStart)]

while len(pq) > 0:

    curr_dist, curr_city = heapq.heappop(pq)

    #we have found the best route
    if curr_city == idEnd:
        break

    #if the condition is true then we have already processed this city
    if curr_city in distances.keys() and curr_dist > distances[curr_city][0]:
        continue
    
    if currentDate is None:
        currentDate = dateStart
        #it is a search from our starting point, we dont't care if the flight is in the morning or in the evening
        query = f"SELECT F.ID, A2.IDCITY,\
                    ((TO_DATE(F.DATE_ARR, 'DD-MON-YY HH12:MI:SS AM') - TO_DATE(F.DATE_DEPT, 'DD-MON-YY HH12:MI:SS AM')) * 24\
                    * {weightTime} + F.PRICE_PER_TICKET) AS COST FROM FLIGHTS F\
                    JOIN AIRPORTS A1 ON F.AIRPORT_DEPT = A1.ID\
                    JOIN AIRPORTS A2 ON F.AIRPORT_ARR = A2.ID\
                    JOIN AIRPLANES A ON F.PLANEID = A.ID\
                    JOIN AIRPLANEMODELS AM ON A.MODELID = AM.ID\
                    WHERE A1.IDCITY = {curr_city} AND TO_CHAR(F.DATE_DEPT, 'DD-MON-YY') = '{currentDate}' AND AM.CAPACITY > F.SEATS_TAKEN\
                    ORDER BY A2.IDCITY, COST"

    else:
        #what time we got to this point
        query = f"SELECT DATE_ARR FROM FLIGHTS WHERE ID = {distances[curr_city][1]}"
        currentDate = cursor.execute(query).fetchall()[0][0]
        #TO DO - limit maximum days ahead
        query = f"SELECT F.ID, A2.IDCITY,\
                    ((TO_DATE(F.DATE_ARR, 'DD-MON-YY HH12:MI:SS AM') - TO_DATE('{currentDate}', 'yyyy-mm-dd hh24:mi:ss')) * 24\
                    * {weightTime} + F.PRICE_PER_TICKET) AS COST FROM FLIGHTS F\
                    JOIN AIRPORTS A1 ON F.AIRPORT_DEPT = A1.ID\
                    JOIN AIRPORTS A2 ON F.AIRPORT_ARR = A2.ID\
                    JOIN AIRPLANES A ON F.PLANEID = A.ID\
                    JOIN AIRPLANEMODELS AM ON A.MODELID = AM.ID\
                    WHERE A1.IDCITY = {curr_city} AND F.DATE_DEPT > TO_DATE('{currentDate}', 'yyyy-mm-dd hh24:mi:ss') AND F.DATE_DEPT <(TO_DATE('{currentDate}', 'yyyy-mm-dd hh24:mi:ss') + INTERVAL '48' HOUR) AND AM.CAPACITY > F.SEATS_TAKEN\
                    ORDER BY A2.IDCITY, COST"
    
    visitedTemp = set()
    for r in cursor.execute(query).fetchall():
        city = r[1]
        if city not in visitedTemp:
            visitedTemp.add(city)
            if city not in distances.keys():
                distances[city] = (float('inf'), None)
            cityDist = curr_dist + r[2]
            if distances[city][0] > cityDist:
                distances[city] = (cityDist, r[0])
                heapq.heappush(pq, (cityDist, city))

flights = []
arr = idEnd
#have we found a connection?
flag = True

if arr in distances.keys():
	#we have found a connection
	while arr != idStart:
	    query = f"SELECT F.ID, F.PRICE_PER_TICKET, A1.NAME, A2.NAME, F.DATE_DEPT, F.DATE_ARR, A1.IDCITY FROM FLIGHTS F\
		     JOIN AIRPORTS A1 ON F.AIRPORT_DEPT = A1.ID\
		     JOIN AIRPORTS A2 ON F.AIRPORT_ARR = A2.ID\
		     WHERE F.ID = {distances[arr][1]} "
	    res = cursor.execute(query).fetchall()
	    flights.append(res)
	    arr = res[0][-1]

	sum_price = 0
	for f in flights[::-1]:
	    sum_price += f[0][1]
else:
	#we haven't found any connection
	flag = False
	
#------------DISPLAYING RESULT-----------
	
def format_datetime(date):
	return date.strftime("%Y-%m-%d %H:%M")

def display_result(flights):
	"""
	Arguments: 
	- flights - list with flights to display
	"""
	#store ids in session, so that we can buy tickets for the flights
	ids = ""
	i = 0
	for flight in flights[::-1]:
		ids += f"{flight[0][0]},"
		idF = flight[0][0]
		price = flight[0][1]
		start = flight[0][2]
		end = flight[0][3]
		dateStart = flight[0][4]
		dateEnd = flight[0][5]
		to_print = f'<div class="oneResult" id="or{i}">'
		to_print += f'	<div class="connection" id="flightId">{idF}</div>'
		to_print += f'	<div class="connection">{start}</div>'
		to_print += f'	<div class="connection">{end}</div>'
		to_print += f'	<div class="connection">{format_datetime(dateStart)}</div>'
		to_print += f'	<div class="connection">{format_datetime(dateEnd)}</div>'
		to_print += f'	<div class="connection">	${price}</div>'
		to_print += '</div>'
		print(to_print)
		i += 1
	ids = ids[:-1]
	print(f'<div id="totalPrice">Total price: {sum_price}</div>')
	print(ids)

if flag:
	display_result(flights)
else:
	print('No connection')


