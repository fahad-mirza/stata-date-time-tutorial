
* Purpose: 	Working with date and time variables
* Date:		16/03/2021
* Made By:	Fahad Mirza


* 	Data types and storage types: 
* 	Dates can be stored by Stata either in String or Numeric format 

* 	We have 5 types of numeric storage options in Stata and each is used according to
* 	the need to accuracy required
* 		1. byte
*		2. int
*		3. long 
* 		4. float (Default)
*		5. double

* 	String format stores data as str##. ## tells us the maximum length of the string

* 	Technically, Stata decides for us the best storage type but when it comes to dates,
* 	we need to be mindful of a certain case where Stata default storage type may not be
* 	suitable

* 	Dates and times usually come in the human readable string forms, such as 
*		“January 01, 2021 15:00 pm”
*		“2021.01.01 15:00” 

* 	For Stata however, dates need to be in numeric value in order for calculation to take place
* 	Then the question arises how will it be readable to us then?

* 	For this we need to understand how Stata reads and calculates dates.
* 	Stata has a reference (base point) from where it evaluates and calculates operations
* 	related to date.

* 	The base value is 0. The question then is, what is 0?
* 	The value 0 is given to the datetime variable value 01jan1960 00:00:00.000
* 	This value is then measured in milliseconds.

* 	Therefore, “25jan2016 08:30:25” will be 1769329825000 (milliseconds) for Stata.

********************************************************************************

*	Display Format: 
* 	This allows us to format numeric values in a way that is readable to you

* 	The following Stata command:
* 										format timevar %td 
*	sets timevar as a date variable. 

* 	Here timevar is already a numeric date and time variable.
* 	format timevar %tcHH:MM:SS 
* 	Further sets timevar to be displayed as hour(00-23) : minute (00-59) : second (00-60)

* 	format var %fmt 
* 	Essentially, the command right above changes display format but not the contents of the variable.
* 	% indicates the start of formatting, which can be a number, date, string, business calendar etc.



* 	DATE _ TIME _ CONVERSION _ TABLE

*								Base Value		Format	Storage Type		Function for String 
*																			to Numeric conversion
*	--------------------------------------------------------------------------------------------------------
*	datetime				|
*	(assuming 86400 s/day)	|	01jan1960		%tc		must be double		clock()
*							|			
*	datetime				|
*	(equivalent to UTC)		|	01jan1960		%tC		must be double		Clock()
*							|
*	date					|	01jan1960		%td		may be float/long	date()
*							|
*	weekly date				|	1960 week 1		%tw		may be float/int	weekly()
*							|	
*	monthly date			|	jan 1960		%tm		may be float/int	monthly()
*							|
*	quarterly date			|	1960 quarter 1	%tq		may be float/int	quarterly()
*							|
*	half-yearly date		|	1960 half-yr 1	%th		may be float/int	halfyearly()
*							|
*	yearly date				|	0 A.D			%ty		may be float/int	yearly()


********************************************************************************

*	Conversion Method:

*	In the last column of the table above we have introduced the functions: 

*	function(string, mask[,topyear]) 

*	that transform strings to the numeric date and time variables.

*	In those functions, mask specifies the order of the components appearing in the string.


*	Mask	|	Description
*	-------------------------------------------------------	
*	M		|	month (Has to be capitalized)
*	D		|	day	(Has to be capitalized)
*	Y		|	4-digit year (Has to be capitalized)
*	19Y		|	2-digit year to be interpreted as 19xx (If it is a 2 digit year)
*	20Y		|	2-digit year to be interpreted as 20xx (If it is a 2 digit year)	
*	h		|	hour of day
*	m		|	minutes within hour
*	s		|	seconds within minute
*	#		|	ignore one element
	
	
* 	Here are some examples of the strings and their corresponding masks:

*	Date Time					|	Mask Code
*	----------------------------------------------------
*	“25jan2016 08:30:25”		|	“DMYhms”
*	“2016-01-25 08:30:25”		|	“YMDhms”
*	“16-01-25 08:30”			|	“20YMDhm”
*	“08:30:25 UTC 01252016”		|	“hms#MDY”


********************************************************************************

	* Jumping to the dataset "date_time_tutorial.dta" we see that dates are stored in
	* string format and so we can create a date version by adding the function 'date'
	* Date function then uses the mask of day, month and year
