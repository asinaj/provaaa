options symbolgen mprint mlogic VALIDVARNAME=any;

* info could be LEN length FMT format INFMT LABEL TYPE;
%macro varexist(data,var,info);
	%local macro  parmerr  ds  rc  varnum;
	%let macro = &sysmacroname;
	%let ds = %sysfunc(open(&data)); /* opens a SAS dataset*/

	%if (&ds) %then /* if dataset is opened successfully*/
		%do;
			%let var_position = %sysfunc(varnum(&ds, &var)); /* position of variable in dataset*/
			%let var_type = %sysfunc(vartype(&ds, &var_position));
			%let var_fmt = %sysfunc(varfmt(&ds, &var_position));

			%if (&var_position) %then /* if varnum > 0 so variable exists*/
				%do;
					%if (%length(&info)) %then /* if a third parameter is mentioned*/
						%do;
							%if (&info eq num) %then /* NUM means column position number should be found*/
								%do;
									%put ERROR: "Position of variable is number &var_position";  /*contains the position number of the column*/
								%end;
							%else %if (&info eq type) %then
								%do;
									%put ERROR: "Type of variable is &var_type";
								%end;
							%else %if (&info eq fmt) %then
								%do;
									%put ERROR: "Format of variable is &var_fmt";
								%end;
							%else
								%do;
									%sysfunc(var&info(&ds,&var_position));
							/* VARLEN length of a variable, VARFMT,.. VARTYPEVARLEN requires position of column in 2nd argument*/
								%end;
						%end;
					%else /* A third parameter is not mentioned*/
						%do;
							&var_position /* returns position of variable*/
						%end;
				%end;
			%else 0; /* variable is not found in dataset*/
			%let rc = %sysfunc(close(&ds)); /* closing dataset*/
		%end;
	%else 0; /* No access to dataset*/
%mend varexist;

%put %varexist(sashelp.cars, MSRP, fmt);
%put %varexist(sashelp.cars, MSRP, type);
%put %varexist(sashelp.cars, MSRP, num);
%put %varexist(sashelp.cars, MSRP, poz);
/* format, type, position of a variable in a data set */

/* 

check if not missing value for a given variable
verify that some variable does not contain duplicates
verify that some date in the 1st row is oldest (descending order)
do some calculations for dates with previous observation
comparison between dates (variables) within same observation
verify that last observation date of a variable is = to sth.
llallalalallal
*/