//
cd "C:\Users\Amber\Dropbox\Econ532 - Stata Diaries\00 Datasets\01 Dta Files\04 Other"
use "date_time_tutorial", clear
	generate bday = date(birthday, "DMY"), after(birthday)
	
	* This generated a numeric count in days since we used the date function and not clock
	
	* As discussed earlier, these values are not intuitive to a reader which is why
	* we add a format to the mask to make it readable
	
	format bday %td
	list bday
	
	* This then gives us a 'form' of value label on top of a numeric value (however, it is not a value label)
	
	* The date function itself is quite versatile and can handle uncleaned dates
	* to a certain extent which makes our job easier. As long as there is some sort
	* of delimiter between date values, the date function will work so observations
	* such as jan21998 will not be picked by the date function however, observations
	* jan2,1998 will be properly picked by Stata date function.
	
	* If we look at birthday2, there are slash and dots in the observations and
	* if we were to manually fix, it would require subinstr first before trying
	* to format it.
	
	generate bday2 = date(birthday2, "DMY"), after(birthday2)
	format bday2 %td 
	
	* As we can see the variable is pretty much equivalent even though there were inconsistencies
	
	
	
	* In order to see which date means what number, we can use the 'display' command
	
	display date("5-12-1998", "MDY")
	display td(21jun2021)
	* This gives us the number value behind this date
	
	display %td date("5-12-1998", "MDY")
	* THis shows us how the date will look like once we add a format 
	
	display clock("5-12-1998 11:15", "MDY hm")
	* This gives us the numeric value behind datetime variable (in exponential form)
	
	display %20.0gc clock("5-12-1998 11:15", "MDY hm")
	* This allows us to see the entire value without exponential form
	
	display %tc clock("5-12-1998 11:15", "MDY hm")
	* This allows us to see how the datetime looks like once we add a format
	
	
	* Up until now we saw that date stored in a single variable with problems
	* can easily still be formatted into readable format using date function
	* However, what if all these are kept separately?
	
	
	* We will now work with the variables month, day and year.
	list month day year 
	
	
	* For forming a single variable using these, we use the mdy function
	* However, this function requires we convert values to numeric first
	destring month day year, replace 
	generate bday3 = mdy(month,day,year), after(year)
	format bday3 %td
	
	
	* Now we want to see date time variables or in other words, timestamps.
	* These are observations that contain both date and time which are useful in
	* numerous ways such as caluclating time taken for survey to complete,
	* time taken for quiz to complete, response times, quality checks etc.
	* Sometimes you want to put a constraint that a particular question requires
	* a minimum of x minutes of time to complete, if it doesnt happen then that
	* is marked by a flag.
	
	* We know that datetime requires the clock function for it to work so lets try
	* it out
	
	generate comp_time = clock(survey_completed_time, "DMYhms")		//Since this is in the table above
	* But what just happened? Why didn't Stata read this format?
	
	* The answer is in the fact that we did not follow the way text was stated
	* as month comes first, then day, then time, then year, lets try and redo
	
	drop comp_time
	generate comp_time = clock(survey_completed_time, "MDhmsY")
	* That is odd we just followed the text exactly...then why the missing observations?
	
	* The answer lies in the fact that there are extra text (day and UTC) which are coming
	* in the way. We need to address those before moving to formatting.
	
	* A general though would be to use substr and subinstr to solve this problem
	* or possibly even use split to later combine these back to a form that can
	* be converted and formatted. Luckily or rather, awesomely, Stata helps with this
	
	* We can make use of a hashtag (not the twitter one) to exlude elements we dont desire
	* and tell Stata to skip them. Hence lets have a look:
	
	drop comp_time
	generate comp_time = clock(survey_completed_time, "#MDhms#Y")
	* Voila, we have 2 filled values while the other are missing. These are missing
	* because their format is slightly different from those above. 
	* To solve for this we run another followup code:
	replace comp_time = clock(survey_completed_time, "MDYhm") if comp_time==.
	* Ah ha, we now have a complete variable. Notice I did not use hms but rather hm
	* this is because there was no seconds indicator there.
	
	* Lets apply format to confirm whether our conversion is correct
	format comp_time %tc 
	* This is odd. How come there is a slight difference in values?
	
	* This is where storage type comes in. For formats such as clock, we need to use
	* the double storage format and not float in order to maintain precision
	
	* lets redo this the correct way:
	drop comp_time 
	generate double comp_time = clock(survey_completed_time, "#MDhms#Y")
	replace comp_time = clock(survey_completed_time, "MDYhm") if comp_time==.
	format comp_time %tc 
	
	* Lets also complete the submission time variable
	generate double subm_time = clock(survey_submitted_time, "#MDhms#Y")
	replace subm_time = clock(survey_submitted_time, "MDYhm") if subm_time==.
	format subm_time %tc
	
	* Now we can do loads of calculation as we desire on date and time. A glimpse
	
	* How about we find elapsed time for survey?
	generate double elapsed = subm_time - comp_time
	* This gives us time in milliseconds as format in milliseconds (%tc)
	* Not so useful and probably hours or minutes makes more sense and so...
	
	drop elapsed
	generate double elapsed = hours(subm_time - comp_time)
	
	* To convert to minutes just multiply by 60
	replace elapsed = elapsed*60
	* or use the following: generate double elapsed = (hours(subm_time-comp_time))*60
	* and so on so forth
	
	* We can also extract elements from our numeric date time variable for use
	* Suppose we wanted to extract the month in which birthday happens
	
	generate bdaymth3 = month(bday3)		// Month
	generate bdayday3 = day(bday3)			// Day
	generate bdayyr3  = year(bday3)			// Year
	
	* However, this doesnt work when you have a datetime variable as it requires one
	* additional function to work
	generate subm_month = month(dofc(subm_time))
	* Day of clock (dofc) is what tells Stata that this variable is in clock format
	




